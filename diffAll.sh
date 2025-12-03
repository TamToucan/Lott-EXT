#!/bin/bash
for dir in Cave-LIB DistanceMap-LIB Maze-LIB Tracker-LIB Libs
do
   cd $dir
   echo "DIR $dir"
   git difftool --staged
   cd ..
done

