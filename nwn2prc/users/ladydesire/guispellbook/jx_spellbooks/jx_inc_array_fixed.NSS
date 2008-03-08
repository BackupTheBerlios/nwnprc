//::///////////////////////////////////////////////
//:: JX Array of fixed-elements Include
//:: jx_inc_array_fixed
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 8, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// arrays of fixed-size elements.
// The advantage of this type of array is that it
// requires few instructions to perform many
// different operations (avoiding TMI errors).
// The drawback is that the array takes a lot of
// memory space, especially if the array contains
// elements of very different sizes.
//
// The operations available are :
// - Create an array
// - Get the number of elements
// - Add an element
// - Insert an element
// - Modify an element
// - Remove an element
// - Invert elements
// - Get an element by position
// - Find the position of an element
// - Add an array to another array
// - Remove an array from another array
// - Sort an array ("quicksort" algorithm)
//
//:://////////////////////////////////////////////



// Structure that represents an array of fixed-size elements.
// It can be converted into a string with JXFixedArrayToString()
// then back into a structure with JXFixedArrayToStruct()
struct jx_array_fixed
{
	int iNbElements;
	int iMaxElementSize;
	string sArray;
};



// Constants used by JXFixedArraySortElements() to specify
// the sorting type (alphabetic or numeric)
const int JX_SORTTYPE_ALPHABETIC = 1;
const int JX_SORTTYPE_NUMERIC = 2;



// Create an empty array of fixed-size elements
// - iMaxElementSize Maximimum size of an element in the array (max 99998)
// * Returns an empty array
struct jx_array_fixed JXFixedArrayCreate(int iMaxElementSize);

// Get the number of elements in an array of fixed-size elements
// - array Array of fixed-size elements
// * Returns the number of elements
int JXFixedArrayCountElements(struct jx_array_fixed array);

// Add an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// * Returns the updated array
struct jx_array_fixed JXFixedArrayAddElement(struct jx_array_fixed array, string sElement);

// Insert an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// - iPosition Position of the element to insert (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayInsertElement(struct jx_array_fixed array, string sElement, int iPosition);

// Update an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to update in the array
// - iPosition Position of the element to update (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArraySetElement(struct jx_array_fixed array, string sElement, int iPosition);

// Remove an element by position from an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition Position of the element to remove (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayRemoveElement(struct jx_array_fixed array, int iPosition);

// Invert the positions of two elements in an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition1 Position of the first element to invert (starts at 1)
// - iPosition2 Position of the second element to invert (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayInvertElement(struct jx_array_fixed array, int iPosition1, int iPosition2);

// Get an element by position in an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition Position of the element to get
// * Returns the element found
string JXFixedArrayGetElement(struct jx_array_fixed array, int iPosition);

// Find the position of an element in a fixed-size array
// - array Array of fixed-size elements
// - sElement Element to search
// - bStarting Indicate if sElement is only the first part of the element to search
// * Returns the position of the element in the array (-1 if not found)
int JXFixedArrayFindElement(struct jx_array_fixed array, string sElement, int bStarting = FALSE);

// Add an array to another array of fixed-size elements
// - array Array of fixed-size elements
// - arrayToAdd Array of fixed-size elements to add
// * Returns the updated array
struct jx_array_fixed JXFixedArrayAddArray(struct jx_array_fixed array, struct jx_array_fixed arrayToAdd);

// Remove an array from another array of fixed-size elements
// - array Array of fixed-size elements
// - arrayToRemove Array of fixed-size elements to remove
// * Returns the updated array
struct jx_array_fixed JXFixedArrayRemoveArray(struct jx_array_fixed array, struct jx_array_fixed arrayToRemove);

// Sort the elements in an array of fixed-size elements.
// The algorithm used here is the "quicksort" algorithm developed by Hoare in 1960.
// - array Array of fixed-size elements
// - iSortType JX_SORTTYPE_* constant (alphabetic or numeric)
// * Returns the sorted array
struct jx_array_fixed JXFixedArraySortElements(struct jx_array_fixed array, int iSortType = JX_SORTTYPE_ALPHABETIC);

// Convert an array of fixed-size elements into a string
// - array Array of fixed-size elements
// * Returns the array under the form of a string
string JXFixedArrayToString(struct jx_array_fixed array);

