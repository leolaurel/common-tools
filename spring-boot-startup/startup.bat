@echo off
setlocal enabledelayedexpansion
set PATH_JAR=D:\Workspace\Java\zkys-cloud
set JAVA_OPS=-server -Xms128M -Xmx128M -Xss256k
goto :list
pause 
exit 

:list
set Dmod1=lveqia-cloud-eureka
set Dmod2=lveqia-cloud-config
set Dmod3=lveqia-cloud-zuul
set Dmod4=module-core
set Dmod5=module-lock
set Dmod6=module-wx
set Dmod7=module-data
set Dmod8=module-fota
set Dmod9=module-admin
echo 下面为可选择的Module：
for /l %%i in (1,1,9) do (
echo %%i:!Dmod%%i!)
goto :select

:select
set input=
set /p input=请选择需要运行的模块序号:
if not defined input echo 抱歉，您没有输入序号 & goto :select
if %input% LEQ 0 echo 抱歉，您输入序号小于可选序号 & goto :select
if %input% GTR 9 echo 抱歉，您输入序号大于可选序号 & goto :select

set /a flag=input+0
if  %flag% EQU %input% goto :version
else echo 您输入的：%input%，不是数字，请重新输入 & goto :select 

:version
set version=
set /p version=请选择需要运行的模块版本号:
if not defined input echo 抱歉，模块版本号 & goto :version
goto :assign


:assign
set Dstr1=java %JAVA_OPS% -jar %PATH_JAR%\!Dmod%input%!\build\libs\
set Dstr2=!Dmod%input%!-%version%.jar --spring.profiles.active=dev,native
set Dcmd=%Dstr1%%Dstr2%

:choice
set choice=
echo 您当前的选择是:!Dmod%input%!
set /p choice=是否确认你的选择 (y.继续 n.重选 q.退出 v.查看):
if "%choice%"=="y" goto :call
if "%choice%"=="n" echo 已忽略当前选择,您可以重新选择 & goto :select
if "%choice%"=="v" goto :show
if "%choice%"=="q" exit
if "%choice%"=="Y" goto :call
if "%choice%"=="N" echo 已忽略当前选择,您可以重新选择 & goto :select
if "%choice%"=="V" goto :show
if "%choice%"=="Q" exit
echo 您的输入有误，请输入（y/n/q/v）& goto :choice

:show
echo 完整的指令为:%Dcmd%
goto :choice

:call
call %Dcmd%
