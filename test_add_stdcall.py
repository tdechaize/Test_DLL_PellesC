#test_add_stdcall.py
import ctypes, ctypes.util
import os
import sys
if len( sys.argv ) == 1:
    print( "test_add_stdcall.py script wrote by Thierry DECHAIZE, thierry.dechaize@gmail.com" )
    print( "\tusage: python3 test_add.py Name_Dll." )
    exit()

cwd = os.getcwd()
dll_name = cwd + '\\' + sys.argv[1]
mydll_path = ctypes.util.find_library(dll_name)
if not mydll_path:
    print("Unable to find the specified DLL.")
    sys.exit()

# mydll = ctypes.CDLL(dll_name)          # load the dll __cdecl    
try:    
    mydll = ctypes.WinDLL(dll_name)      # load the dll __stdcall
except OSError:
    print(f"Unable to load the specified DLL : {sys.argv[1]}.")
    sys.exit()

# test mandatory in case of Borland generation, the export function is decorated by "_" prefix => call _Add
#if 'BC55' in sys.argv[1]:
#    mydll._Add.argtypes = (ctypes.c_int, ctypes.c_int)
#    print(f"La somme de 42 plus 7 vaut {mydll._Add(42, 7)}. (from script python {sys.argv[0]})")
#else:
mydll.Add.argtypes = (ctypes.c_int, ctypes.c_int)
print(f"La somme de 42 plus 7 vaut {mydll.Add(42, 7)}. (from script python {sys.argv[0]})") 