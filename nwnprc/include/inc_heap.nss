//::///////////////////////////////////////////////
//:: Heap include
//:: inc_heap
//:://////////////////////////////////////////////
/*
    A simple maxheap, backed by an array.
    Insertion priority is determined by an interger
    parameter, data stored may be anything.
    
    Heap element indices begin at one, for convenience.
    
    For optimization, I use binary search instead of
    switches. Result: It's fugly
    
    Return values are similar to the ones in
    Mr. Figglesworth's sdl_array
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 16.03.2005
//:://////////////////////////////////////////////

#include "inc_array"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////
/*
const int SDL_SUCCESS = 1;
const int SDL_ERROR_ALREADY_EXISTS = 1001;
const int SDL_ERROR_DOES_NOT_EXIST = 1002;
const int SDL_ERROR_OUT_OF_BOUNDS = 1003;
const int SDL_ERROR_NO_ZERO_SIZE = 1004;
const int SDL_ERROR_NOT_VALID_OBJECT = 1005;
*/
const int ENTITY_TYPE_FLOAT     = 1;
const int ENTITY_TYPE_INTEGER   = 2;
const int ENTITY_TYPE_OBJECT    = 3;
const int ENTITY_TYPE_STRING    = 4;

const string HEAP_PREFIX        = "heap_";
const string KEY_SUFFIX         = "_key";
const string ELEMENT_SUFFIX     = "_element";
const string TYPE_SUFFIX        = "_type";

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Create a new heap
// =================
// oStore   object that the heap will be stored as locals on
// sName    the name of the heap
//
// Initializes heap variables on the storage object and returns
// one of the SDL_* constants.
int heap_create(object oStore, string sName);

// Delete a heap
// =============
// oStore   object the heap is stored on
// sName    the name of the heap
//
// Deletes the heap and all it's entries. Returns one of the
// SDL_* constants.
int heap_delete(object oStore, string sName);

// Checks to see if a heap exists
// ==============================
// oStore   object the heap is stored on
// sName    the name of the heap
//
// Returns TRUE if a heap with the given name is stored on oStore.
// FALSE otherwise.
int heap_exists(object oStore, string sName);

// Gets the number of elements in the heap
// =======================================
// oStore   object the heap is stored on
// sName    the name of the heap
//
// Returns the number of elements in the heap, or -1 on error.
int heap_get_size(object oStore, string sName);


// Heap insertion functions - float
// ================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
// nKey     integer value used to determine insertion location
// *Entry   element to be insterted
//
// Inserts the given key & element pair at a location in the heap
// determined by the key. Returns one of the SDL_* constants.
//
// Return order of elements inserted with the same key is not defined.
int heap_put_float(object oStore, string sName, int nKey, float fEntry);

// Heap insertion functions - integer
// ==================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
// nKey     integer value used to determine insertion location
// *Entry   element to be insterted
//
// Inserts the given key & element pair at a location in the heap
// determined by the key. Returns one of the SDL_* constants.
//
// Return order of elements inserted with the same key is not defined.
int heap_put_int(object oStore, string sName, int nKey, int nEntry);

// Heap insertion functions - object
// =================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
// nKey     integer value used to determine insertion location
// *Entry   element to be insterted
//
// Inserts the given key & element pair at a location in the heap
// determined by the key. Returns one of the SDL_* constants.
//
// Return order of elements inserted with the same key is not defined.
int heap_put_object(object oStore, string sName, int nKey, object oEntry);

// Heap insertion functions - string
// =================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
// nKey     integer value used to determine insertion location
// *Entry   element to be insterted
//
// Inserts the given key & element pair at a location in the heap
// determined by the key. Returns one of the SDL_* constants.
//
// Return order of elements inserted with the same key is not defined.
int heap_put_string(object oStore, string sName, int nKey, string sEntry);


// Checks the type of the element at the top of the heap
// =====================================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Returns one of the ENTITY_TYPE_* constants, or 0 on error
// (heap does not exist or is empy)
int heap_get_type(object oStore, string sName);

// Gets the top element of the heap as float
// =========================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Returns the top element as an entity of a certain type.
// If the type the function returns and the type stored
// do not match, null value is returned.
// (0.0f, 0, OBJECT_INVALID, "")
float heap_get_float(object oStore, string sName);

