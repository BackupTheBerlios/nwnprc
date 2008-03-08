//::///////////////////////////////////////////////
//:: JX Array of delimited elements Include
//:: jx_inc_array_delim
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 8, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// arrays of delimited elements.
// The advantage of this type of array is that it
// can contain elements of very different sizes
// without loss of memory space.
// The drawback is that it requires a lot of
// instructions to perform some specific operations.
//
// This array is best used for arrays that contain
// few elements (and is limited to 99).
//
// The operations available are :
// - Create an array
// - Get the number of elements
// - Add an element
// - Insert an element (many instructions)
// - Modify an element (many instructions)
// - Remove an element (many instructions)
// - Get an element by position (many instructions)
// - Contains an element ?
//
//:://////////////////////////////////////////////


// Structure that represents an array of delimited elements.
// It can be converted into a string with JXDelimArrayToString()
// then back into a structure with JXDelimArrayToStruct()
struct jx_array_delim
{
	int iNbElements;
	string sDelimiter;
	string sArray;
};

// Create an empty array of delimited elements
// - sDelimiter Delimiter
// * Returns an empty array
struct jx_array_delim JXDelimArrayCreate(string sDelimiter);

// Get the number of elements in an array of delimited elements
// - sArray Array of delimited elements
// * Returns the number of elements
int JXDelimArrayCountElements(struct jx_array_delim array);

// Add an element in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to add in the array
// * Returns the updated array
struct jx_array_delim JXDelimArrayAddElement(struct jx_array_delim array, string sElement);

// Insert an element in an array of delimited elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// - iPosition Position of the element to insert (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArrayInsertElement(struct jx_array_delim array, string sElement, int iPosition);

// Update an element in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to update in the array
// - iPosition Position of the element to update (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArraySetElement(struct jx_array_delim array, string sElement, int iPosition);

// Remove an element by position from an array of delimited elements
// - array Array of delimited elements
// - iPosition Position of the element to remove (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArrayRemoveElement(struct jx_array_delim array, int iPosition);

// Get an element by position in an array of delimited elements
// - array Array of delimited elements
// - iPosition Position of the element to get
// * Returns the element found
string JXDelimArrayGetElement(struct jx_array_delim array, int iPosition);

// Determine if an element exist in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to search
// * Returns TRUE if the element is found
int JXDelimArrayContainElement(struct jx_array_delim array, string sElement);

// Convert an array of delimited elements into a string
// - array Array of delimited elements
// * Returns the array under the form of a string
string JXDelimArrayToString(struct jx_array_delim array);

// Convert a string into an array of delimited elements
// - sArray Array under the form of a string
// * Returns an array of delimited elements
struct jx_array_delim JXDelimArrayToStruct(string sArray);












// Create an empty array of delimited elements
// - sDelimiter Delimiter
// * Returns an empty array
struct jx_array_delim JXDelimArrayCreate(string sDelimiter)
{
	struct jx_array_delim array;
	array.sDelimiter = GetStringLeft(sDelimiter, 1);

	return array;
}

// Get the number of elements in an array of delimited elements
// - sArray Array of delimited elements
// * Returns the number of elements
int JXDelimArrayCountElements(struct jx_array_delim array)
{
	return array.iNbElements;
}

// Add an element in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to add in the array
// * Returns the updated array
struct jx_array_delim JXDelimArrayAddElement(struct jx_array_delim array, string sElement)
{
	array.iNbElements++;
	array.sArray += sElement + array.sDelimiter;

	return array;
}

// Insert an element in an array of delimited elements
// - array Array of fixed-size elements
// - sElement Element to add in the array
// - iPosition Position of the element to insert (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArrayInsertElement(struct jx_array_delim array, string sElement, int iPosition)
{
	// Find the position of the element to insert
	string sArrayLeft;
	int iElementPos = 1;
	int iCharacterPos = 0;
	while (iElementPos < iPosition)
	{
		sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
		iCharacterPos += FindSubString(sArrayLeft, array.sDelimiter) + 1;
		iElementPos++;
	}

	// Insert the element in the array
	array.iNbElements++;
	array.sArray = GetStringLeft(array.sArray, iCharacterPos) +
				   sElement + array.sDelimiter +
				   GetSubString(array.sArray, iCharacterPos, -1);

	return array;
}

