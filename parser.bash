CMakeLists (){
  sed -i "s/<<<File_Name>>>/$1/g" $2
}

Plugin (){
  echo "Plugin Name:" $1
  sed -i "s/<<<Plugin_Type>>>/$1/g" $2
  sed -i "s/<<<Class_Name>>>/$3/g" $2
  sed -i "s/<<<Plugin_Type_Caps>>>/${1^^}/g" $2 # this works only for bash version > 3
  if [ "$1" = "World" ];
  then
    replace_header=physics
  elif [ "$1" = "Model" ];
  then
    replace_header=physics
  elif [ "$1" = "Visual" ];
  then
    replace_header=rendering
  else
    echo NONE
  fi

    sed -i "s/<<<Plugin_Type_Header>>>/${replace_header}/g" $2
    sed -i "s/<<<Plugin_Type_Ptr>>>/"${replace_header}::$1"/g" $2

}

Output (){
    tput setaf 5; echo -n $1 ; tput setaf 2; read $2; tput setaf 7;
}
