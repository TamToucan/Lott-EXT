#!/bin/bash
for dir in GDCave-EXT GDDistanceMap-EXT GDMaze-EXT GDTracker-EXT Libs
do
   cd $dir
   echo "DIR $dir"
   git difftool --staged
   cd ..
done

