#!/bin/bash

SpringBoot=$2
config=$3

if [ "$1" = "" ];
then
    echo -e "\033[0;31m 请输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi

if [ "$SpringBoot" = "" ];
then
    echo -e "\033[0;31m 请输入应用名 \033[0m"
    exit 1
fi

if [ "$config" = "" ];
then
    echo -e "\033[0;31m 请输入默认名 \033[0m  \033[0;34m {dev|test|gray|prod} \033[0m"
	exit 1
fi

function start()
{
	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
	if [ $count != 0 ];then
		echo "$SpringBoot is running..."
	else
		echo "Start $SpringBoot success..."
		nohup java -jar -Xmx1g -Xms1g -XX:PermSize=128M -XX:MaxPermSize=256M $SpringBoot --spring.profiles.active=$config > start.log 2>&1 &
	fi
}

function stop()
{
	echo "Stop $SpringBoot"
	boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`

	if [ $count != 0 ];then
	    kill $boot_id
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`

		boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
		kill -9 $boot_id
	fi
}

function restart()
{
	stop
	sleep 2
	start
}

function status()
{
    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$SpringBoot is running..."
    else
        echo "$SpringBoot is not running..."
    fi
}

case $1 in
	start)
	start;;
	stop)
	stop;;
	restart)
	restart;;
	status)
	status;;
	*)

	echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} [{dev|test|gray|pro}]\033[0m
\033[0;31m Example: \033[0m
	  \033[0;33m sh  $0  start esmart-test.jar [{dev|test|gray|pro}]\033[0m"
esac
