#!/bin/bash

###############################################################################
# Post Processing for Glaser Squeeze Scans
#  + Stp 1: duplicate to \processed\{batchno} && move to \archive\{batchno}
#  + Stp 2: convert texture to vertex color (mlx), save as ply
#  + Stp 3: produce nxs streamable (nexus)
#  + Stp 4: cleanup in raw/processed

origdir='/home/acdh_glaser/raw/old_project'
processeddir='/home/acdh_glaser/processed'
compresseddir='/home/acdh_glaser/compressed'
maxcount=1

now=`date +'%Y-%m-%d'`
start=`date +'%s'`
count=`find $origdir/* -maxdepth 0 -type d -print| wc -l`

mkdir $processeddir/$now

#  + Stp 2: postprocessing / smoothing (mlx)
cd $origdir
i=1
for entry in * ; do
  echo "********************************************"
  echo "creating ply for squeeze $i out of $count ($entry)"
  mymeshlabserver -i ${entry}/AT-OeAW-BA-3-27-A-${entry}.obj -o ${entry}/AT-OeAW-BA-3-27-A-${entry}.ply  -m vc fq -s ../../../meshlab_scripts/texture2color.mlx
  ((i++))
  if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
    break;
  fi
done

#  + Stp 3: produce nxs streamable (nexus)
i=1
for entry in * ; do
  echo "********************************************"
  echo "creating streamable for squeeze $i out of $count ($entry)"
  nxsbuild $entry/AT-OeAW-BA-3-27-A-$entry.ply -C
  ((i++))
  if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
    break;
  fi
done

#  + Stp 3: produce nxs streamable (nexus)
i=1
for entry in * ; do
  echo "********************************************"
  echo "moving results to target $i out of $count ($entry)"
  mv ${entry}/AT-OeAW-BA-3-27-A-${entry}.nxs ${processeddir}/${now}
  mv ${entry}/AT-OeAW-BA-3-27-A-${entry}.ply ${processeddir}/${now}
  ((i++))
  if [[ ${i} > ${maxcount} && ${maxcount} > 0 ]]; then
    break;
  fi
done


finish=`date +'%s'`