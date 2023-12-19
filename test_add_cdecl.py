#           test_add_cdecl.py
import ctypes, ctypes.util
import os
import sys
if len( sys.argv ) == 1:
    print( "test_add_cdecl.py script wrote by Thierry DECHAIZE, thierry.dechaize@gmail.com" )
    print( "\tusage: python test_add_cdecl.py Name_Dll." )
    exit()

cwd = os.getcwd()
dll_name = cwd + '\\' + sys.argv[1]
mydll_path = ctypes.util.find_library(dll_name)
if not mydll_path:
    print("Unable to find the specified DLL.")
    sys.exit()
  
#mydll = ctypes.WinDLL(dll_name)          # load the dll __stdcall  
try:    
    mydll = ctypes.CDLL(dll_name)      # load the dll __cdecl
except OSError:
    print(f"Unable to load the specified DLL : {sys.argv[1]}.")
    sys.exit()
    
# test mandatory in case of Borland generation, the export function is decorated by "_" prefix  => call _Add
if 'BC55' in sys.argv[1]  or 'PELLESC64' in sys.argv[1] or 'OW32' in sys.argv[1]: 
    print("Un petit coucou : {mydll._hello}")
    mydll._add.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La somme de 42 plus 7 vaut {mydll._add(42, 7)}. (from script python {sys.argv[0]})")
else:
#    mydll.hello.argtypes = (ctypes.c_void)
    mydll.hello(None)
    mydll.add.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La somme de 42 plus 7 vaut {mydll.add(42, 7)}. (from script python {sys.argv[0]})")
    mydll.substract.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La difference de 42 moins 7 vaut {mydll.substract(42, 7)}. (from script python {sys.argv[0]})")
    mydll.multiply.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La multiplication de 42 par 7 vaut {mydll.multiply(42, 7)}. (from script python {sys.argv[0]})")

