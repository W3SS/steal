@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

if not "%BASE%" == "" ( set BASE=%BASE:\=/% )

:: trim spaces
for /f "tokens=1*" %%A in ("%BASE%") do SET BASE=%%A

:: handle args
SET ARGS=[
for /f "tokens=1,2,3,4,5,6 delims= " %%a in ("%*") do SET ARGS=!ARGS!'%%a','%%b','%%c','%%d','%%e','%%f'
for %%a in (",''=") do ( call set ARGS=%%ARGS:%%~a%% )
for /f "tokens=1*" %%A in ("%ARGS%") do SET ARGS=%%A
SET ARGS=%ARGS%,'%BASE%']
set ARGS=%ARGS:\=/%

:: figure out startup path
if "%LOADPATH%" == "" ( set LOADPATH=%BASE%%1 )

:: if no LOADPATH (TODO this won't work as is because loadpath is never empty)
if "%LOADPATH%"=="" (
	java -cp js.jar org.mozilla.javascript.tools.shell.Main
	GOTO END
)

:: need to use forward slashes for paths
set LOADPATH=%LOADPATH:\=/%

:: invoke Rhino
java -Xmx170m -Xss1024k -cp %CP% org.mozilla.javascript.tools.shell.Main -opt -1 -e _args=%ARGS% -e load('%LOADPATH%')

:END