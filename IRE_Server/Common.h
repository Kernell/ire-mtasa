// Innovation Roleplay Engine
// 
// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

#if _DEBUG

#define NULL 0

#include <string>

using namespace std;

typedef	unsigned long	    ulong;      //  32      32      64
typedef unsigned int	    uint;       //  32
typedef unsigned short	    ushort;     //  16  
typedef unsigned char	    uchar;      //  8

typedef unsigned long long  uint64;     //  64
typedef unsigned int        uint32;     //  32
typedef unsigned short      uint16;     //  16
typedef unsigned char       uint8;      //  8

// signed types
typedef signed long long    int64;      //  64
typedef signed int          int32;      //  32
typedef signed short        int16;      //  16
typedef signed char         int8;       //  8

// Windowsesq types
typedef unsigned char       BYTE;       //  8
typedef unsigned short      WORD;       //  16
typedef unsigned long       DWORD;      //  32      32      64
typedef float               FLOAT;      //  32

#define private private:

namespace CMTA
{
	string	Get( const string sKey );
	bool	Set( const string sKey, const string sValue );
	
	bool	SetGameType		( const string sType );
	bool	SetMapName		( const string sName );
	
	bool	SetRuleValue	( const string sKey, const string sValue );
};

class CMySQL
{
public:
	CMySQL( const string sUser, const string sPwd, const string sDB, const string sHost );

	int Ping();
};

class CBlowfish
{
public:
	CBlowfish( const string sKey );

	const string Encrypt( const string sString );
	const string Decrypt( const string sString );
};

class CLog
{
public:
	CLog( const string sLogName );
};

#endif