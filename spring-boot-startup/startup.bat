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
echo ����Ϊ��ѡ���Module��
for /l %%i in (1,1,9) do (
echo %%i:!Dmod%%i!)
goto :select

:select
set input=
set /p input=��ѡ����Ҫ���е�ģ�����:
if not defined input echo ��Ǹ����û��������� & goto :select
if %input% LEQ 0 echo ��Ǹ�����������С�ڿ�ѡ��� & goto :select
if %input% GTR 9 echo ��Ǹ����������Ŵ��ڿ�ѡ��� & goto :select

set /a flag=input+0
if  %flag% EQU %input% goto :version
else echo ������ģ�%input%���������֣����������� & goto :select 

:version
set version=
set /p version=��ѡ����Ҫ���е�ģ��汾��:
if not defined input echo ��Ǹ��ģ��汾�� & goto :version
goto :assign


:assign
set Dstr1=java %JAVA_OPS% -jar %PATH_JAR%\!Dmod%input%!\build\libs\
set Dstr2=!Dmod%input%!-%version%.jar --spring.profiles.active=dev,native
set Dcmd=%Dstr1%%Dstr2%

:choice
set choice=
echo ����ǰ��ѡ����:!Dmod%input%!
set /p choice=�Ƿ�ȷ�����ѡ�� (y.���� n.��ѡ q.�˳� v.�鿴):
if "%choice%"=="y" goto :call
if "%choice%"=="n" echo �Ѻ��Ե�ǰѡ��,����������ѡ�� & goto :select
if "%choice%"=="v" goto :show
if "%choice%"=="q" exit
if "%choice%"=="Y" goto :call
if "%choice%"=="N" echo �Ѻ��Ե�ǰѡ��,����������ѡ�� & goto :select
if "%choice%"=="V" goto :show
if "%choice%"=="Q" exit
echo �����������������루y/n/q/v��& goto :choice

:show
echo ������ָ��Ϊ:%Dcmd%
goto :choice

:call
call %Dcmd%
