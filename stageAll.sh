#!/bin/bash
for dir in GDCave-EXT GDDistanceMap-EXT GDMaze-EXT GDTracker-EXT Libs
do
   cd $dir
   git add -u
   echo "DIR $dir"
   git status
   cd ..
done

