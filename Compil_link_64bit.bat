@echo off
REM Compile and link an example of DLL, and after, compile and link program test of DLL
SET PATHINIT=%PATH%
SET PATH=C:\PellesC\bin;%PATH%
REM -Gd create __cdecl exports
REM -Gz create __stdcall exports and with -Gn undecorated __stdcall functions
pocc -c -Gd -Ze -Tx64-coff dllcore.c /IC:\PellesC\include /IC:\PellesC\include\Win /DBUILD_DLL /Fodllcore64.obj
polink -machine:x64 -subsystem:console -dll -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win64" dllcore64.obj /OUT:dllcore64.dll
podump /exports dllcore64.dll
pocc -c -Gd -Ze -Tx64-coff testdll.c  /IC:\PellesC\include /IC:\PellesC\include\Win /Fotestdll64.obj
polink -machine:x64 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win64" -libpath:"." testdll64.obj dllcore64.lib /OUT:testdll64.exe
testdll64.exe
%PYTHON64% test_add_cdecl.py dllcore64.dll
SET PATH=%PATHINIT%