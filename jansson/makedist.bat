
call :buildAndCopy x64 Debug
call :buildAndCopy x64 Release
goto :eof

:buildAndCopy
setlocal
set platform=%~1
set configuration=%~2

msbuild jansson\jansson.vcxproj /t:rebuild /p:Platform=%platform% /p:Configuration=%configuration%

rem if not exist %platform%\%configuration%\include mkdir %platform%\%configuration%\include
rem xcopy json-c-master-2016-04-21\*.h %platform%\%configuration%\include /D /I /Y

if not exist %platform%\%configuration%\lib mkdir %platform%\%configuration%\lib

if %configuration% == Debug (
   copy jansson\lib\%configuration%\jansson_d.lib %platform%\%configuration%\lib\jansson.lib
) else (
   copy jansson\lib\%configuration%\jansson.lib %platform%\%configuration%\lib\jansson.lib
)
endlocal
goto :eof
