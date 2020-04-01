
#!/bin/bash
##/data/publish/vms/versionservice/scripts/cpToCentrol.sh
Version=`git rev-parse --short HEAD`
branchall=`[git branch  -a]` 

path="${WORKSPACE}/dist/${BUILD_NUMBER}/$Version"
path_pub="/data/publish/vms/versionservice/${BUILD_NUMBER}/$Version"
if [ -d $path ]
then
    echo "the file is already exists"
else
   mkdir -p $path
   mkdir -p $path_pub
   echo $Version
   echo  $path
   echo $path_pub
   cp -r  "${WORKSPACE}/target/versionservice-1.0.0-SNAPSHOT.jar"   $path
   cp -r   "${WORKSPACE}/target/versionservice-1.0.0-SNAPSHOT.jar"   $path_pub
   echo $path_pub >> /data/publish/vms/versionservice/result/versionservice_path.txt
fi
    ;;

	git rev-parse --short HEAD`
branch=`git rev-parse --short HEAD`
	
	


Rollback)
	echo "status:$status"
	echo "Version:$Version"
	for((i=1;i<=100;i++)) {

	num_before=$[${BUILD_NUMBER}-i]
	echo  $num_before
	path_back="${WORKSPACE}/dist/$Version/${num_before}"
	if [ ! -d $path_back ]
	then 
	continue
else 
    cp -rf  $path_back/versionservice-1.0.0-SNAPSHOT.jar  ${WORKSPACE}/target/
     break 	
	fi }
    ;;
    *)
    exit
esac



