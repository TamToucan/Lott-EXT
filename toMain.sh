#!/bin/bash
for dir in GDCave-EXT GDDistanceMap-EXT GDMaze-EXT GDTracker-EXT Libs
do
   cd $dir
   git checkout main
done
cd ..
git add -u
git commit -m"Update to main"
git push

