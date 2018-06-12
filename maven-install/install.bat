@echo off
setlocal enabledelayedexpansion
set Cdir=Jar
goto :list
pause 
exit 

:list
set num=0
echo ����ΪJARĿ¼�������ļ���
for /f "delims=" %%i in ('dir /b "%Cdir%\*.jar"') do (
set /a num+=1
echo [!num!]--%%i) 
goto :select

:select
set input=
set /p input=��ѡ����Ҫ����MAVEN�ֿ�Jar�������:
if not defined input echo ��Ǹ����û��������� & goto :select
if %input% LEQ 0 echo ��Ǹ�����������С�ڿ�ѡ��� & goto :select
if %input% GTR %num% echo ��Ǹ����������Ŵ��ڿ�ѡ��� & goto :select

set /a flag=input+0
if  %flag% EQU %input% goto :file  
else echo ������ģ�%input%���������֣����������� & goto :select 


:file
set cnt=0
set Dfile=
for /f "delims=" %%i in ('dir /b/s "%Cdir%\*.jar"') do (
	set /a cnt+=1
	if "%input%"=="!cnt!" set Dfile=%%i) 
echo ��ѡ�ŵ�Jar����ַ�ǣ�!Dfile!
goto :groupId


:groupId
set DgroupId=
set /p DgroupId=������GroupId��
if not defined DgroupId set DgroupId=com.lveqia
echo Ĭ������GroupId[%DgroupId%]
goto :artifactId


:artifactId
set DartifactId=
set /p DartifactId=������ArtifactId��
if not defined DartifactId goto :initArtifactId
goto :version


:initArtifactId
for /l %%i in (0,1,100) do (
if "!Dfile:~%%i,1!"=="\" set /a Cidx1=%%i+1
if defined Cidx1 if "!Dfile:~%%i,1!"=="-" set /a Cidx2=%%i-!Cidx1!)
if not defined Cidx2 echo ��Ǹ�����ļ���������֧���Լ�����ArtifactId & goto :select
set DartifactId=!Dfile:~%Cidx1%,%Cidx2%!
echo Ĭ������ArtifactId:[%DartifactId%]


:version
set Dversion=
set /p Dversion=������Version��
if not defined Dversion goto :initVersion
goto :choice



:initVersion
for /l %%i in (0,1,100) do (
if "!Dfile:~%%i,1!"=="-" set /a Cidx3=%%i+1
if defined Cidx3 if "!Dfile:~%%i,1!"=="." set /a Cidx4=%%i-!Cidx3!)
if not defined Cidx4 echo ��Ǹ�����ļ���������֧���Լ�����Version & goto :version
set Dversion=!Dfile:~%Cidx3%,%Cidx4%!
echo Ĭ������Dversion:[%Dversion%]


:choice
set choice=
echo ����ǰ��ѡ����:(DgroupId=%DgroupId%,DartifactId=%DartifactId%,Dversion=%Dversion%)
set /p choice=�Ƿ�ȷ�����ѡ�� (y.���� n.��ѡ q.�˳� v.�鿴):
if "%choice%"=="y" goto :mvn
if "%choice%"=="n" echo �Ѻ��Ե�ǰѡ��,����������ѡ�� & goto :select
if "%choice%"=="v" goto :show
if "%choice%"=="q" exit
if "%choice%"=="Y" goto :mvn
if "%choice%"=="N" echo �Ѻ��Ե�ǰѡ��,����������ѡ�� & goto :select
if "%choice%"=="V" goto :show
if "%choice%"=="Q" exit
echo �����������������루y/n/q/v��& goto :choice

:show
echo ������ָ��Ϊ:mvn install:install-file -Dfile=%Dfile% -DgroupId=%DgroupId% -DartifactId=%DartifactId% -Dversion=%Dversion% -Dpackaging=jar
goto :choice

:mvn
call mvn install:install-file -Dfile=%Dfile% -DgroupId=%DgroupId% -DartifactId=%DartifactId% -Dversion=%Dversion% -Dpackaging=jar
set retry=
set /p retry=���Ƿ��������Jar�ļ� (y.���� �����.�˳�):
if "%retry%"=="y" cls & goto :list
if "%retry%"=="Y" cls & goto :list
exit
