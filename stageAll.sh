#!/bin/bash
for dir in Cave-Lib DistanceMap-Lib Maze-Lib Tracker-Lib Libs
do
   cd $dir
   git add -u
   echo "DIR $dir"
   git status
   cd ..
done

