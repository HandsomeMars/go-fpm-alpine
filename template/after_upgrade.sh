### 卸载软件后执行脚本

ln -s /usr/local/xxx/bin/xxx-XVer /usr/local/xxx/bin/xxx -f

if [ "`ps aux|grep supervisord|grep -v grep`" != "" ]; then
     echo "升级服务, 准备重启服务"
     supervisorctl restart xxx
     echo "升级服务完成~"
fi

