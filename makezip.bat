set VERSION=1.1.0
set OPENSSL_VERSION=1.0.1t
set ZIP_FILE=deps-%VERSION%.zip

rmdir /q /s deps
mkdir deps
del /q %ZIP_FILE%

REM json-c
call :copy_json Win32 Debug
call :copy_json Win32 Release
call :copy_json x64 Debug
call :copy_json x64 Release

REM glib
call :copy_glib Win32 Debug
call :copy_glib Win32 Release

REM openssl
call :copy_openssl Win32 Debug
call :copy_openssl Win32 Release
call :copy_openssl x64 Debug
call :copy_openssl x64 Release

REM clamav
call :copy_libclamav Win32 Debug
call :copy_libclamav Win32 Release
call :copy_libclamav x64 Debug
call :copy_libclamav x64 Release

REM prebuilt
call :copy_prebuilt

REM zip the result
7z a -r -tzip %ZIP_FILE% deps

goto :eof

REM copy the json-c tree
:copy_json
setlocal
set platform=%~1
set configuration=%~2
set fromdir=json-c\%platform%\%configuration%
set todir=deps\%fromdir%
xcopy /Y /I %fromdir%\include\*.h %todir%\include
xcopy /Y /I %fromdir%\lib %todir%\lib 
endlocal
goto :eof


REM copy the glib tree
:copy_glib
setlocal
set platform=%~1
set configuration=%~2
set fromdir=glib\vs12\%platform%\%configuration%
set todir=deps\%fromdir%
xcopy /Y /I %fromdir%\bin\* %todir%\bin
xcopy /Y /I %fromdir%\include\* %todir%\include
xcopy /Y /I %fromdir%\include\gio-win32-2.0\* %todir%\include\gio-win32-2.0
xcopy /Y /I %fromdir%\include\gio-win32-2.0\gio\* %todir%\include\gio-win32-2.0\gio
xcopy /Y /I %fromdir%\include\glib-2.0\* %todir%\include\glib-2.0
xcopy /Y /I %fromdir%\include\glib-2.0\gio\* %todir%\include\glib-2.0\gio
xcopy /Y /I %fromdir%\include\glib-2.0\glib\* %todir%\include\glib-2.0\glib
xcopy /Y /I %fromdir%\include\glib-2.0\glib\deprecated\* %todir%\include\glib-2.0\glib\deprecated
xcopy /Y /I %fromdir%\include\glib-2.0\gobject\* %todir%\include\glib-2.0\gobject
xcopy /Y /I %fromdir%\lib\* %todir%\lib
xcopy /Y /I %fromdir%\lib\glib-2.0\* %todir%\lib\glib-2.0
xcopy /Y /I %fromdir%\lib\glib-2.0\include\* %todir%\lib\glib-2.0\include
xcopy /Y /I %fromdir%\lib\pkgconfig\* %todir%\lib\pkgconfig
xcopy /Y /I %fromdir%\manifest\* %todir%\manifest
xcopy /Y /I %fromdir%\share\* %todir%\share
xcopy /Y /I %fromdir%\share\gettext\* %todir%\share\gettext
xcopy /Y /I %fromdir%\share\gettext\intl\* %todir%\share\gettext\intl
xcopy /Y /I %fromdir%\share\glib-2.0\* %todir%\share\glib-2.0
xcopy /Y /I %fromdir%\share\glib-2.0\codegen\* %todir%\share\glib-2.0\codegen
xcopy /Y /I %fromdir%\share\glib-2.0\schemas\* %todir%\share\glib-2.0\schemas
endlocal
goto :eof

REM copy the openssl tree
:copy_openssl
setlocal
set platform=%~1
set configuration=%~2
if %platform% == "Win32" (
	set bits=32
) else (
	set bits=64
)
set fromdir=openssl\src\openssl-%OPENSSL_VERSION%-%bits%bit-%configuration%-DLL-VS2013
set todir=deps\openssl\%platform%\%configuration%
xcopy /Y /I %fromdir%\include\openssl\*.h %todir%\include\openssl
xcopy /Y /I %fromdir%\bin\*.dll %todir%\lib 
endlocal
goto :eof

REM copy the libclamav tree
:copy_libclamav
setlocal
set platform=%~1
set configuration=%~2
set fromdir=clamav\clamav-devel\win32\%platform%\%configuration%
set todir=deps\libclamav\%platform%\%configuration%
mkdir %todir%\lib
xcopy /Y /I %fromdir%\libclamav.dll %todir%\lib
xcopy /Y /I %fromdir%\libclamav.lib %todir%\lib
mkdir %todir%\include
xcopy /Y /I clamav\clamav-devel\libclamav\*.h %todir%\include
endlocal
goto :eof

REM Add prebuilt libraries : libintl, libiconv and pcre dll.
:copy_prebuilt
setlocal
mkdir deps\libintl\lib
xcopy /Y /I libintl\libintl3.dll deps\libintl\lib
mkdir deps\libiconv\lib
xcopy /Y /I libiconv\libiconv2.dll deps\libiconv\lib
mkdir deps\pcre\lib
xcopy /Y /I pcre\pcre3.dll deps\pcre\lib
endlocal
goto :eof
