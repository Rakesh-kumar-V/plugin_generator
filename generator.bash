#!/bin/bash

source $(pwd)/parser.bash

Reference_files_dir=/home/$(whoami)/plugin_generator/reference_files
echo $Reference_files_dir

if [ "$1" = "--file" ];
then
  input_filename=$2
  input_array=()
  # mapfile -d "\n" input_array < ${2/#./$(pwd)}
  while IFS= read -r line; do input_array+=("$line"); done < ${2/#./$(pwd)}
fi

for info in ${input_array[@]}
do
  echo $info
done

if [ "$1" != "--file" ];
then
  Output "Enter Package name: " Package_name
  Output "Enter your Package directory: (Must be inside a ROS workspace)" Package_directory
else
  Package_name=${input_array[0]}
  echo $Package_name
  Package_directory=${input_array[1]}
fi

cd ${Package_directory/#~/$HOME}

catkin_create_pkg $Package_name roscpp

pwd

if [ "$1" != "--file" ];
then
  Output "Enter Your File name: " File_name
else
  File_name=${input_array[2]}
fi

cd $Package_name
touch src/${File_name}.cc

cat ${Reference_files_dir}/CMakeLists.parts >> ./CMakeLists.txt

Plugin_types=(Model World Visual System Sensor)
echo "Choose a plugin from the list Below:"
let count=0
for info in ${Plugin_types[@]}
do
  count=$(($count + 1))
  echo $count")" $info
done

if [ "$1" != "--file" ];
then
  Output "Enter Your Selection: " Plugin_selected
else
  Plugin_selected=${input_array[3]}
fi

echo "Generating files for "$Plugin_selected

cat ${Reference_files_dir}/generic.parts >> ./src/${File_name}.cc
Plugin $Plugin_selected ./src/${File_name}.cc ${File_name}
CMakeLists $File_name ./CMakeLists.txt

if [ "$1" != "--file" ];
then
  Output "Enter No.of Publisher: " pub
  Output "Enter No.of Subscriber: " sub
else
  pub=${input_array[4]}
  sub=${input_array[5]}
fi
