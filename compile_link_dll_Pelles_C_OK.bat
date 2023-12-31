@echo off
REM
REM   	Script de génération de la DLL dll_core.dll et des programmee de test : "testdll_implicit.exe" (chargement implicite de la DLL),
REM 	"testdll_explicit.exe" (chargement explicite de la DLL), et enfin du script de test écrit en python.
REM		Ce fichier de commande est paramètrable avec deux paraamètres : 
REM			a) le premier paramètre permet de choisir la compilation et le linkage des programmes en une seule passe
REM 			soit la compilation et le linkage en deux passes successives : compilation séparée puis linkage,
REM 		b) le deuxième paramètre définit soit une compilation et un linkage en mode 32 bits, soit en mode 64 bits
REM 	 		pour les compilateurs qui le supportent.
REM     Le premier paramètre peut prendre les valeurs suivantes :
REM 		ONE (or unknown value, because only second value of this parameter is tested during execution) ou TWO.
REM     Et le deuxième paramètre peut prendre les valeurs suivantes :
REM 		32, 64 ou  ALL si vous souhaitez lancer les deux générations, 32 bits et 64 bits.
REM
REM 	Author : 						Thierry DECHAIZE
REM		Date creation/modification : 	13/12/2023
REM 	Reason of modifications : 	n° 1 - Remove "scories" of "model" command file that has used to construct this file, "scories" of 
REM 										precedent génération with another compiler.
REM 	 							n° 2 - Blah blah Blah ...
REM 	Version number :				1.1.2	          	(version majeure . version mineure . patch level)

echo. Lancement du batch de generation d'une DLL et deux tests de celle-ci avec Pelles C 32 bits ou 64 bits
REM     Affichage du nom du système d'exploitation Windows :              	Microsoft Windows 11 Famille ... (par exemple)
REM 	Affichage de la version du système Windows :              			10.0.22621 (par exemple)
REM 	Affichage de l'architecture du système Windows : 					64-bit (par exemple)
echo. *********  Quelques caracteristiques du systeme hebergeant l'environnement de developpement.   ***********
WMIC OS GET Name
WMIC OS GET Version
WMIC OS GET OSArchitecture

REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
REM      Mandatory, add to PATH the binary directory of compiler Pelles C 32 or 64 bits. You can adapt this directory at your personal software environment.
set PATH=C:\PellesC\bin;%PATH%
pocc | find "Version"
echo. **********      Pour cette generation le premier parametre vaut "%1" et le deuxieme "%2".     ************* 
IF "%2" == "32" ( 
   call :complink32 
) ELSE (
   IF "%2" == "64" (
      call :complink64 
   ) ELSE (
      call :complink32 
	  call :complink64 
	)  
)

goto FIN

:complink32
echo. ******************            Compilation de la DLL en mode 32 bits        *******************
REM     Options used by Pelles C compiler 32 bits
REM 		-c       					Compilation only, it's default !
REM 		-Gd							Uses cdecl as the default calling convention. /Gz to use stdcall as the default calling convention or /Gn to use no decoration of exported stdcall symbols.
REM 		-Ze 						Activates Microsoft's extensions to C.
REM 		-Txxxxx						Selects the target processor and output format. Here "x86-coff", another option is "x64-coff" to 64 bits architecture
REM 		/Dxxxxx	 					Define variable xxxxxx used by precompiler
REM 		/Ixxxxxx					Define search path to include file, many repeat of this option are authorized.
REM 		/Foxxxxx 					Define output file generated by Pelles C compiler, here obj file
pocc -c -Gd -Ze -Tx86-coff /DNDEBUG /DBUILD_DLL /D_WIN32 src\dll_core.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fodll_core.obj
echo. *****************           Edition des liens .ie. linkage de la DLL.        ***************
REM     Options used by linker of lcc compiler
REM 		-machine:x86				Set architecture of 32 bits processor X86
REM 		-subsystem:console   		Mandatory to generate DLL, with others C compilers, this option is -subsystem:windows (GUI mode). It's a choice !
REM 		-dll 						Define target linker to DLL
REM 		-libpath:xxxxxxxx			Define search path to lib file. Many repeat of this option to add search path of libraries, same current directory.
REM 		/OUT:xxxxxx					Define name of output file, here dll file
polink -machine:x86 -subsystem:console -dll -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win" /OUT:dll_core.dll dll_core.obj
REM 	Not mandatory here, polink generate automatically lib file.
REM polib /MACHINE:X86 /OUT:dll_core.lib dll_core.obj
REM 	Options used by tool "podump" of Pelles C compiler
REM 		/exports				Show list of exported symbols from a library/obj/dll
echo. ************     				 Dump des sysboles exportes de la DLL dll_core.dll      				  *************
podump /exports dll_core.dll
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
pocc -c -Gd -Ze -Tx86-coff /DNDEBUG /D_WIN32 src\testdll_implicit.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fotestdll_implicit.obj
REM 	Options used by linker of Pelles C compiler
REM 		-machine:x86 				Set machine architecture to 32 bits
REM 		-subsystem:console 			Define subsystem to console, because generation of console application 
polink -machine:x86 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win" -libpath:. /OUT:testdll_implicit.exe testdll_implicit.obj dll_core.lib
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
pocc -c -Gd -Ze -Tx86-coff /DNDEBUG /D_WIN32 src\testdll_explicit.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fotestdll_explicit.obj
polink -machine:x86 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win" /OUT:testdll_explicit.exe testdll_explicit.obj
REM 	Run test program of DLL with explicit load
testdll_explicit.exe					
echo. ****************               Lancement du script python 32 bits de test de la DLL.               ********************
%PYTHON32% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON32% testdll_cdecl.py dll_core.dll 
exit /B 

