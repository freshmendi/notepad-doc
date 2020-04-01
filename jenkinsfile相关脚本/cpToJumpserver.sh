#!/bin/bash
###部署脚本
##指定跳板机Jumpserver.sh所在的主机
host01=122.144.208.14
##定义pass文件所在路径
passfile=/data/publish/vms/versionservice/hostpass/jumpserver/host01
SYSDATE=$(date +%F)
echo "当前系统日期： $SYSDATE "
branch_name="${WORKSPACE##*_}"
echo  "当前分支名称： $branch_name"
Version=`git rev-parse --short HEAD`
echo "当前代码库版本：$Version"
##定义程序以及启动和关闭脚本所在路径
path_process=/data/appversion/versionservice
echo "运行程序所在目录：$path_process"
###从jenkins服务器上的master主干的versionservice_path.txt获取到最近一次发布的包的路径
num=`grep    "$branch_name"   /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt   | wc  -l`
path=`grep "$branch_name"  /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt  | sed -n "$num"p`
echo  $num
echo  "升级包所在路径：$path"
#####把相应的程序包拷贝到跳板机上所在的路径，原则上路径通jenkins服务器上的路径###
sshpass -f  "$passfile"    ssh -p 22200 root@"$host01"  "mkdir  -p  '$path' "
sshpass -f "$passfile"  scp -r  -P  22200     $path/versionservice-1.0.0-SNAPSHOT.jar  root@"$host01":$path
echo -e  "build程序包路径:$path\nbuild包程序名称:versionservice-1.0.0-SNAPSHOT.jar" | mail -s "$host01-versionservice已经拷贝到jumperservr"  public@goldrock.cn,1142040298@qq.com
echo -e  "build程序包路径:$path\nbuild包程序名称:versionservice-1.0.0-SNAPSHOT.jar" | mail -s "$host01-versionservice已经拷贝到jumperservr"  public@goldrock.cn,1142040298@qq.com
