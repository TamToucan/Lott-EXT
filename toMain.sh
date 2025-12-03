#!/bin/bash
for dir in Cave-LIB DistanceMap-LIB Maze-LIB Tracker-LIB Libs
do
   cd $dir
   git checkout main
   cd ..
done
git add -u
git commit -m"Update to main"
git push