// Update an element in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to update in the array
// - iPosition Position of the element to update (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArraySetElement(struct jx_array_delim array, string sElement, int iPosition)
{
	// Find the start position of the element to update
	string sArrayLeft;
	int iElementPos = 1;
	int iCharacterPos = 0;
	while (iElementPos < iPosition)
	{
		sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
		iCharacterPos += FindSubString(sArrayLeft, array.sDelimiter) + 1;
		iElementPos++;
	}
	// Find the end position of the element to update
	sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
	int iCharacterPos2 = iCharacterPos + FindSubString(sArrayLeft, array.sDelimiter) + 1;

	// Update the element in the array
	array.sArray = GetStringLeft(array.sArray, iCharacterPos) +
				   sElement + array.sDelimiter +
				   GetSubString(array.sArray, iCharacterPos2, -1);

	return array;
}

// Remove an element by position from an array of delimited elements
// - array Array of delimited elements
// - iPosition Position of the element to remove (starts at 1)
// * Returns the updated array
struct jx_array_delim JXDelimArrayRemoveElement(struct jx_array_delim array, int iPosition)
{
	// Find the start position of the element to remove
	string sArrayLeft;
	int iElementPos = 1;
	int iCharacterPos = 0;
	while (iElementPos < iPosition)
	{
		sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
		iCharacterPos += FindSubString(sArrayLeft, array.sDelimiter) + 1;
		iElementPos++;
	}
	// Find the end position of the element to remove
	sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
	int iCharacterPos2 = iCharacterPos + FindSubString(sArrayLeft, array.sDelimiter) + 1;

	// Remove the element from the array
	array.iNbElements--;
	array.sArray = GetStringLeft(array.sArray, iCharacterPos) +
				   GetSubString(array.sArray, iCharacterPos2, -1);

	return array;
}

// Get an element by position in an array of delimited elements
// - array Array of delimited elements
// - iPosition Position of the element to get
// * Returns the element found
string JXDelimArrayGetElement(struct jx_array_delim array, int iPosition)
{
	// Find the start position of the element to get
	string sArrayLeft;
	int iElementPos = 1;
	int iCharacterPos = 0;
	while (iElementPos < iPosition)
	{
		sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
		iCharacterPos += FindSubString(sArrayLeft, array.sDelimiter) + 1;
		iElementPos++;
	}
	// Find the end position of the element to get
	sArrayLeft = GetSubString(array.sArray, iCharacterPos, -1);
	int iCharacterPos2 = iCharacterPos + FindSubString(sArrayLeft, array.sDelimiter);

	return GetSubString(array.sArray, iCharacterPos, iCharacterPos2 - iCharacterPos);
}

// Determine if an element exist in an array of delimited elements
// - array Array of delimited elements
// - sElement Element to search
// * Returns TRUE if the element is found
int JXDelimArrayContainElement(struct jx_array_delim array, string sElement)
{
	int iFound = FindSubString(array.sArray, sElement + array.sDelimiter);
	if (iFound == -1)
		return FALSE;
	else
		return TRUE;
}


// Convert an array of delimited elements into a string
// - array Array of delimited elements
// * Returns the array under the form of a string
string JXDelimArrayToString(struct jx_array_delim array)
{
	string sNbElements = IntToString(array.iNbElements);
	if (GetStringLength(sNbElements) == 1)
		sNbElements += " ";

	string sResult = sNbElements;
	sResult += array.sDelimiter;
	sResult += array.sArray;

	return sResult;
}

// Convert a string into an array of delimited elements
// - sArray Array under the form of a string
// * Returns an array of delimited elements
struct jx_array_delim JXDelimArrayToStruct(string sArray)
{
	struct jx_array_delim array;

	array.iNbElements = StringToInt(GetStringLeft(sArray, 2));
	array.sDelimiter = GetSubString(sArray, 2, 1);
	array.sArray = GetSubString(sArray, 3, -1);

	return array;
}