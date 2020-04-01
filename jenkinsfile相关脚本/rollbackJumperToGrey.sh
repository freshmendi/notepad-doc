#!/bin/bash
###部署脚本
##指定versionservice所在的主机
##定义pass文件所在路径
host01=192.168.61.183
host=($host01)
##定义pass文件所在路径
passfile=/data/publish/vms/versionservice/hostpass/grey/host01
SYSDATE=$(date +%F)
echo "当前系统日期： $SYSDATE "
branch_name=master
echo  "当前分支名称： $branch_name"
##定义程序以及启动和关闭脚本所在路径
path_process=/data/appversion/versionservice
echo "运行程序所在目录：$path_process"
###从jenkins服务器上的master主干的versionservice_path.txt获取到最近一次发布的包的路径
num=`grep    "$branch_name"   /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt   | wc  -l`
path=`grep "$branch_name"  /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt  | sed -n "$num"p`
echo  "升级包所在路径：$path"
Version=`echo ${path##*/}`
echo  "最后一次升级的build版本号：$Version"

echo  "所有当前分支的build程序路径记录的个数:$num"
for((i=1;i<=100;i++)) {
        num_before=$[${num}-i]
        if [ ! -d $path ]
      then
        continue
else
    echo "当前分支的build的程序的上一个build版本路径记录所在的行号：$num_before"
    ###截取所在行的路内容，即是上一个build版本的路径
    path=`grep "$branch_name"  /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt  | sed -n "$num_before"p`
    ##校验buid版本号是否相同，如果相同则寻找上一个版本
	Version_before=`echo ${path##*/}`
    echo  "上一本版本的分支版本：$Version"
    ##把路径记录到path.txt文件中，方便追溯
    echo  $path >  /data/publish/vms/versionservice/result/$branch_name/path.txt
    version_same=`grep  "$Version"  /data/publish/vms/versionservice/result/$branch_name/path.txt| wc -l`
    echo  "版本是否相同：$version_same"
    if  [ "$version_same" == 1 ]
    then
   continue
else
   echo "需要回滚的build程序所在路径： $path"
     break
        fi
        fi }
	
###在程序升级之前，获取程序启动成功的关键字
###在程序升级之前，获取程序启动成功的关键字
for(( k=0;k<${#host[@]};k++)) do

success_status_01=`sshpass -f "$passfile"  ssh  -p  12525  root@${host[k]} "cd $path_process  && sh success.sh "`
echo  $success_status_01
sshpass -f "$passfile" scp -r    -P  12525   $path/versionservice-1.0.0-SNAPSHOT.jar  root@${host[k]}:$path_process

sshpass -f "$passfile"  ssh    -p  12525   root@${host[k]} "cd $path_process  && nohup sh stop.sh  "

sshpass -f "$passfile"  ssh    -p  12525  root@${host[k]} "cd $path_process && nohup sh start.sh  "

####程序重启40s后，获取程序启动成功的关键字出现的条目，40s可以调节
sleep  40s
success_status_02=`sshpass -f "$passfile"  ssh  -p 12525  root@${host[k]} "cd $path_process  && sh success.sh "`
echo  $success_status_02
if  [ $success_status_02   != $success_status_01 ]
then
echo  '程序启动成功了'
echo -e  "代码分支："$branch_name"\n当前代码版本："$Version"\nbuild程序包所在路径："$path"\n运行的程序所在路径："$path_process"" | mail -s "${host[k]}-versionserviceh升级成功"  public@goldrock.cn,1142040298@qq.com
else
echo  '程序启动失败了'
echo -e  "代码分支："$branch_name"\n当前代码版本："$Version"\n当前的程序包所在路径："$path"\n运行的程序所在路径："$path_process"" | mail -s "${host[k]}-versionserviceh升级失败"  public@goldrock.cn,1142040298@qq.com
fi
done

