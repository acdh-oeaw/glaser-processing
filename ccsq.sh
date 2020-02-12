#!/bin/bash

###############################################################################
# Post Processing for Glaser Squeeze Scans
#  + Stp 1: duplicate to \processed\{batchno} && move to \archive\{batchno}
#  + Stp 2: convert texture to vertex color (mlx), save as ply
#  + Stp 3: produce nxs streamable (nexus)
#  + Stp 4: cleanup/move results to dest

origdir='/home/acdh_glaser/raw/2019_11'
processeddir='/home/acdh_glaser/processed/2019_11'
compresseddir='/home/acdh_glaser/compressed'
maxcount=0
pcount=9

now=`date +'%Y-%m-%d'`
start=`date +'%s'`
count=`find ${origdir}/* -maxdepth 0 -type d -print| wc -l`

mkdir ${processeddir}


cd ${origdir}
#  + Stp 2: postprocessing / smoothing (mlx)
i=1
q=0
for entry in * ; do
    if [[ ${q} = 0 ]]; then
        parallel="mymeshlabserver -i ${entry}/AT-OeAW-BA-3-27-A-${entry}.obj -o ${entry}/AT-OeAW-BA-3-27-A-${entry}.ply  -m vc fq -s ../../../meshlab_scripts/texture2color.mlx"
    else
        parallel+="& mymeshlabserver -i ${entry}/AT-OeAW-BA-3-27-A-${entry}.obj -o ${entry}/AT-OeAW-BA-3-27-A-${entry}.ply  -m vc fq -s ../../../meshlab_scripts/texture2color.mlx"
    fi
    ((q++))
    if [[ ${q} = ${pcount} ]]; then
        eval "${parallel}"
        wait
        parallel=""
        q=0
    fi
    ((i++))
    if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
        break;
    fi
done

#  + Stp 3: produce nxs streamable (nexus)
i=1
q=0
for entry in * ; do
    if [[ ${q} = 0 ]]; then
        parallel="nxsbuild $entry/AT-OeAW-BA-3-27-A-$entry.ply -C"
    else
        parallel+="& nxsbuild $entry/AT-OeAW-BA-3-27-A-$entry.ply -C"
    fi
    ((q++))
    if [[ ${q} = ${pcount} ]]; then
        eval "${parallel}"
        wait
        parallel=""
        q=0
    fi
    ((i++))
    if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
        break;
    fi
done

#  + Stp 4: cleanup/move results to dest
i=1
for entry in * ; do
  echo "********************************************"
  echo "moving results to target $i out of $count ($entry)"
  mv ${entry}/AT-OeAW-BA-3-27-A-${entry}.nxs ${processeddir}
  mv ${entry}/AT-OeAW-BA-3-27-A-${entry}.ply ${processeddir}
  cp ${entry}/AT-OeAW-BA-3-27-A-${entry}.tif ${processeddir}
  ((i++))
  if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
    break;
  fi
done
finish=`date +'%s'`