// Convert a string into an array of fixed-size elements
// - sArray Array under the form of a string
// * Returns an array of fixed-size elements
struct jx_array_fixed JXFixedArrayToStruct(string sArray);












// Private function - Pad a string with spaces
string JXPrivateFixedArrayPad(string sString, int iPadLen)
{
	string sPad;
	int tmpPadLen = iPadLen;
	while (tmpPadLen > 0)
	{
		if (tmpPadLen >= 1000)
			tmpPadLen = 1000;
		if (tmpPadLen >= 100)
			tmpPadLen = 100;
		else if (tmpPadLen >= 50)
			tmpPadLen = 50;
		else if (tmpPadLen >= 10)
			tmpPadLen = 10;
		else if (tmpPadLen >= 5)
			tmpPadLen = 5;

		switch (tmpPadLen)
		{
			case 1: sPad = " "; break;
			case 2: sPad = "  "; break;
			case 3: sPad = "   "; break;
			case 4: sPad = "    "; break;
			case 5: sPad = "     "; break;
			case 10: sPad = "          "; break;
			case 50: sPad = "                                                  "; break;
			case 100 : sPad = "                                                                                                    "; break;
			case 1000 : sPad = "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ";
		}
		sString += sPad;
		iPadLen = iPadLen - tmpPadLen;
		tmpPadLen = iPadLen;
	}

	return sString;
}

// Create an empty array of fixed-size elements
// - iMaxElementSize Maximimum size of an element in the array (max 99998)
// * Returns an empty array
struct jx_array_fixed JXFixedArrayCreate(int iMaxElementSize)
{
	struct jx_array_fixed array;
	array.iMaxElementSize = iMaxElementSize + 1;

	return array;
}

// Get the number of elements in an array of fixed-size elements
// - array Array of fixed-size elements
// * Returns the number of elements
int JXFixedArrayCountElements(struct jx_array_fixed array)
{
	return array.iNbElements;
}

// Add an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// * Returns the updated array
struct jx_array_fixed JXFixedArrayAddElement(struct jx_array_fixed array, string sElement)
{
	// Make sure the element to add isn't too long
	sElement = GetStringLeft(sElement, array.iMaxElementSize);

	// Add the element in the array
	array.iNbElements++;
	array.sArray += JXPrivateFixedArrayPad(sElement + "^", array.iMaxElementSize - GetStringLength(sElement) - 1);

	return array;
}

// Insert an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// - iPosition Position of the element to insert (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayInsertElement(struct jx_array_fixed array, string sElement, int iPosition)
{
	// Make sure the element to add isn't too long
	sElement = GetStringLeft(sElement, array.iMaxElementSize);

	// Insert the element in the array
	array.iNbElements++;
	array.sArray = GetStringLeft(array.sArray, (iPosition - 1) * array.iMaxElementSize) +
					 JXPrivateFixedArrayPad(sElement + "^", array.iMaxElementSize - GetStringLength(sElement) - 1) +
					 GetSubString(array.sArray, (iPosition - 1) * array.iMaxElementSize, -1);

	return array;
}

// Update an element in an array of fixed-size elements
// - array Array of fixed-size elements
// - sElement Element to update in the array
// - iPosition Position of the element to update (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArraySetElement(struct jx_array_fixed array, string sElement, int iPosition)
{
	// Make sure the element to add isn't too long
	sElement = GetStringLeft(sElement, array.iMaxElementSize);

	// Update the element in the array
	array.sArray = GetStringLeft(array.sArray, (iPosition - 1) * array.iMaxElementSize) +
					 JXPrivateFixedArrayPad(sElement + "^", array.iMaxElementSize - GetStringLength(sElement) - 1) +
					 GetSubString(array.sArray, iPosition * array.iMaxElementSize, -1);

	return array;
}

// Remove an element by position from an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition Position of the element to remove (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayRemoveElement(struct jx_array_fixed array, int iPosition)
{
	// Remove the element from the array
	array.iNbElements--;
	array.sArray = GetStringLeft(array.sArray, (iPosition - 1) * array.iMaxElementSize) +
				   GetSubString(array.sArray, iPosition * array.iMaxElementSize, -1);

	return array;
}

