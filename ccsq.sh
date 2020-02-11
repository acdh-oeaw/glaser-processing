#!/bin/bash

###############################################################################
# Post Processing for Glaser Squeeze Scans
#  + Stp 1: duplicate to \processed\{batchno} && move to \archive\{batchno}
#  + Stp 2: postprocessing / smoothing (mlx)
#  + Stp 3: produce analysis image by (mlx)
#  + Stp 4: convert texture to vertex color (mlx)
#  + Stp 5: produce temporary ply
#  + Stp 6: produce nxs streamable (nexus)
#  + Stp 7: produce metadata for adlib
#  + Stp 8: cleanup in raw/processed

origdir = ''
meshlabserverpath = ''

now=`date +'%Y-%m-%d'`
start=`date +'%s'`
count=`find /home/acdh_glaser/raw/* -maxdepth 0 -type d -print| wc -l`
# # Xvfb :100
# # export DISPLAY=:100.0
#
# mkdir /home/acdh_glaser/processed/$now
#
# #  + Stp 1: duplicate to \processed\{batchno} && move to \archive\{batchno}
# cd /home/acdh_glaser/raw/
# i=1
# for entry in */ ; do
#   echo "*****************************************"
#   echo "copying squeeze $i out of $count (AT-OeAW-BA-3-27-A-$entry)"
#   cp -r $entry /home/acdh_glaser/processed/$now
#   ((i++))
# done

#  + Stp 2: postprocessing / smoothing (mlx)
cd /home/acdh_glaser/processed/$now
i=1
for entry in * ; do
  echo "********************************************"
  echo "processing squeeze $i out of $count ($entry)"
  mymeshlabserver -i $entry/AT-OeAW-BA-3-27-A-$entry.obj -o $entry/AT-OeAW-BA-3-27-A-$entry.ply  -m vc fq wt -s ../../../meshlab_scripts/texture2color.mlx
  #nxsbuild ../../../../acdh_glaser/processed/2018-09-27/A54_04_r/AT-OeAW-BA-3-27-A-A54_04_r.ply -C
  ((i++))
done


finish=`date +'%s'`
