// "sdl_array"
#include "inc_persist_loca"

/////////////////////////////////////
// Functions
/////////////////////////////////////

int persistant_array_create(object store, string name);
int persistant_array_delete(object store, string name);

int persistant_array_set_string(object store, string name, int i, string entry);
int persistant_array_set_int(object store, string name, int i, int entry);
int persistant_array_set_float(object store, string name, int i, float entry);
int persistant_array_set_object(object store, string name, int i, object entry);

// returns "" or 0 on error
string persistant_array_get_string(object store, string name, int i);
int persistant_array_get_int(object store, string name, int i);
float persistant_array_get_float(object store, string name, int i);
object persistant_array_get_object(object store, string name, int i);

// changes memory usage of array (deletes x[ > size_new])
int persistant_array_shrink(object store, string name, int size_new);

// gets current maximum size of array
int persistant_array_get_size(object store, string name);

int persistant_array_exists(object store, string name);

/////////////////////////////////////
// Notes:
//
// * Arrays are dynamic and may be increased in size by just _set_'ing a new
//   element
// * There are no restrictions on what is in the array (can have multiple
//   types in the same array
// * Arrays start at index 0
/////////////////////////////////////


/////////////////////////////////////
// Error Returns
/////////////////////////////////////
/*
int SDL_SUCCESS = 1;
int SDL_ERROR_ALREADY_EXISTS = 1001;
int SDL_ERROR_DOES_NOT_EXIST = 1002;
int SDL_ERROR_OUT_OF_BOUNDS = 1003;
int SDL_ERROR_NO_ZERO_SIZE = 1004;
int SDL_ERROR_NOT_VALID_OBJECT = 1005;
*/
/////////////////////////////////////
// Implementation
/////////////////////////////////////

int persistant_array_create(object store, string name)
{
    // error checking
    if (GetPersistantLocalInt(store,name))
        return SDL_ERROR_ALREADY_EXISTS;
    else
    {
        // Initialize the size (always one greater than the actual size)
        SetPersistantLocalInt(store,name,1);
        return SDL_SUCCESS;
    }
}

int persistant_array_delete(object store, string name)
{
    // error checking
    int size=GetPersistantLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    int i;
    for (i=0; i<size+5; i++)
    {
        DeletePersistantLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeletePersistantLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    DeletePersistantLocalInt(store,name);

    return SDL_SUCCESS;
}

int persistant_array_set_string(object store, string name, int i, string entry)
{
    int size=GetPersistantLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    SetPersistantLocalString(store,name+"_"+IntToString(i),entry);

    // save size if we've enlarged it
    if (i+2>size)
        SetPersistantLocalInt(store,name,i+2);

    return SDL_SUCCESS;
}

int persistant_array_set_int(object store, string name, int i, int entry)
{
    return persistant_array_set_string(store,name,i,IntToString(entry));
}

int persistant_array_set_float(object store, string name, int i, float entry)
{
    return persistant_array_set_string(store,name,i,FloatToString(entry));
}

int persistant_array_set_object(object store, string name, int i, object entry)
{
    // object is a little more complicated.
    // we want to create an object as a local variable too
    if (!GetIsObjectValid(entry))
        return SDL_ERROR_NOT_VALID_OBJECT;

    int results=array_set_string(store,name,i,"OBJECT");
    if (results==SDL_SUCCESS)
        SetPersistantLocalObject(store,name+"_"+IntToString(i)+"_OBJECT",entry);

    return results;
}

string persistant_array_get_string(object store, string name, int i)
{
    // error checking
    int size=GetPersistantLocalInt(store,name);
    if (size==0 || i>size)
        return "";

    return GetPersistantLocalString(store,name+"_"+IntToString(i));
}

int persistant_array_get_int(object store, string name, int i)
{
    return StringToInt(persistant_array_get_string(store,name,i));
}

float persistant_array_get_float(object store, string name, int i)
{
    return StringToFloat(persistant_array_get_string(store,name,i));
}

object persistant_array_get_object(object store, string name, int i)
{
    return GetPersistantLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
}

int persistant_array_shrink(object store, string name, int size_new)
{
    // error checking
    int size=GetPersistantLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;
    if (size==size_new || size<size_new)
        return SDL_SUCCESS;

    int i;
    for (i=size_new; i<size; i++)
    {
        DeletePersistantLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeletePersistantLocalString(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    SetPersistantLocalInt(store,name,size_new+1);

    return SDL_SUCCESS;
}

int persistant_array_get_size(object store, string name)
{
    return GetPersistantLocalInt(store,name)-1;
}

int persistant_array_exists(object store, string name)
{
    if (GetPersistantLocalInt(store,name)==0)
        return FALSE;
    else
        return TRUE;
}

////////////////////////////////////////////////////////////////////////////////
// (c) Mr. Figglesworth 2002
// This code is licensed under beerware.  You are allowed to freely use it
// and modify it in any way.  Your only two obligations are: (1) at your option,
// to buy the author a beer if you ever meet him; and (2) include the
// copyright notice and license in any redistribution of this code or
// alterations of it.
//
// Full credit for how the array gets implemented goes to the guy who wrote
// the article and posted it on the NWNVault (I couldn't find your article
// to give you credit :( ).  And, of course, to bioware.  Great job!
////////////////////////////////////////////////////////////////////////////////
