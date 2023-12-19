@echo off
REM Compile and link an example of DLL, and after, compile and link program test of DLL
SET PATHINIT=%PATH%
SET PATH=C:\PellesC\bin;%PATH%
REM -Gd create __cdecl exports
REM -Gz create __stdcall exports and with -Gn undecorated __stdcall functions
pocc -c -Gd -Ze -Tx86-coff dllcore.c /IC:\PellesC\include /IC:\PellesC\include\Win /DBUILD_DLL 
polink -machine:x86 -subsystem:console -dll -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win" dllcore.obj
podump /exports dllcore.dll
pocc -c -Gd -Ze -Tx86-coff testdll.c /IC:\PellesC\include /IC:\PellesC\include\Win
polink -machine:x86 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win" -libpath:. testdll.obj dllcore.lib
testdll.exe
%PYTHON32% test_add_cdecl.py dllcore.dll
SET PATH=%PATHINIT%
