//*********************    File : dll_share.h (include file shared)    *****************

#ifndef HEADER_6164DC2083FF3BEC
#define HEADER_6164DC2083FF3BEC

/* Test Windows platform */

#if defined(__NT__) || defined(_WIN32) || defined(_Windows) // __NT__ with OpenWatcom, _WIN32 with GCC, MSVC, clang, Pelles C, lcc (?) _Windows with Borland C/C++ defined Windows Platforms

  /* You should define BUILD_DLL *only* when building the DLL. */
  
  #ifdef BUILD_DLL
    #define ADDAPI  __declspec(dllexport)
  #else
    #define ADDAPI  __declspec(dllimport)
  #endif

  /* Define calling convention in one place, for convenience. */
  #if defined(__LCC__) // || defined(__WATCOMC__)
    #define ADDCALL  _stdcall
  #elif defined (__BORLANDC__) || defined(__POCC__)
    #define ADDCALL  __stdcall
  #else	
    #define ADDCALL  __cdecl
  # endif


#elif defined(_linux) || defined(UNIX)

	#if defined(BUILD_DLL) && defined(HAS_GCC_VISIBILITY)
	#   define ADDAPI  _attribute_  _((visibility("default")))
	#endif

#else /* __NT__ or _WIN32 or _Windows or _Linux not defined. */

  /* Define with no value on non-Windows OSes. */
  #define ADDAPI
  #define ADDCALL

#endif

extern ADDAPI int __cdecl hello( void );
extern ADDAPI int __cdecl add(int i1, int i2);
extern ADDAPI int __cdecl substract(int i1, int i2);
extern ADDAPI int __cdecl multiply(int i1, int i2);

#endif // header guard

//*********************           End file : dll_share.h            *****************

