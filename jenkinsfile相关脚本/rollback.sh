#!/bin/bash
###回滚脚本
##指定回滚脚本的上一个成功打包的版本号
branch_name="${WORKSPACE##*_}"
echo  $branch_name
Version=`git rev-parse --short HEAD`

##指定versionservice所在的主机
host01=192.168.25.81
host=($host01)
##定义pass文件所在路径
passfile=/data/publish/vms/versionservice/hostpass/dev/host01
SYSDATE=$(date +%F)
echo "当前日期：$SYSDATE"
##定义程序以及启动和关闭脚本所在路径
path_process=/data/appversion/versionservice
echo "运行程序所在目录： $path_process"
###从jenkins服务器上的versionservice_path.txt获取到最近一次发布的包的路径

num=`grep    "$branch_name"   /data/publish/vms/versionservice/result/$branch_name/versionservice_path.txt   | wc  -l`
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
    version_same=`grep  "$Version"  /data/publish/vms/versionservice/result/$branch_name/path.txt| wc -l`
    echo  "版本是否相同：$version_same"
    if  [ "$version_same" == 1 ]
    then
   continue
else
    ##把路径记录到path.txt文件中，方便追溯
   echo  $path >  /data/publish/vms/versionservice/result/$branch_name/path.txt
   echo "需要回滚的build程序所在路径： $path"

     break
        fi
        fi }
########升级程序到相应的主机上，并根据升级的结果发送邮件######
###在程序升级之前，获取程序启动成功的关键字
for(( k=0;k<${#host[@]};k++)) do
echo  ${host[*]}
success_status_01=`sshpass -f "$passfile"  ssh   root@${host[k]} "cd $path_process  && sh success.sh "`
echo  "重启之前的程序启动成功标志个数： $success_status_01"
sshpass -f "$passfile" scp -r      $path/versionservice-1.0.0-SNAPSHOT.jar  root@$host01:$path_process
sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process  && nohup sh stop.sh  "
sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process && nohup sh start.sh  "

####程序重启40s后，获取程序启动成功的关键字出现的条目，40s可以调节
sleep  40s
success_status_02=`sshpass -f "$passfile"  ssh   root@$host01 "cd $path_process  && sh success.sh "`
echo  "重启之后的程序启动成功标志个数：$success_status_02"
if  [ $success_status_02   != $success_status_01 ]
then
echo  '程序启动成功了'
echo -e  "代码分支："$branch_name"\n当前代码版本："$Version"\nbuild程序包所在路径："$path"\n运行的程序所在路径："$path_process"" | mail -s "versionserviceh升级成功"  public@goldrock.cn,1142040298@qq.com
else
echo  '程序启动失败了'
echo -e  "代码分支："$branch_name"\n当前代码版本："$Version"\nbuild程序包所在路径："$path"\n运行的程序所在路径："$path_process"" | mail -s "versionserviceh升级失败"  public@goldrock.cn,1142040298@qq.com
fi
done