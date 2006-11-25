// ginc_math
/*
    Math related functions
*/
// ChazM 9/22/05
// ChazM 10/21/05 - added IsFloatNearInt()
// DBR - 2/13/06 - Adding optional parameter of precision to RandomFloat()
// BMA-OEI 5/4/06 - Added RandomFloatBetween(), RandomIntBetween()
// BMA/CGAW 5/18/06 - Updated RandomFloat(), RandomFloatBetween()
// ChazM 8/8/06 - Added SetLocalIntState(), GetLocalIntState(), SetState(), GetState()
// BMA-OEI 10/09/06 - Added GetHexStringDigitValue(), HexStringToInt()

//void main() {}

#include "ginc_debug"

const float EPSILON	= 0.00001f;

//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------
	
float RandomDelta(float fMagnitude);
float RandomFloat(float fNum);
float RandomFloatBetween( float fFloatA, float fFloatB=0.000f );
int RandomIntBetween( int nIntA, int nIntB=0 );
location GetNearbyLocation(location lTarget, float fDistance, float fFacingNoise=0.0f);
int IsIntInRange(int iVar, int iMin, int iMax);
int ScaleInt (int iNum, float fNum);
int IsFloatNearInt(float fValue, int iValue);

void SetLocalIntState(object oTarget, string sVariable, int iBitFlags, int bSet = TRUE);
int GetLocalIntState(object oTarget, string sVariable, int iBitFlags);
int SetState(int iValue, int iBitFlags, int bSet = TRUE);
int GetState(int iValue, int iBitFlags);

// Return ASCII value of hexadecimal digit sHexDigit
// * Returns -1 if sHexDigit is not a valid hex digit (0-aA)
int GetHexStringDigitValue( string sHexDigit );

// Return integer value of hexadecimal string sHexString
// * Can convert both "0x????" and "????" where "?" is a hex digit
int HexStringToInt( string sHexString );

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------
	
// gives a random number between -fMagnitude and fMagnitude
// preserve 2 decimal places
float RandomDelta(float fMagnitude)
{
	float fRet = IntToFloat(Random(FloatToInt(fMagnitude * 100.0f)))/100.0f;
    if (d2()==1)
        fRet = -fRet;
	return (fRet);
}

// Returns a random float between fNum and 0. See RandomFloatBetween() for additional information.
float RandomFloat(float fNum)
{
	float fRet = RandomFloatBetween( fNum );
	return (fRet);
}

// Return a random float value between fFloatA and fFloatB
// NOTE: Maximum accuracy is produced when the difference between A and B is no more than:
// 32,767/10^N, where N = The number of contiguous digits to the right of the decimal point that are important.  
// For instance, if the float should be accurate for three decimal places: xx.000, then to have maximum
// accuracy, the difference between A and B shouldn't be more than 32,767/10^3, or 32.767.
float RandomFloatBetween( float fFloatA, float fFloatB=0.000f )
{
	float fLesserFloat;
	float fGreaterFloat;
	float fDifference;
	float fRandomFloat;
	float fMultiplier = IntToFloat( Random( 32767 ) ) / 32766.f;

	if ( fFloatA <= fFloatB )
	{
		fLesserFloat = fFloatA;
		fGreaterFloat = fFloatB;
	}
	else
	{
		fLesserFloat = fFloatB;
		fGreaterFloat = fFloatA;
	}

	fDifference = fGreaterFloat - fLesserFloat;
	fRandomFloat = ( fDifference * fMultiplier ) + fLesserFloat;

	return ( fRandomFloat );
}

// Return a random int value between nIntA and nIntB
int RandomIntBetween( int nIntA, int nIntB=0 )
{
	int nLesserInt;
	int nGreaterInt;
	int nDifference;
	int nRandomInt;

	if ( nIntA <= nIntB )
	{
		nLesserInt = nIntA;
		nGreaterInt = nIntB;
	}
	else
	{
		nLesserInt = nIntB;
		nGreaterInt = nIntA;
	}

	nDifference = nGreaterInt - nLesserInt;
	nRandomInt = Random( nDifference + 1 ) + nLesserInt;

	return ( nRandomInt );
}

