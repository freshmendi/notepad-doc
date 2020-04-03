#!/bin/sh
#Author:jiaminxu
#Email:jiaminxu@hengtiansoft.com
#Description:安装nginx1.13.8
#Notes:由install.sh调用执行
 
#yum安装依赖----------------------------------------------------------------------
yum-yinstallgccgcc-c++autoconfautomakemake
yum-yinstallzlibzlib-developensslopenssl-develpcrepcre-devel
 
 
#创建nginx日志文件夹----------------------------------------------------------------------
mkdir/var/nginx
mkdir/var/log/nginx/
#解压nginx----------------------------------------------------------------------
cd/tmp
tarxzvfnginx-1.13.8.tar.gz
rm-rfnginx-1.13.8.tar.gz
cdnginx-1.13.8
 
#编译nginx并配置需要安装的模块，编译后可通过nginx-V查看----------------------------------------------------------------------
./configure--with-http_ssl_module--with-http_stub_status_module--with-http_flv_module--with-http_gzip_static_module--prefix=/usr/local/nginx
#google内存优化一般用不到
#--with-google_perftools_module
#支持流媒体播放
#--with-http_flv_module
#在线查看nginx客户端连接数
#--with-http_stub_status__module
#在nginx.conf的server块中添加如下代码
#通过curl127.0.0.1/nginx_status访问
#location/nginx_status{
#   stub_statuson;
#   access_log  off;
#}
#文件压缩模块
#--with-http_gzip_static_module
make&&makeinstall
#修改/usr/local/nginx/conf/nginx.conf----------------------------------------------------------------------
cat>/usr/local/nginx/conf/nginx.conf<<EOF
#main(全局设置)----------------------------------------------------------------------
userroot;
pid/var/run/nginx.pid;
worker_processes1;
worker_rlimit_nofile100000;
 
#events(nginx工作模式)
events{
   worker_connections2048;
   multi_accepton;
   useepoll;
}
 
 
#http(http设置)----------------------------------------------------------------------
http{
   server_tokenson;
#如果出现206错误修改sendfile为off
   sendfileon;
#以下2条纺织网络堵塞
   tcp_nopushon;
   tcp_nodelayon;
   log_format main '\$remote_addr-\$remote_user[\$time_local]"\$request"'
                     '\$status\$body_bytes_sent"\$http_referer"'
                     '"\$http_user_agent""\$http_x_forwarded_for""\$upstream_addr""\$upstream_response_time"';
 
#access_log&error_log
   access_log /var/log/nginx/access.log main;
   error_log/var/log/nginx/error.logcrit;
 
#上传文件大小100M
   client_max_body_size100m;
   keepalive_timeout60;
   client_header_timeout15;
#502getaway时间
   client_body_timeout60;
   reset_timedout_connectionon;
   send_timeout25;
 
   limit_conn_zone\$binary_remote_addrzone=addr:5m;
   limit_connaddr100;
 
   include/usr/local/nginx/conf/mime.types;
   default_typetext/html;
   charsetUTF-8;
 
   gzipon;
   gzip_disable"msie6";
   gzip_proxiedany;
   gzip_min_length1000;
   gzip_comp_level6;
#压缩传输但是会造成css等乱码
#gzip_typestext/plaintext/cssapplication/jsonapplication/x-javascripttext/xmlapplication/xmlapplication/xml+rsstext/javascript;
 
   open_file_cachemax=100000inactive=20s;
   open_file_cache_valid30s;
   open_file_cache_min_uses2;
 
 
 
#server(主机设置)----------------------------------------------------------------------
server{
   listen      80;
   server_name ip;
 
#location(url配置)----------------------------------------------------------------------
location/nginx_status{
   stub_statuson;
}
}
}
EOF
 

#启动nginx并把nginx加入开机启动
/usr/local/nginx/sbin/nginx -c/usr/local/nginx/conf/nginx.conf
sed-i'5a/usr/local/nginx/sbin/nginx -c/usr/local/nginx/conf/nginx.conf'/etc/rc.d/rc.local
chmod+x/etc/rc.d/rc.local
 
#将nginx添加到服务中----------------------------------------------------------------------
cat>>/etc/init.d/nginx<<EOF
#!/bin/bash
#chkconfig:-8515
PATH=/usr/local/nginx
DESC="nginx"
NAME=nginx
DAEMON=\$PATH/sbin/\$NAME
CONFIGFILE=\$PATH/conf/\$NAME.conf
PIDFILE=\$PATH/logs/\$NAME.pid
SCRIPTNAME=/etc/init.d/\$NAME
set-e
[-x"\$DAEMON"]||exit0
do_start(){
\$DAEMON-c\$CONFIGFILE||echo-n"nginxalreadyrunning"
}
do_stop(){
\$DAEMON-sstop||echo-n"nginxnotrunning"
}
do_reload(){
\$DAEMON-sreload||echo-n"nginxcan'treload"
}
case"\$1"in
start)
echo-n"Starting\$DESC:\$NAME"
do_start
echo"."
;;
stop)
echo-n"Stopping\$DESC:\$NAME"
do_stop
echo"."
;;
reload|graceful)
echo-n"Reloading\$DESCconfiguration..."
do_reload
echo"."
;;
restart)
echo-n"Restarting\$DESC:\$NAME"
do_stop
do_start
echo"."
;;
*)
echo"Usage:\$SCRIPTNAME{start|stop|reload|restart}">&2
exit3
;;
esac
exit0
EOF

chmoda+x/etc/init.d/nginx
chkconfig--addnginx 
chkconfignginxon
