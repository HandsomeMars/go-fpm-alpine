### 卸载软件后执行脚本

if [ "`ps aux|grep supervisord|grep -v grep`" != "" ]; then
     echo "卸载服务, 准备Stop服务"
     supervisorctl stop xxx
     supervisorctl update
     echo "中止服务完成~"
fi

cd /usr/local
rm -rf xxx
echo "删除服务目录完成~"