// get a location fDistance units from lTarget
// location lTarget - target location
// float fDistance - max random distance
location GetNearbyLocation(location lTarget, float fDistance, float fFacingNoise=0.0f)
{
    vector vOld = GetPositionFromLocation(lTarget);
	float x = RandomDelta(fDistance);
	float y = RandomDelta(fDistance);
    vector vNew = vOld + Vector(x, y);
	float fNewFacing = GetFacingFromLocation(lTarget) + RandomDelta(fFacingNoise);
	if (fNewFacing < 0.0f) fNewFacing = fNewFacing + 360.0f;
	else if (fNewFacing > 360.0f) fNewFacing = fNewFacing - 360.0f;	
    location lNewLocation = Location (GetAreaFromLocation(lTarget), vNew, fNewFacing);
    return lNewLocation;
}


int IsIntInRange(int iVar, int iMin, int iMax)	
{
	return((iVar >= iMin) && (iVar <= iMax));
}


// multiply int by float and return resulting int part	
int ScaleInt (int iNum, float fNum)	
{
	return (FloatToInt(IntToFloat(iNum) * fNum));
}

int IsFloatNearInt(float fValue, int iValue)
{
	//int iRet = FALSE;
	float fCompareValue = IntToFloat(iValue);
	if (fValue > fCompareValue + EPSILON)
		return (FALSE);

	if (fValue < fCompareValue - EPSILON)
		return (FALSE);
	
	return (TRUE);
}

// sets the bit flags on or off in the local int
void SetLocalIntState(object oTarget, string sVariable, int iBitFlags, int bSet = TRUE)
{
	int iValue = GetLocalInt(oTarget, sVariable);
	int iNewValue = SetState(iValue, iBitFlags, bSet);
	SetLocalInt(oTarget, sVariable, iNewValue);
}

// returns TRUE or FALSE 
// if multiple flags, will return true if any of iBitFlags are true.
int GetLocalIntState(object oTarget, string sVariable, int iBitFlags)
{
	int iValue = GetLocalInt(oTarget, sVariable);
	return (GetState(iValue, iBitFlags));
}

// sets state of iBitFlags in iValue and returns new value.
// if multiple flags, all will be modified
int SetState(int iValue, int iBitFlags, int bSet = TRUE)
{
    if(bSet == TRUE)
    {
        iValue = iValue | iBitFlags;
    }
    else if (bSet == FALSE)
    {
        iValue = iValue & ~iBitFlags;
    }
	return (iValue);
}

// returns state of iBitFlag in iValue.  
// if multiple flags, will return true if any are true.
int GetState(int iValue, int iBitFlags)
{
	return (iValue & iBitFlags);
}

// Return ASCII value of hexadecimal digit sHexDigit
// * Returns -1 if sHexDigit is not a valid hex digit (0-aA)
int GetHexStringDigitValue( string sHexDigit )
{
	int nValue = CharToASCII( sHexDigit );

	if ( ( nValue >= 48 ) && ( nValue <= 57 ) ) 		// 0-9 [0x30-0x39]
	{
		return ( nValue - 48 );
	}
	else if ( ( nValue >= 65 ) && ( nValue <= 70 ) )	// A-F [0x41-0x46]
	{
		return ( nValue - 55 );
	}
	else if ( ( nValue >= 97 ) && ( nValue <= 102 ) )	// a-f [0x61-0x66]
	{
		return ( nValue - 87 );
	}
	else
	{
		return ( -1 );
	}
}

// Return integer value of hexadecimal string sHexString
// * Can convert both "0x????" and "????" where "?" is a hex digit
int HexStringToInt( string sHexString )
{
	int nStringLen = GetStringLength( sHexString );
	int nReturn = 0;
	
	if ( nStringLen > 0 )
	{
		int nPos = 0;
		
		// Check for "0x" prefix
		if ( nStringLen >= 2 )
		{
			if ( GetSubString( sHexString, 0, 2 ) == "0x" )
			{
				nPos = 2;
			}
		}
		
		string sChar;
		int nChar;

		// For length of hex string
		while ( nPos < nStringLen )
		{
			// Get digit at position nPos
			sChar = GetSubString( sHexString, nPos, 1 );
			nChar = GetHexStringDigitValue( sChar );
			
			if ( nChar != -1 )
			{
				// "bitshift left 4", OR nChar
				nReturn = ( nReturn << 4 ) | nChar;
			}
			else
			{
				// Invalid hex digit found
				break;
			}
			
			nPos = nPos + 1;
		}
	}
	
	return ( nReturn );
}