// Invert the positions of two elements in an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition1 Position of the first element to invert (starts at 1)
// - iPosition2 Position of the second element to invert (starts at 1)
// * Returns the updated array
struct jx_array_fixed JXFixedArrayInvertElement(struct jx_array_fixed array, int iPosition1, int iPosition2)
{
	// Get the first element
	string sElement1 = GetSubString(array.sArray, (iPosition1 - 1) * array.iMaxElementSize, array.iMaxElementSize);
	// Get the second element
	string sElement2 = GetSubString(array.sArray, (iPosition2 - 1) * array.iMaxElementSize, array.iMaxElementSize);

	// Set the second element at position of the first
	array.sArray = GetStringLeft(array.sArray, (iPosition1 - 1) * array.iMaxElementSize) +
				   sElement2 + GetSubString(array.sArray, iPosition1 * array.iMaxElementSize, -1);
	// Set the first element at position of the second
	array.sArray = GetStringLeft(array.sArray, (iPosition2 - 1) * array.iMaxElementSize) +
				   sElement1 + GetSubString(array.sArray, iPosition2 * array.iMaxElementSize, -1);

	return array;
}

// Get an element by position in an array of fixed-size elements
// - array Array of fixed-size elements
// - iPosition Position of the element to get
// * Returns the element found
string JXFixedArrayGetElement(struct jx_array_fixed array, int iPosition)
{
	// Find the element at the position
	string sElement = GetSubString(array.sArray, (iPosition - 1) * array.iMaxElementSize, array.iMaxElementSize);
	int iEndPos = FindSubString(sElement, "^");

	return GetStringLeft(sElement, iEndPos);
}

// Find the position of an element in a fixed-size array
// - array Array of fixed-size elements
// - sElement Element to search
// - bStarting Indicate if sElement is only the first part of the element to search
// * Returns the position of the element in the array (0 if not found)
int JXFixedArrayFindElement(struct jx_array_fixed array, string sElement, int bStarting)
{
	// Find the position of the first character of the element
	int iStartPos = FindSubString(array.sArray, sElement + ((bStarting == TRUE) ? "" : "^"));
	if (iStartPos == -1)
		return 0;

	// Make sure the position of the first character is also an element's position
	int iPosDiff = iStartPos % array.iMaxElementSize;
	while ((iPosDiff != 0) && (iStartPos != -1))
	{
		sElement = GetSubString(sElement, iStartPos + 1, -1);
		iStartPos = FindSubString(sElement, sElement + ((bStarting == TRUE) ? "" : "^"));
		if (iStartPos == -1)
			return 0;
		iPosDiff = iStartPos % array.iMaxElementSize;
	}

	return iStartPos / array.iMaxElementSize + 1;
}

// Add an array to another array of fixed-size elements
// - array Array of fixed-size elements
// - arrayToAdd Array of fixed-size elements to add
// * Returns the updated array
struct jx_array_fixed JXFixedArrayAddArray(struct jx_array_fixed array, struct jx_array_fixed arrayToAdd)
{
	// Add the element in the array
	array.iNbElements += arrayToAdd.iNbElements;
	array.sArray += arrayToAdd.sArray;

	return array;
}

// Remove an array from another array of fixed-size elements
// - array Array of fixed-size elements
// - arrayToRemove Array of fixed-size elements to remove
// * Returns the updated array
struct jx_array_fixed JXFixedArrayRemoveArray(struct jx_array_fixed array, struct jx_array_fixed arrayToRemove)
{
	string sElementWithPad;
	int iPosElement, iPosCharacter;
	int iLoopElement;
	for (iLoopElement = 1; iLoopElement <= arrayToRemove.iNbElements; iLoopElement++)
	{
		// Get an element to remove
		sElementWithPad = GetSubString(arrayToRemove.sArray, (iLoopElement - 1) * arrayToRemove.iMaxElementSize, arrayToRemove.iMaxElementSize);
		// Find the position of this element in the array to update
		iPosCharacter = FindSubString(array.sArray, sElementWithPad);
		if (iPosElement != -1)
		{
			iPosElement = iPosCharacter / array.iMaxElementSize + 1;
			// Remove the element
			array.iNbElements--;
			array.sArray = GetStringLeft(array.sArray, (iPosElement - 1) * array.iMaxElementSize) +
						   GetSubString(array.sArray, iPosElement * array.iMaxElementSize, -1);
		}
	}

