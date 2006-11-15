//::///////////////////////////////////////////////////////////////
//:: X0_I0_STRINGLIB
//:: Copyright (c) 2002 Floodgate Entertainment
//::///////////////////////////////////////////////////////////////
/*
This library contains general string-manipulation functions
for convenience.

 */
//::///////////////////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/10/2002
//::///////////////////////////////////////////////////////////////
// 1/19/06 ChazM  Added List related functions: GetFirstAlpha(), RemoveListElement(), Sort()
// 1/31/06 ChazM Added FormListElement(), AppendToList()
// 2/3/06 ChazM Added FindListElementIndex(), GetIsInList(), AppendUniqueToList(), AppendGlobalList()

/**********************************************************************
 * CONSTANTS & TYPES
 **********************************************************************/

struct sStringTokenizer {
    int nRemainingLen;
    string sOrig;
    string sRemaining;
    string sDelim;
    string sLastTok;
};

int DELIM_NOT_FOUND = -1;

struct rNameValuePair {
    string sName;
    int iValue;
};



/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get a string tokenizer for sString. sDelim may be multiple
// characters in length.
struct sStringTokenizer GetStringTokenizer(string sString, string sDelim);

// Check to see if any more tokens remain. Returns 0 if not, 1 if so.
int HasMoreTokens(struct sStringTokenizer stTok);

// Get next token
struct sStringTokenizer AdvanceToNextToken(struct sStringTokenizer stTok);

// Get the last token retrieved
string GetNextToken(struct sStringTokenizer stTok);

// Get the number of tokens in the string, by delimeter.
int GetNumberTokens(string sString, string sDelim);

// Get the specified token in the string, by delimiter.
// The first string is position 0, the second is position 1, etc.
string GetTokenByPosition(string sString, string sDelim, int nPos);


struct rNameValuePair GetFirstAlpha(string sArray, string sDelimiter=",");
string RemoveListElement(string sString, string sSubString, string sDelimiter=",");
//string SpliceString(string sString, int iStartIndex, int iLength);
string Sort(string sList, string sDelimiter=",");

string FormListElement(string sElement, string sDelimiter=",");
string AppendToList(string sList, string sElement, string sDelimiter=",");
	
int FindListElementIndex(string sList, string sElement, string sDelimiter=",");
int GetIsInList(string sList, string sElement, string sDelimiter=",");
string AppendUniqueToList(string sList, string sElement, string sDelimiter=",");
string AppendGlobalList(string sVarName, string sElement, int bUnique=FALSE, string sDelimiter=",");

// Returns string to pad input to length nPadLen
string GetStringPad( string sInput, int nPadLen, string sPadChar=" " );

/**********************************************************************
 * FUNCTIONS
 **********************************************************************/

// Get a string tokenizer for sString. sDelim may be multiple
// characters in length.
struct sStringTokenizer GetStringTokenizer(string sString, string sDelim)
{
    struct sStringTokenizer sNew;

    sNew.sOrig = sString;
    sNew.sRemaining = sString;
    sNew.sDelim = sDelim;
    sNew.sLastTok = "";
    sNew.nRemainingLen = GetStringLength(sString);

    return sNew;
}

// Check to see if any more tokens remain. Returns 0 if not, 1 if so.
int HasMoreTokens(struct sStringTokenizer stTok)
{
    if (stTok.nRemainingLen > 0) {
        return TRUE;
    }
    return FALSE;
}

// Move tokenizer to next token
struct sStringTokenizer AdvanceToNextToken(struct sStringTokenizer stTok)
{
    int nDelimPos = FindSubString(stTok.sRemaining, stTok.sDelim);
    if (nDelimPos == DELIM_NOT_FOUND) {
        // no delimiters in the string
        stTok.sLastTok = stTok.sRemaining;
        stTok.sRemaining = "";
        stTok.nRemainingLen = 0;
    } else {
        stTok.sLastTok = GetSubString(stTok.sRemaining, 0, nDelimPos);
        stTok.sRemaining = GetSubString(stTok.sRemaining,
                                        nDelimPos+1,
                                        stTok.nRemainingLen - (nDelimPos+1));
        stTok.nRemainingLen = GetStringLength(stTok.sRemaining);
    }

    return stTok;
}

// Get the next token
string GetNextToken(struct sStringTokenizer stTok)
{
    return stTok.sLastTok;
}

// Get the number of tokens in the string, by delimeter.
int GetNumberTokens(string sString, string sDelim)
{
    struct sStringTokenizer stTok = GetStringTokenizer(sString, sDelim);
    int nElements = 0;
    while (HasMoreTokens(stTok)) {
        stTok = AdvanceToNextToken(stTok);
        nElements++;
    }
    return nElements;
}

// Get the specified token in the string, by delimiter.
// The first string is position 0, the second is position 1, etc.
string GetTokenByPosition(string sString, string sDelim, int nPos)
{
    struct sStringTokenizer stTok = GetStringTokenizer(sString, sDelim);
    int i=0;
    while (HasMoreTokens(stTok) && i <= nPos) {
        stTok = AdvanceToNextToken(stTok);
        i++;
    }
    if (i != nPos + 1) 
        return "";

    return GetNextToken(stTok);
}