// Gets the top element of the heap as integer
// ===========================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Returns the top element as an entity of a certain type.
// If the type the function returns and the type stored
// do not match, null value is returned.
// (0.0f, 0, OBJECT_INVALID, "")
int heap_get_int(object oStore, string sName);

// Gets the top element of the heap as object
// ==========================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Returns the top element as an entity of a certain type.
// If the type the function returns and the type stored
// do not match, null value is returned.
// (0.0f, 0, OBJECT_INVALID, "")
object heap_get_object(object oStore, string sName);

// Gets the top element of the heap as string
// ==========================================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Returns the top element as an entity of a certain type.
// If the type the function returns and the type stored
// do not match, null value is returned.
// (0.0f, 0, OBJECT_INVALID, "")
string heap_get_string(object oStore, string sName);


// Removes the top element of the heap
// ===============================
// oStore   object the heap to be used is stored on
// sName    the name of the heap
//
// Deletes the top element of the heap and reorders the heap to
// preserve the heap conditions.
// Returns one of the SDL_* constants.
int heap_remove(object oStore, string sName);


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////



int heap_create(object oStore, string sName){
    // Validity checks
    if(!GetIsObjectValid(oStore))
        return SDL_ERROR_NOT_VALID_OBJECT;
    if(GetLocalInt(oStore, sName))
        return SDL_ERROR_ALREADY_EXISTS;
    
    // Initialize the size (always one greater than the actual size)
    SetLocalInt(oStore, HEAP_PREFIX + sName, 1);
    return SDL_SUCCESS;
}


int heap_delete(object oStore, string sName){
     // Validity checks
    int nSize = GetLocalInt(oStore, HEAP_PREFIX + sName);
    if(!nSize)
        return SDL_ERROR_DOES_NOT_EXIST;
    
    nSize -= 1;
    int nTempType;
    for(; nSize >= 0; nSize--){
        // Delete the storage values
        nTempType = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + TYPE_SUFFIX);
        DeleteLocalInt   (oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + TYPE_SUFFIX);
        DeleteLocalInt   (oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + KEY_SUFFIX);
        
        if(nTempType > ENTITY_TYPE_INTEGER){
            if(nTempType > ENTITY_TYPE_OBJECT)
                DeleteLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
            else
                DeleteLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
        }else{
            if(nTempType > ENTITY_TYPE_FLOAT)
                DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
            else
                DeleteLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
        }
    }
    
    // Delete the size variable
    DeleteLocalInt(oStore, HEAP_PREFIX + sName);
    return SDL_SUCCESS;
}


int heap_exists(object oStore, string sName){
    if(GetLocalInt(oStore, HEAP_PREFIX + sName))
        return TRUE;
    else
        return FALSE;
}


int heap_get_size(object oStore, string sName){
    return GetLocalInt(oStore, HEAP_PREFIX + sName) - 1;
}


/* Some functions for simulating the element links */
int heap_parent(int nIndex){ return (nIndex - 1) / 2; }
int heap_lchild(int nIndex){ return (nIndex * 2) + 1; }
int heap_rchild(int nIndex){ return (nIndex * 2) + 2; }
/* An element swapper */
void heap_swap(object oStore, string sName, int nInd1, int nInd2){
    int nTempKey  = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + KEY_SUFFIX);
    int nTempType = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + TYPE_SUFFIX);
    float  fTemp;
    int    nTemp;
    object oTemp;
    string sTemp;
    
    // Grab the element from index1
    if(nTempType > ENTITY_TYPE_INTEGER){
        if(nTempType > ENTITY_TYPE_OBJECT){
            sTemp = GetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
            DeleteLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
        }else{
            oTemp = GetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
            DeleteLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
    }}else{
        if(nTempType > ENTITY_TYPE_FLOAT){
            nTemp = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
            DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
        }else{
            fTemp = GetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
            DeleteLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX);
    }}
    
    // Start moving from index2
    int nTempType2 = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + TYPE_SUFFIX);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + TYPE_SUFFIX,
                nTempType2);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + KEY_SUFFIX,
                GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + KEY_SUFFIX));
    // Illegal use of enumerations. Don't do this at home :p
    if(nTempType2 > ENTITY_TYPE_INTEGER){
        if(nTempType2 > ENTITY_TYPE_OBJECT){
            SetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX,
                           GetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX));
            DeleteLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX);
        }else{
            SetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX,
                           GetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX));
            DeleteLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX);
    }}else{
        if(nTempType2 > ENTITY_TYPE_FLOAT){
            SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX,
                        GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX));
            DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX);
        }else{
            SetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd1) + ELEMENT_SUFFIX,
                          GetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX));
            DeleteLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX);
    }}
    
    // Place the stuff copied to temporary variables to their new place
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + TYPE_SUFFIX,
                nTempType);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + KEY_SUFFIX,
                nTempKey);
    if(nTempType > ENTITY_TYPE_INTEGER){
        if(nTempType > ENTITY_TYPE_OBJECT)
            SetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX,
                           sTemp);
        else
            SetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX,
                           oTemp);
    }else{
        if(nTempType > ENTITY_TYPE_FLOAT)
            SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX,
                        nTemp);
        else
            SetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInd2) + ELEMENT_SUFFIX,
                          fTemp);
    }
}

