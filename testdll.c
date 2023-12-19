//*******************      File : testdll.c (main test of dll with load implicit)         *****************
/* testdll.c

   Demonstrates using the function imported from the DLL, in a 
   flexible and elegant way.
*/
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include "dll_share.h"

int main(int argc, char** argv)
{
	int  aa,bb,result;
	aa = 42;
	bb = 7;

	hello();
	result = add(aa, bb);
	printf("La somme de %i plus %i vaut %i. (from application %s)\n", aa, bb, result, argv[0]);

	result = substract(aa, bb);
	printf("La difference de %i moins %i vaut %i. (from application %s)\n", aa, bb, result, argv[0]);

	result = multiply(aa, bb);
	printf("La multiplication de %i par %i vaut %i. (from application %s)\n", aa, bb, result, argv[0]);

	return(0);
}
//*******************                   End file : testdll.c              *****************