// --------------------------------------------------------------------------
/*
// GetCharInt() and StringCompareLT() no longer needed now that we have StringCompare()


// returns the string which occurs first alphabetically
// order is similar to ASCII
// does not distinguish case
int GetCharInt(string sChar)
{
    // make sure only looking at 1 char
    sChar = GetStringLeft(GetStringUpperCase(sChar), 1);
    int iChar;

    iChar = StringToInt(sChar);
    // might be 0 if not readable or if is actually "0"
    if ((iChar == 0) && (sChar != "0"))
        iChar = -1;

    if (sChar == "~")
        iChar = 126;
    else if (sChar == " ")
        iChar = 32;
    else if (sChar == "_")
        iChar = 95;
    else if (sChar == "A")
        iChar = 65;
    else if (sChar == "B")
        iChar = 66;
    else if (sChar == "B")
        iChar = 67;
    else if (sChar == "C")
        iChar = 68;
    else if (sChar == "D")
        iChar = 69;
    else if (sChar == "E")
        iChar = 70;
    else if (sChar == "F")
        iChar = 71;
    else if (sChar == "G")
        iChar = 72;
    else if (sChar == "H")
        iChar = 73;
    else if (sChar == "I")
        iChar = 74;
    else if (sChar == "J")
        iChar = 75;
    else if (sChar == "K")
        iChar = 76;
    else if (sChar == "L")
        iChar = 77;
    else if (sChar == "M")
        iChar = 78;
    else if (sChar == "N")
        iChar = 79;
    else if (sChar == "O")
        iChar = 80;
    else if (sChar == "P")
        iChar = 81;
    else if (sChar == "Q")
        iChar = 82;
    else if (sChar == "R")
        iChar = 83;
    else if (sChar == "S")
        iChar = 84;
    else if (sChar == "T")
        iChar = 85;
    else if (sChar == "U")
        iChar = 86;
    else if (sChar == "V")
        iChar = 87;
    else if (sChar == "W")
        iChar = 88;
    else if (sChar == "X")
        iChar = 89;
    else if (sChar == "Y")
        iChar = 90;
    else if (sChar == "Z")
        iChar = 91;

    return (iChar);
}

// return true if s1 < s2
int StringCompareLT(string s1, string s2)
{
    int i = 0;
    string c1 = GetSubString(s1, i, 1);
    string c2 = GetSubString(s2, i, 1);

    // find first match that is not equal
    // stop looking if both characters are empty strings
    while((c1 == c2) && (c1 != ""))
    {
        i++;
        c1 = GetSubString(s1, i, 1);
        c2 = GetSubString(s2, i, 1);
    }

    int i1 = GetCharInt(c1);
    int i2 = GetCharInt(c2);
    return (i1 < i2);
}
*/

// return index and value of the first string in alphabetical order
// return -1 if empty string
struct rNameValuePair GetFirstAlpha(string sArray, string sDelimiter=",")
{
    struct rNameValuePair rAlpha;

    rAlpha.iValue       = -1;
    rAlpha.sName        = "~";

    int iCurrent        = 0;
    string sCurrentElement  = "";
    struct sStringTokenizer stTestTok = GetStringTokenizer(sArray, sDelimiter);

    while (HasMoreTokens(stTestTok))
    {
        stTestTok = AdvanceToNextToken(stTestTok);
        sCurrentElement = GetNextToken(stTestTok);
        //if (StringCompareLT(sCurrentElement, rAlpha.sName))
        if (StringCompare(sCurrentElement, rAlpha.sName, TRUE) < 0)
        {
            rAlpha.iValue   = iCurrent;
            rAlpha.sName    = sCurrentElement;
        }
        iCurrent++;
        GetNextToken(stTestTok);
    }
    return (rAlpha);
}
	
// remove first occurence of substring from string along with delimiter
// test,test2,test3,
// 01234567890123456
// len = 16
// iSubStrCount = 6
// index1 = 5

// len = 16
// iSubStrCount =  6
// index1 = 11

string RemoveListElement(string sString, string sSubString, string sDelimiter=",")
{
    int iIndex1      	= FindSubString (sString, sSubString);
	int iDelimiterLength = GetStringLength(sDelimiter);
    int iSubStrCount	= GetStringLength(sSubString) + iDelimiterLength;

    int iIndex2     = iSubStrCount + iIndex1;
    int iRightCount = GetStringLength(sString) - iIndex2;
    string sRet;

	sRet 	= GetSubString(sString, 0, iIndex1); // first part
	// if this was last element and there was no delimiter on the right,
	// iIndex2 will be off the edge, but that's ok, it still returns ""
    sRet    += GetSubString(sString, iIndex2, iRightCount); // last part

	// remove any delimiter on the right (mostly for when we took the last element
	// off the list, leaving a dangling comma)
    if (GetStringRight(sRet, iDelimiterLength) == sDelimiter)
        sRet = GetStringLeft(sRet, GetStringLength(sRet) - iDelimiterLength) ;

    return (sRet);
}

