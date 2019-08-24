#!/bin/bash
#Spring boot文件目录
PATH_ROOT=/home/zbphc/jar/
JAVA_OPTIONS_INI=-Xms512M
JAVA_0PTIONS_MAX=-Xmx512M
JAVA_OPTS="-server ${JAVA_OPTIONS_INI} ${JAVA_0PTIONS_MAX} -Xss256k"
#需要增加native环境得模块
FLAG_NATIVE=(config)
#模块名-简写文件名
NAME_MODULE=${2##*-}
#日志文件目录
NAME_LOGS=log/${NAME_MODULE}.log
P2=$2
P3=$3
P4=$4
#检查必要以及初始化参数
init(){
if [ -z "$P2" ]; then
  usage
  exit 1
fi

if [ "$P3" = "no" ]; then
  KEYWORD=${PATH_ROOT}$P2.jar
elif [ -z "$P3" ]; then
  KEYWORD=${PATH_ROOT}$P2-0.0.1.jar
else
  KEYWORD=${PATH_ROOT}$P2-$P3.jar
fi

echo -e "\e[34m初始化参数，文件地址:${KEYWORD}\e[0m"

if [ -z "$P4" ]; then
  FLAG=prod
else
  FLAG=$P4
fi

echo -e "\e[34m初始化参数，模块:${NAME_MODULE},当前环境${FLAG}\e[0m"

for i in ${FLAG_NATIVE[@]}
do
  if [ "$i" = "$NAME_MODULE" ];then
     FLAG=${FLAG},native
     echo -e "\e[35m初始化参数，模块:${NAME_MODULE},增加参数native\e[0m"
     break
  fi
done

echo -e "\e[34m初始化参数，环境配置:$JAVA_OPTS\e[0m"
}


#检查程序是否在运行
isRunning() {
  PID=$(ps aux | grep ${PATH_ROOT}$P2 | grep -v grep | awk '{print $2}') 
  if [ -z "${PID}" ]; then
   return 1
  else
   return 0
  fi
}


#使用说明，用来提示输入参数
usage() {
    echo -e "\e[31mUsage: sh 执行脚本.sh [start|stop|restart|status] [module] [version] [native|prod|test|dev]\e[0m"
    echo -e " ---- Module  必要参数 指定执行的模块，即Jar文件名，无需后缀."
    echo -e " ---- Version 非必要参数 默认版本: 0.0.1"
    echo -e " ---- Flag    非必要参数 默认:prod 可选:[prod|dev]"
}

#输出运行状态
status(){
  isRunning
  if [ $? -eq "0" ]; then
    echo -e "\e[42;37m${P2} is running. Pid is ${PID}\e[0m"
  else
    echo -e "\e[42;37m${P2} not running.\e[0m"
  fi
}

#启动方法
start(){
  isRunning
  if [ $? -eq "0" ]; then
    echo -e "\e[42;37m${P2} is already running. pid=${PID}.\e[0m"
  else
    echo -e "\e[42;37m${P2} is starting.\e[0m"
    nohup java $JAVA_OPTS -jar $KEYWORD --spring.profiles.active=$FLAG > ${NAME_LOGS} 2>&1 &
    sleep 3s
    tail -f ${NAME_LOGS}
  fi
}
 
#停止方法
stop(){
 isRunning
 if [ $? -eq "0" ]; then
  kill -9 $PID
  echo -e "\e[42;37m${P2} is stop. pid=${PID}.\e[0m"
 else
  echo -e "\e[42;37m${P2} is not running.\e[0m"
 fi
}

#重启
restart(){
  stop
  sleep 1s
  start
}
#初始化数据
init
#根据参数调方法
case "$1" in
 "status")
   status
   ;;
 "start")
   start
   ;;
 "stop")
   stop
   ;;
 "restart")
   restart
   ;;
 *)
   usage
   ;;
esac
exit 0 