/* A function that gets the location where the given
 * key should be inserted. Moves other elements around
 * to clear the location
 */
int heap_get_insert_location(object oStore, string sName, int nKey){
    // Insert into position just beyond the end of current elements
    int nIndex = heap_get_size(oStore, sName);
    int nTempType;
    while(nIndex > 0 && GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + KEY_SUFFIX) < nKey){
        // Move the parent entry down
        nTempType = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + TYPE_SUFFIX);
        SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + TYPE_SUFFIX,
                    nTempType);
        SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + KEY_SUFFIX,
                    GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + KEY_SUFFIX));
        // Illegal use of enumerations. Don't do this at home :p
        // The old entry is deleted, since the entry to be inserted might not be of the same type
        if(nTempType > ENTITY_TYPE_INTEGER){
            if(nTempType > ENTITY_TYPE_OBJECT){
                SetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + ELEMENT_SUFFIX,
                               GetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX));
                DeleteLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX);
            }else{
                SetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + ELEMENT_SUFFIX,
                               GetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX));
                 DeleteLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX);
        }}else{
            if(nTempType > ENTITY_TYPE_FLOAT){
                SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + ELEMENT_SUFFIX,
                            GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX));
                DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX);
            }else{
                SetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + ELEMENT_SUFFIX,
                              GetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX));
                DeleteLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(heap_parent(nIndex)) + ELEMENT_SUFFIX);
        }}

        nIndex = heap_parent(nIndex);
    }
    
    return nIndex;
}
/*if(a > 2){
    if(a > 3)
        b = ENTITY_TYPE_STRING;
    else
        b = ENTITY_TYPE_OBJECT;
}else{
    if(a > 1)
        b = ENTITY_TYPE_INTEGER;
    else
        b = ENTITY_TYPE_FLOAT;
}*/

int heap_put_float(object oStore, string sName, int nKey, float fEntry){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;

    // Get the location to insert to
    int nInsert = heap_get_insert_location(oStore, sName, nKey);
    
    // Insert the new element
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + TYPE_SUFFIX, ENTITY_TYPE_FLOAT);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + KEY_SUFFIX, nKey);
    SetLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + ELEMENT_SUFFIX, fEntry);
    
    // Mark the insertion
    SetLocalInt(oStore, HEAP_PREFIX + sName, GetLocalInt(oStore, HEAP_PREFIX + sName) + 1);
    return SDL_SUCCESS;
}

int heap_put_int(object oStore, string sName, int nKey, int nEntry){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;

    // Get the location to insert to
    int nInsert = heap_get_insert_location(oStore, sName, nKey);
    
    // Insert the new element
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + KEY_SUFFIX, nKey);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + TYPE_SUFFIX, ENTITY_TYPE_INTEGER);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + ELEMENT_SUFFIX, nEntry);
    
    // Mark the insertion
    SetLocalInt(oStore, HEAP_PREFIX + sName, GetLocalInt(oStore, HEAP_PREFIX + sName) + 1);
    return SDL_SUCCESS;
}

int heap_put_string(object oStore, string sName, int nKey, string sEntry){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;

    // Get the location to insert to
    int nInsert = heap_get_insert_location(oStore, sName, nKey);
    
    // Insert the new element
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + KEY_SUFFIX, nKey);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + TYPE_SUFFIX, ENTITY_TYPE_STRING);
    SetLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + ELEMENT_SUFFIX, sEntry);
    
    // Mark the insertion
    SetLocalInt(oStore, HEAP_PREFIX + sName, GetLocalInt(oStore, HEAP_PREFIX + sName) + 1);
    return SDL_SUCCESS;
}

