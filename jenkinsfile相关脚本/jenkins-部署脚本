#!/bin/bash
###部署脚本
##指定versionservice所在的主机
host01=192.168.25.81
##定义pass文件所在路径
passfile=/data/publish/vms/versionservice/hostpass/host01
SYSDATE=$(date +%F)
echo $SYSDATE
branch_name="${WORKSPACE##*_}"
echo  $branch_name
Version=`git rev-parse --short HEAD`
##定义程序以及启动和关闭脚本所在路径
path_process=/data/appversion/versionservice
echo $path_process
###从jenkins服务器上的master主干的versionservice_path.txt获取到最近一次发布的包的路径
num=`grep    "$branch_name"   /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt   | wc  -l`
path=`grep "$branch_name"  /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt  | sed -n "$num"p`
echo  $num
echo  $path
###在程序升级之前，获取程序启动成功的关键字
success_status_01=`sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process  && sh success.sh "`
echo  $success_status_01
sshpass -f "$passfile" scp -r      $path/versionservice-1.0.0-SNAPSHOT.jar  root@$host01:$path_process

sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process  && nohup sh stop.sh  "

sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process && nohup sh start.sh  "

####程序重启40s后，获取程序启动成功的关键字出现的条目，40s可以调节
sleep  40s
success_status_02=`sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process  && sh success.sh "`
echo  $success_status_02
if  [ $success_status_02   != $success_status_01 ]
then
echo  '程序启动成功了'
else