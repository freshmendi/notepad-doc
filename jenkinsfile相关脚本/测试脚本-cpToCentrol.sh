#!/bin/bash
##/data/publish/vms/versionservice/scripts/cpToCentrol.sh
Version=`git rev-parse --short HEAD`
branch_name=`git symbolic-ref --short -q HEAD`
echo  $branch_name
####打好的包临时存放的workspace路径，用于备份打好的包
path="${WORKSPACE}/dist/$branch_name/${BUILD_NUMBER}/$Version"
##打好的包统一存放的路径，用于统一备份打好的包，以及方便回滚
path_pub="/data/publish/vms/versionservice/$branch_name/${BUILD_NUMBER}/$Version"
###打包文件的路径，记录到一个versionservice_path.txt文件
result_path="/data/publish/vms/versionservice/result/$branch_name/"

   mkdir -p $path
   mkdir -p $path_pub
   mkdir -p $result_path
   echo $Version
   echo  $path
   echo $path_pub
   echo  $result_path
   touch    $result_path/versionservice_path.txt
   cp -r  "${WORKSPACE}/target/versionservice-1.0.0-SNAPSHOT.jar"   $path
   cp -r   "${WORKSPACE}/target/versionservice-1.0.0-SNAPSHOT.jar"   $path_pub
   echo $path_pub >> $result_path/versionservice_path.txt