	return array;
}

// Private array used to by the sorting process
struct jx_array_fixed gsArray;

// Private function - used by JXPrivateFixedArraySortElements()
int JXPrivateFixedArraySortElementsPartition(int iStart, int iEnd, int iSortType)
{
	string sTemp = JXFixedArrayGetElement(gsArray, iEnd);
	int iTemp;
	if (iSortType == JX_SORTTYPE_NUMERIC)
		iTemp = StringToInt(sTemp);

	while (iEnd > iStart)
	{
		if (iSortType == JX_SORTTYPE_ALPHABETIC)
		{
			while ((iEnd > iStart)
				&& (StringCompare(JXFixedArrayGetElement(gsArray, iStart), sTemp) <= 0))
				iStart++;
		}
		else
		{
			while ((iEnd > iStart)
				&& (StringToInt(JXFixedArrayGetElement(gsArray, iStart)) <= iTemp))
				iStart++;
		}
		if (iEnd > iStart)
		{
			gsArray = JXFixedArrayInvertElement(gsArray, iStart, iEnd);
			iEnd--;
			if (iSortType == JX_SORTTYPE_ALPHABETIC)
			{
				while ((iEnd > iStart)
					&& (StringCompare(JXFixedArrayGetElement(gsArray, iEnd), sTemp) >= 0))
					iEnd--;
			}
			else
			{
				while ((iEnd > iStart)
					&& (StringToInt(JXFixedArrayGetElement(gsArray, iEnd)) >= iTemp))
					iEnd--;
			}
			if (iEnd > iStart)
			{
				gsArray = JXFixedArrayInvertElement(gsArray, iEnd, iStart);
				iStart--;
			}
		}
	}
	gsArray = JXFixedArraySetElement(gsArray, sTemp, iEnd);

	return iEnd;
}

// Private function - used by JXFixedArraySortElements()
struct jx_array_fixed JXPrivateFixedArraySortElements(int iStart, int iEnd, int iSortType)
{
	int iMiddle;

	if (iStart < iEnd)
	{
		iMiddle = JXPrivateFixedArraySortElementsPartition(iStart, iEnd, iSortType);

		if ((iMiddle - iStart) > (iEnd - iMiddle))
		{
			JXPrivateFixedArraySortElements(iMiddle + 1, iEnd, iSortType);
			JXPrivateFixedArraySortElements(iStart, iMiddle - 1, iSortType);
		}
		else
		{
			JXPrivateFixedArraySortElements(iStart, iMiddle - 1, iSortType);
			JXPrivateFixedArraySortElements(iMiddle + 1, iEnd, iSortType);
		}
	}
	return gsArray;
}

// Sort the elements in an array of fixed-size elements
// - array Array of fixed-size elements
// - iSortType JX_SORTTYPE_* constant (alphabetic or numeric)
// * Returns the sorted array
struct jx_array_fixed JXFixedArraySortElements(struct jx_array_fixed array, int iSortType = JX_SORTTYPE_ALPHABETIC)
{
	gsArray = array;
	return JXPrivateFixedArraySortElements(1, array.iNbElements, iSortType);
}

// Convert an array of fixed-size elements into a string
// - array Array of fixed-size elements
// * Returns the array under the form of a string
string JXFixedArrayToString(struct jx_array_fixed array)
{
	string sNbElements = IntToString(array.iNbElements);
	string sMaxElementSize = IntToString(array.iMaxElementSize);
	string sResult = JXPrivateFixedArrayPad(sNbElements, 5 - GetStringLength(sNbElements));
	sResult += JXPrivateFixedArrayPad(sMaxElementSize, 5 - GetStringLength(sMaxElementSize));
	sResult += array.sArray;

	return sResult;
}

// Convert a string into an array of fixed-size elements
// - sArray Array under the form of a string
// * Returns an array of fixed-size elements
struct jx_array_fixed JXFixedArrayToStruct(string sArray)
{
	struct jx_array_fixed array;
	array.iNbElements = StringToInt(GetStringLeft(sArray, 5));
	array.iMaxElementSize = StringToInt(GetSubString(sArray, 5, 5));
	array.sArray = GetSubString(sArray, 10, -1);

	return array;
}