:complink64
echo. ******************          Compilation de la DLL en mode 64 bits        *******************
REM      Mandatory, add to PATH the binary directory of compiler OW 64 bits. You can adapt this directory at your personal software environment.
REM     Options used by Pelles C compiler 64 bits
REM 		-c       					Compilation only, it's default !
REM 		-Gd							Uses cdecl as the default calling convention. /Gz to use stdcall as the default calling convention or /Gn to use no decoration of exported stdcall symbols.
REM 		-Ze 						Activates Microsoft's extensions to C.
REM 		-Txxxxx						Selects the target processor and output format. Here "x64-coff", another option is "x86-coff" to 32 bits architecture
REM 		/Dxxxxx	 					Define variable xxxxxx used by precompiler
REM 		/Ixxxxxx					Define search path to include file, many repeat of this option are authorized.
REM 		/Foxxxxx 					Define output file generated by Pelles C compiler, here obj file
pocc -c -Gd -Ze -Tx64-coff /DNDEBUG /DBUILD_DLL /D_WIN32 src\dll_core.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fodll_core64.obj
echo. *****************           Edition des liens .ie. linkage de la DLL.        ***************
REM     Options used by linker of Pelles C compiler
REM 		-machine:x64				Set architecture of 64 bits processor X64
REM 		-subsystem:console   		Mandatory to generate DLL, with others C compilers, this option is -subsystem:windows (GUI mode). It's a choice !
REM 		-dll 						Define target linker to DLL
REM 		-libpath:xxxxxxxx			Define search path to lib file. Many repeat of this option to add search path of libraries, same current directory.
REM 		/OUT:xxxxxx					Define name of output file, here dll file
polink -machine:x64 -subsystem:console -dll -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win64" /OUT:dll_core64.dll dll_core64.obj
REM 	Not mandatory here, polink generate automatically lib file.
REM polib /MACHINE:X64 /OUT:dll_core64.lib dll_core64.obj
REM 	Options used by tool "podump" of Pelles C compiler
REM 		/exports				Show list of exported symbols from a library/exe/obj/dll
echo. ************     				 Dump des symboles exportes de la DLL dll_core64.dll      				  *************
podump /exports dll_core64.dll
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
pocc -c -Gd -Ze -Tx64-coff /DNDEBUG /D_WIN32 src\testdll_implicit.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fotestdll_implicit64.obj
REM 	Options used by linker of Pelles C compiler
REM 		-machine:x64 				Set machine architecture to 64 bits
REM 		-subsystem:console 			Define subsystem to console, because generation of console application 
polink -machine:x64 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win64" -libpath:. /OUT:testdll_implicit64.exe testdll_implicit64.obj dll_core64.lib
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
pocc -c -Gd -Ze -Tx64-coff /DNDEBUG /D__POCC64__ /D_WIN32 src\testdll_explicit.c /IC:\PellesC\include /IC:\PellesC\include\Win /Fotestdll_explicit64.obj
polink -machine:x64 -subsystem:console -libpath:"C:\PellesC\Lib" -libpath:"C:\PellesC\Lib\Win64" /OUT:testdll_explicit64.exe testdll_explicit64.obj
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe					
echo. ************                   Lancement du script python 64 bits de test de la DLL                    **************
%PYTHON64% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON64% testdll_cdecl.py dll_core64.dll 
exit /B 

:FIN
echo.        Fin de la generation de la DLL et des tests avec Pelles C 32 bits ou 64 bits.
REM 	Return in initial PATH
set PATH=%PATHINIT%
