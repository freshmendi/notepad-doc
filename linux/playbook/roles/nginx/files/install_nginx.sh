#!/bin/sh
# Author:jiaminxu
# Email:jiaminxu@hengtiansoft.com
# Description: 安装nginx 1.13.8
# Notes:由install.sh 调用执行
 
#yum 安装依赖----------------------------------------------------------------------
yum -y install gcc gcc-c++ autoconf automake make
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel
 
 
#创建nginx 日志文件夹----------------------------------------------------------------------
mkdir /var/nginx
mkdir /var/log/nginx/
#解压nginx----------------------------------------------------------------------
cd /tmp
tar xzvf nginx-1.13.8.tar.gz
rm -rf nginx-1.13.8.tar.gz
cd nginx-1.13.8
 
#编译nginx 并配置需要安装的模块，编译后可通过nginx -V查看----------------------------------------------------------------------
./configure --with-http_ssl_module --with-http_stub_status_module --with-http_flv_module --with-http_gzip_static_module --prefix=/usr/local/nginx
#google 内存优化 一般用不到
#--with-google_perftools_module
#支持流媒体播放
#--with-http_flv_module
#在线查看nginx 客户端连接数
#--with-http_stub_status__module
#在nginx.conf的server块中添加如下代码
#通过 curl 127.0.0.1/nginx_status访问
#location /nginx_status {
#    stub_status on;
#    access_log   off;
#}
#文件压缩模块
#--with-http_gzip_static_module
make && make install
#修改 /usr/local/nginx/conf/nginx.conf----------------------------------------------------------------------
cat > /usr/local/nginx/conf/nginx.conf <<EOF
#main(全局设置)----------------------------------------------------------------------
user root;
pid /var/run/nginx.pid;
worker_processes 1;
worker_rlimit_nofile 100000;
 
#events(nginx工作模式)
events {
   worker_connections 2048;
   multi_accept on;
   use epoll;
}


 
 
#http(http设置)----------------------------------------------------------------------
http {
   server_tokens on;
#如果出现206错误 修改sendfile 为off
   sendfile on;
#以下2条纺织网络堵塞
   tcp_nopush on;
   tcp_nodelay on;
   log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for" "\$upstream_addr" "\$upstream_response_time"';
 
#access_log & error_log
   access_log  /var/log/nginx/access.log  main;
   error_log /var/log/nginx/error.log crit;
 
#上传文件大小100M
   client_max_body_size 100m;
   keepalive_timeout 60;
   client_header_timeout 15;
#502 get away时间
   client_body_timeout 60;
   reset_timedout_connection on;
   send_timeout 25;
 
   limit_conn_zone \$binary_remote_addr zone=addr:5m;
   limit_conn addr 100;
 
   include /usr/local/nginx/conf/mime.types;
   default_type text/html;
   charset UTF-8;
 
   gzip on;
   gzip_disable "msie6";
   gzip_proxied any;
   gzip_min_length 1000;
   gzip_comp_level 6;
#压缩传输 但是会造成css等乱码
#gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
 
   open_file_cache max=100000 inactive=20s;
   open_file_cache_valid 30s;
   open_file_cache_min_uses 2;
 
 
 
#server(主机设置)----------------------------------------------------------------------
server {
   listen       80;
   server_name  ip;
 
#location(url配置)----------------------------------------------------------------------
location /nginx_status {
   stub_status on;
}
}
}
EOF
 

#启动nginx 并把nginx 加入开机启动
/usr/local/nginx/sbin/nginx  -c /usr/local/nginx/conf/nginx.conf
sed -i '5a /usr/local/nginx/sbin/nginx  -c /usr/local/nginx/conf/nginx.conf' /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
 
#将nginx添加到服务中----------------------------------------------------------------------
cat >>/etc/init.d/nginx<<EOF
#! /bin/bash
# chkconfig: - 85 15
PATH=/usr/local/nginx
DESC="nginx "
NAME=nginx
DAEMON=\$PATH/sbin/\$NAME
CONFIGFILE=\$PATH/conf/\$NAME.conf
PIDFILE=\$PATH/logs/\$NAME.pid
SCRIPTNAME=/etc/init.d/\$NAME
set -e
[ -x "\$DAEMON" ] || exit 0
do_start() {
\$DAEMON -c \$CONFIGFILE || echo -n "nginx already running"
}
do_stop() {
\$DAEMON -s stop || echo -n "nginx not running"
}
do_reload() {
\$DAEMON -s reload || echo -n "nginx can't reload"
}
case "\$1" in
start)
echo -n "Starting \$DESC: \$NAME"
do_start
echo "."
;;
stop)
echo -n "Stopping \$DESC: \$NAME"
do_stop
echo "."
;;
reload|graceful)
echo -n "Reloading \$DESC configuration..."
do_reload
echo "."
;;
restart)
echo -n "Restarting \$DESC: \$NAME"
do_stop
do_start
echo "."
;;
*)
echo "Usage: \$SCRIPTNAME {start|stop|reload|restart}" >&2
exit 3
;;
esac
exit 0
EOF

chmod a+x /etc/init.d/nginx
chkconfig --add nginx 
chkconfig nginx on