/*
string SpliceString(string sString, int iStartIndex, int iLength)
{
	// to be implemented
	return ("");
}
*/
	
// Case-sensitive, alphabetical sort of a delimited list.  
string Sort(string sList, string sDelimiter=",")
{
    int i = 1;
    string sSortedList  = "";
    struct rNameValuePair rAlpha = GetFirstAlpha(sList, sDelimiter);

    //PrintString(IntToString(i) + " - rAlpha.sName = " + rAlpha.sName);

    while (rAlpha.iValue != -1)
    {
        if (i > 1)
            sSortedList += sDelimiter;
        sSortedList += rAlpha.sName;	// add string to sorted list
        //PrintString(IntToString(i) + " - sSortedList = " + sSortedList);
        sList = RemoveListElement(sList, rAlpha.sName); // Remove the string from the list
        //PrintString(IntToString(i) + " - sArray = " + sArray);
        i++;
        rAlpha = GetFirstAlpha(sList);
        //PrintString(IntToString(i) + " - rAlpha.sName = " + rAlpha.sName);
    }
//        sSortedList = rAlpha.sName;
//        PrintString(IntToString(i) + " - sSortedList = " + sSortedList);

    return (sSortedList);
}

// Create a list element.  Returns sElement w/ prepended delimiter (unless empty string)
// doesn't work for 
string FormListElement(string sElement, string sDelimiter=",")
{
    if (sElement != "")
       sElement = sDelimiter + sElement;
    return(sElement);
}

// Add an element to a list.  Will not add empty string Elements.
string AppendToList(string sList, string sElement, string sDelimiter=",")
{
	// don't preceed with delimiter if this is the first element
	if (sList == "")
		sDelimiter = "";

	sList += FormListElement(sElement, sDelimiter);
    return(sList);
}

// returns token index of first occurence of sElement in sList
// return -1 if not found
int FindListElementIndex(string sList, string sElement, string sDelimiter=",")
{
	int bTokenFound 	= FALSE;
    int iValue       	= -1;
    int iCurrent        = 0;
    string sCurrentElement  = "";
    struct sStringTokenizer stTok = GetStringTokenizer(sList, sDelimiter);

    while (HasMoreTokens(stTok) && !bTokenFound)
    {
        stTok = AdvanceToNextToken(stTok);
        sCurrentElement = GetNextToken(stTok);
        if (sCurrentElement == sElement)
        {
            iValue   = iCurrent;
			bTokenFound = TRUE;
        }
        iCurrent++;
        GetNextToken(stTok);
    }
    return (iValue);
}

// returns true if element found in list
int GetIsInList(string sList, string sElement, string sDelimiter=",")
{
	int iIndex = FindListElementIndex(sList, sElement, sDelimiter);
    return (iIndex != -1);
}	


// Appends sElement to sList only if it does not already exist.  
// Returns the complete list
string AppendUniqueToList(string sList, string sElement, string sDelimiter=",")
{
	if (!GetIsInList(sList, sElement, sDelimiter))
		sList = AppendToList(sList, sElement, sDelimiter);

	return (sList);
}

// append sElement to global string (treated as a list)
string AppendGlobalList(string sVarName, string sElement, int bUnique=FALSE, string sDelimiter=",")
{
	string sList = GetGlobalString(sVarName);
	if (bUnique)
		sList = AppendUniqueToList(sList, sElement, sDelimiter);
	else
		sList = AppendToList(sList, sElement, sDelimiter);

	SetGlobalString(sVarName, sList);
	return (sList);
}

// Returns string to pad input to length nPadLen
string GetStringPad( string sInput, int nPadLen, string sPadChar=" " )
{
	string sRet = "";

	int nInputLen = GetStringLength( sInput );
	
	while ( nInputLen < nPadLen )
	{
		sRet = sRet + sPadChar;
		nInputLen = nInputLen + 1;
	}

	return ( sRet );
}


// Only here for debugging -- close the comment right below
// to enable the main routine.
/* 
void main()
{ 

    string sTest = "This|is|a|test";

    // Basic usage: 
    struct sStringTokenizer stTestTok = GetStringTokenizer(sTest, "|");
    while (HasMoreTokens(stTestTok)) {
        stTestTok = AdvanceToNextToken(stTestTok);
        SpeakString("Next token: " + GetNextToken(stTestTok));
    }
    SpeakString("end of tokens");

    // Make sure we don't do something bad when we run out of tokens:
    stTestTok = GetStringTokenizer(sTest, "|");
    int i;
    for (i=0; i < 5; i++) {
        SpeakString("HasMoreTokens: " + IntToString(HasMoreTokens(stTestTok)));
        stTestTok = AdvanceToNextToken(stTestTok);
        SpeakString("Next token: " + GetNextToken(stTestTok));
    } 

    // Get a specific token
    for (i=0; i < 5; i++) {
        SpeakString("In position " + IntToString(i) 
                    + ": " + GetTokenByPosition(sTest, "|", i));
    }
    
}
/* */