int heap_put_object(object oStore, string sName, int nKey, object oEntry){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;
    
    // Get the location to insert to
    int nInsert = heap_get_insert_location(oStore, sName, nKey);
    
    // Insert the new element
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + KEY_SUFFIX, nKey);
    SetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + TYPE_SUFFIX, ENTITY_TYPE_OBJECT);
    SetLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nInsert) + ELEMENT_SUFFIX, oEntry);
    
    // Mark the insertion
    SetLocalInt(oStore, HEAP_PREFIX + sName, GetLocalInt(oStore, HEAP_PREFIX + sName) + 1);
    return SDL_SUCCESS;
}


int heap_remove(object oStore, string sName){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;
    
    int nSize = heap_get_size(oStore, sName);
    if(!nSize)
        return SDL_ERROR_OUT_OF_BOUNDS;
    
    // Move the bottommost element over the max
    nSize--;
    heap_swap(oStore, sName, 0, nSize);
    // Delete the bottommost element
    int nTempType = GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + TYPE_SUFFIX);
    DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + TYPE_SUFFIX);
    DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + KEY_SUFFIX);
    
    if(nTempType > ENTITY_TYPE_INTEGER){
        if(nTempType > ENTITY_TYPE_OBJECT)
            DeleteLocalString(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
        else
            DeleteLocalObject(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
    }else{
        if(nTempType > ENTITY_TYPE_FLOAT)
            DeleteLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
        else
            DeleteLocalFloat(oStore, HEAP_PREFIX + sName + "_" + IntToString(nSize) + ELEMENT_SUFFIX);
    }
    // Mark the heapsize as reduced
    SetLocalInt(oStore, HEAP_PREFIX + sName, nSize + 1);
    // Move nSize to point at the new last entry
    nSize--;
    // Re-assert the heap conditions
    int nLeft, nRight, nMax, nIndex = 0;
    int bContinue = TRUE;
    while(bContinue){
        bContinue = FALSE;
        nLeft  = heap_lchild(nIndex);
        nRight = heap_rchild(nIndex);
        
        if(nRight <= nSize){
            if(GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nLeft) + KEY_SUFFIX)
                >
               GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nLeft) + KEY_SUFFIX))
                nMax = nLeft;
            else
                nMax = nRight;
            
            if(GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + KEY_SUFFIX)
                <
               GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nMax) + KEY_SUFFIX)){
                heap_swap(oStore, sName, nIndex, nMax);
                bContinue = TRUE;
            }
        }
        else if(nLeft == nSize && 
                GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nIndex) + KEY_SUFFIX)
                 <
                GetLocalInt(oStore, HEAP_PREFIX + sName + "_" + IntToString(nLeft) + KEY_SUFFIX))
            heap_swap(oStore, sName, nIndex, nLeft);
    }
    
    return SDL_SUCCESS;
}


int heap_get_type(object oStore, string sName){
    // Validity checks
    if(!GetLocalInt(oStore, HEAP_PREFIX + sName))
        return SDL_ERROR_DOES_NOT_EXIST;
    
    // Return the heap top element's type
    return GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + TYPE_SUFFIX);
}


float heap_get_float(object oStore, string sName){
    return GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + TYPE_SUFFIX) == ENTITY_TYPE_FLOAT ?
             GetLocalFloat(oStore, HEAP_PREFIX + sName + "_0" + ELEMENT_SUFFIX) :
             0.0f;
}

int heap_get_int(object oStore, string sName){
    return GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + TYPE_SUFFIX) == ENTITY_TYPE_INTEGER ?
             GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + ELEMENT_SUFFIX) :
             0;
}

object heap_get_object(object oStore, string sName){
    return GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + TYPE_SUFFIX) == ENTITY_TYPE_OBJECT ?
             GetLocalObject(oStore, HEAP_PREFIX + sName + "_0" + ELEMENT_SUFFIX) :
             OBJECT_INVALID;
}

string heap_get_string(object oStore, string sName){
    return GetLocalInt(oStore, HEAP_PREFIX + sName + "_0" + TYPE_SUFFIX) == ENTITY_TYPE_STRING ?
             GetLocalString(oStore, HEAP_PREFIX + sName + "_0" + ELEMENT_SUFFIX) :
             "";
}


//void main(){}