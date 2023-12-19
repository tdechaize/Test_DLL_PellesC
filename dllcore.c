//*********************    File : dllcore.c (main core of DLL)    *****************
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include "dll_share.h"

/* Optional DllMain function */

BOOL ADDCALL DllMain( HANDLE hinstDLL, DWORD dwReason, LPVOID lpvReserved )
{
    switch( dwReason ) {
    case DLL_PROCESS_ATTACH:
        printf( "DLL attaching to process...\n" );
        break;
    case DLL_PROCESS_DETACH:
        printf( "DLL detaching from process...\n" );
        break;
		// The attached process creates a new thread.
	case DLL_THREAD_ATTACH:
		printf("The attached process creating a new thread...\n");
		break;
		// The thread of the attached process terminates.
	case DLL_THREAD_DETACH:
		printf("The thread of the attached process terminates...\n");
		break;
	default:
		printf("Reason called not matched, error if any : %ld...\n", GetLastError());
		break;
    }
    return( 1 );    /* Indicate success */
}


ADDAPI int __cdecl hello( void )
{
    printf( "Hello from a DLL!\n" );
    return( 0 );
}

ADDAPI int __cdecl add(int i1, int i2)
 {
	int result;
	result = i1 + i2;
	return result;
 }

ADDAPI int __cdecl substract(int i1, int i2)
 {
	int result;
	result = i1 - i2;
	return result;
 }

ADDAPI int __cdecl multiply(int i1, int i2)
 {
	int result;
	result = i1 * i2;
	return result;
 }
//******************************    End file : dllcore.c   *********************************

