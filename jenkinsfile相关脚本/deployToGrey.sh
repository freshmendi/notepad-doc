#!/bin/bash
###部署脚本
##指定versionservice所在的主机
host01=192.168.
host=($host01)
##定义pass文件所在路径
passfile=/data/publish/vms/versionservice/hostpass/grey/host01
SYSDATE=$(date +%F)
echo "当前系统日期： $SYSDATE "
branch_name=master
##定义程序以及启动和关闭脚本所在路径
path_process=/data/appversion/versionservice
echo "运行程序所在目录：$path_process"
###从jenkins服务器上的master主干的versionservice_path.txt获取到最近一次发布的包的路径
num=`grep    "$branch_name"   /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt   | wc  -l`
path=`grep "$branch_name"  /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt  | sed -n "$num"p`
echo  $num
echo  "升级包所在路径：$path"
###在程序升级之前，获取程序启动成功的关键字
###在程序升级之前，获取程序启动成功的关键字
for(( k=0;k<${#host[@]};k++)) do

success_status_01=`sshpass -f "$passfile"  ssh   root@${host[k]} "cd $path_process  && sh success.sh "`
echo  $success_status_01
sshpass -f "$passfile" scp -r      $path/versionservice-1.0.0-SNAPSHOT.jar  root@${host[k]}:$path_process

sshpass -f "$passfile"  ssh   root@${host[k]} "cd $path_process  && nohup sh stop.sh  "

sshpass -f "$passfile"  ssh   root@${host[k]} "cd $path_process && nohup sh start.sh  "

####程序重启40s后，获取程序启动成功的关键字出现的条目，40s可以调节
sleep  40s
success_status_02=`sshpass -f "$passfile"  ssh   root@${host[k]} "cd $path_process  && sh success.sh "`
echo  $success_status_02
if  [ $success_status_02   != $success_status_01 ]
then
echo  '程序启动成功了'
echo -e  "代码分支："$branch_name"\nbuild程序包路径:$path\nbuild包程序名称:versionservice-1.0.0-SNAPSHOT.jar" | mail -s "versionservice升级到灰度-$host01成功了"  public@goldrock.cn,11
42040298@qq.com                                                              
else
echo  '程序启动失败了'
echo -e  "代码分支："$branch_name"\nbuild程序包路径:$path\nbuild包程序名称:versionservice-1.0.0-SNAPSHOT.jar" | mail -s "versionservice升级到灰度-$host01失败了"  public@goldrock.cn,11
42040298@qq.com
fi
done