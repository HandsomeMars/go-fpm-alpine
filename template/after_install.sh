# RPM包安装完成后执行脚本


ln -s /usr/local/xxx/bin/xxx-XVer /usr/local/xxx/bin/xxx -f

if [ "`ps aux|grep supervisord|grep -v grep`" != "" ]; then
      echo "安装完成, 准备启动服务"
      supervisorctl update
      supervisorctl restart xxx
      echo "启动服务完成~"	
else
      echo "安装完成, 准备启动Supervisor"
      service supervisord start
      echo "启动Supervisor服务完成~"	
fi


