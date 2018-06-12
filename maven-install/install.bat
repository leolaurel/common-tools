@echo off
setlocal enabledelayedexpansion
set Cdir=Jar
goto :list
pause 
exit 

:list
set num=0
echo 下面为JAR目录下所有文件：
for /f "delims=" %%i in ('dir /b "%Cdir%\*.jar"') do (
set /a num+=1
echo [!num!]--%%i) 
goto :select

:select
set input=
set /p input=请选择需要导入MAVEN仓库Jar包的序号:
if not defined input echo 抱歉，您没有输入序号 & goto :select
if %input% LEQ 0 echo 抱歉，您输入序号小于可选序号 & goto :select
if %input% GTR %num% echo 抱歉，您输入序号大于可选序号 & goto :select

set /a flag=input+0
if  %flag% EQU %input% goto :file  
else echo 您输入的：%input%，不是数字，请重新输入 & goto :select 


:file
set cnt=0
set Dfile=
for /f "delims=" %%i in ('dir /b/s "%Cdir%\*.jar"') do (
	set /a cnt+=1
	if "%input%"=="!cnt!" set Dfile=%%i) 
echo 您选着的Jar包地址是：!Dfile!
goto :groupId


:groupId
set DgroupId=
set /p DgroupId=请输入GroupId：
if not defined DgroupId set DgroupId=com.lveqia
echo 默认设置GroupId[%DgroupId%]
goto :artifactId


:artifactId
set DartifactId=
set /p DartifactId=请输入ArtifactId：
if not defined DartifactId goto :initArtifactId
goto :version


:initArtifactId
for /l %%i in (0,1,100) do (
if "!Dfile:~%%i,1!"=="\" set /a Cidx1=%%i+1
if defined Cidx1 if "!Dfile:~%%i,1!"=="-" set /a Cidx2=%%i-!Cidx1!)
if not defined Cidx2 echo 抱歉，此文件命名规则不支持自己生成ArtifactId & goto :select
set DartifactId=!Dfile:~%Cidx1%,%Cidx2%!
echo 默认设置ArtifactId:[%DartifactId%]


:version
set Dversion=
set /p Dversion=请输入Version：
if not defined Dversion goto :initVersion
goto :choice



:initVersion
for /l %%i in (0,1,100) do (
if "!Dfile:~%%i,1!"=="-" set /a Cidx3=%%i+1
if defined Cidx3 if "!Dfile:~%%i,1!"=="." set /a Cidx4=%%i-!Cidx3!)
if not defined Cidx4 echo 抱歉，此文件命名规则不支持自己生成Version & goto :version
set Dversion=!Dfile:~%Cidx3%,%Cidx4%!
echo 默认设置Dversion:[%Dversion%]


:choice
set choice=
echo 您当前的选择是:(DgroupId=%DgroupId%,DartifactId=%DartifactId%,Dversion=%Dversion%)
set /p choice=是否确认你的选择 (y.继续 n.重选 q.退出 v.查看):
if "%choice%"=="y" goto :mvn
if "%choice%"=="n" echo 已忽略当前选择,您可以重新选择 & goto :select
if "%choice%"=="v" goto :show
if "%choice%"=="q" exit
if "%choice%"=="Y" goto :mvn
if "%choice%"=="N" echo 已忽略当前选择,您可以重新选择 & goto :select
if "%choice%"=="V" goto :show
if "%choice%"=="Q" exit
echo 您的输入有误，请输入（y/n/q/v）& goto :choice

:show
echo 完整的指令为:mvn install:install-file -Dfile=%Dfile% -DgroupId=%DgroupId% -DartifactId=%DartifactId% -Dversion=%Dversion% -Dpackaging=jar
goto :choice

:mvn
call mvn install:install-file -Dfile=%Dfile% -DgroupId=%DgroupId% -DartifactId=%DartifactId% -Dversion=%Dversion% -Dpackaging=jar
set retry=
set /p retry=您是否继续导入Jar文件 (y.继续 任意键.退出):
if "%retry%"=="y" cls & goto :list
if "%retry%"=="Y" cls & goto :list
exit
