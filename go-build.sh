#!/bin/bash
##############################################################
echo "step1 为$1-$2创建打包目录"
# 创建打包目录
mkdir -p $GOPACKAGE/$1/usr/local/$1/bin
mkdir -p $GOPACKAGE/$1/usr/local/$1/etc
mkdir -p $GOPACKAGE/$1/usr/local/$1/log
mkdir -p $GOPACKAGE/$1/etc/supervisor/conf.d
mkdir -p $GOSCRIPTS/$1/scripts

# 创建公共文件
cp $GOTEMPLATE/template/supervisor_xxx.conf $GOPACKAGE/$1/etc/supervisor/conf.d/$1.conf
cp $GOPATH/src/$1/etc/* $GOPACKAGE/$1/usr/local/$1/etc/
cp $GOTEMPLATE/template/xxx.log $GOPACKAGE/$1/usr/local/$1/log/$1.log
cp $GOTEMPLATE/template/after_install.sh $GOSCRIPTS/$1/scripts/
cp $GOTEMPLATE/template/after_remove.sh $GOSCRIPTS/$1/scripts/
cp $GOTEMPLATE/template/after_upgrade.sh $GOSCRIPTS/$1/scripts/

sed -i "s/xxx/$1/g" $GOSCRIPTS/$1/scripts/after_install.sh
if [ $? -ne 0 ]; then
  echo "改写安装脚本失败"
  exit 1
fi

sed -i "s/xxx/$1/g" $GOSCRIPTS/$1/scripts/after_remove.sh
if [ $? -ne 0 ]; then
  echo "改写删除脚本失败"
  exit 1
fi

sed -i "s/xxx/$1/g" $GOSCRIPTS/$1/scripts/after_upgrade.sh
if [ $? -ne 0 ]; then
  echo "改写更新脚本失败"
  exit 1
fi

sed -i "s/xxx/$1/g" $GOPACKAGE/$1/etc/supervisor/conf.d/$1.conf
if [ $? -ne 0 ]; then
  echo "改写supervisor脚本失败"
  exit 1
fi

sed -i "s/XVer/$2/g" $GOSCRIPTS/$1/scripts/after_install.sh
if [ $? -ne 0 ]; then
  echo "改写安装脚本失败"
  exit 1
fi

sed -i "s/XVer/$2/g" $GOSCRIPTS/$1/scripts/after_upgrade.sh
if [ $? -ne 0 ]; then
  echo "改写升级脚本失败"
  exit 1
fi


##############################################################
echo "step2 为$1-$2编译程序"
cd $GOPATH/src/$1/

#编译go
go build -o $GOPACKAGE/$1/usr/local/$1/bin/$1-$2
if [ $? -ne 0 ]; then
  echo "编译程序错误!"
  exit 1
fi


##############################################################
echo "step3 为$1-$2打包程序"

fpm -s dir -t rpm -n $1 -v $2 \
-C $GOPACKAGE/$1/ \
-p $GOPATH/src/$1/ \
--iteration 1.el6 -f \
--url http://www.baishancloud.com/ \
--vendor zyj@baishancloud.com \
-m zyj@baishancloud.com \
--verbose \
--after-install $GOSCRIPTS/$1/scripts/after_install.sh \
--after-remove $GOSCRIPTS/$1/scripts/after_remove.sh  \
--after-upgrade $GOSCRIPTS/$1/scripts/after_upgrade.sh

if [ $? -ne 0 ]; then
  echo "RPM打包失败!"
  exit 1
fi

##############################################################
echo "step4 为$1-$2清理目录"
rm -rf $GOPACKAGE/$1/usr/local/$1/bin/*

if [ $? -ne 0 ]; then
  echo "清理遗留文件失败！"
  exit 1
fi

echo "清理遗留文件成功~"
