#include "inc_array"

int array_2d_create(object store, string name);
int array_2d_delete(object store, string name);

int array_2d_set_string(object store, string name, int i, int j, string entry);
int array_2d_set_int(object store,    string name, int i, int j, int entry);
int array_2d_set_float(object store,  string name, int i, int j, float entry);
int array_2d_set_object(object store, string name, int i, int j, object entry);

// returns "" or 0 on error
string array_2d_get_string(object store, string name, int i, int j);
int    array_2d_get_int(object store,    string name, int i, int j);
float  array_2d_get_float(object store,  string name, int i, int j);
object array_2d_get_object(object store, string name, int i, int j);

// changes memory usage of array (deletes x[ > size_new])
int array_2d_shrink(object store, string name, int size_new, int axis);

// gets current maximum size of array
int array_2d_get_size(object store, string name, int axis);

int array_2d_exists(object store, string name);


int array_2d_create(object store, string name)
{
    // error checking
    if (GetLocalInt(store,name))
        return SDL_ERROR_ALREADY_EXISTS;
    else
    {
        // Initialize the size (always one greater than the actual size)
        SetLocalInt(store,name+"_A",1);
        SetLocalInt(store,name+"_B",1);
        return SDL_SUCCESS;
    }
}


int array_2d_delete(object store, string name)
{
    // error checking
    int sizeA=GetLocalInt(store,name+"_A");
    if (sizeA==0)
        return SDL_ERROR_DOES_NOT_EXIST;
    int sizeB=GetLocalInt(store,name+"_B");
    if (sizeB==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    int i;
    int j;
    for (i=0; i<sizeA+5; i++)
    {
        for (j=0;j<sizeB+5; j++)
        {
            DeleteLocalString(store,name+"_"+IntToString(i)+"_"+IntToString(j));

            // just in case, delete possible object names
            DeleteLocalObject(store,name+"_"+IntToString(i)+"_"+IntToString(j)+"_OBJECT");
        }
    }

    DeleteLocalInt(store,name+"_A");
    DeleteLocalInt(store,name+"_B");

    return SDL_SUCCESS;
}

int array_2d_set_string(object store, string name, int i, int j, string entry)
{
    int sizeA=GetLocalInt(store,name+"_A");
    if (sizeA==0)
        return SDL_ERROR_DOES_NOT_EXIST;
    int sizeB=GetLocalInt(store,name+"_B");
    if (sizeB==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    SetLocalString(store,name+"_"+IntToString(i)+"_"+IntToString(j),entry);

    // save size if we've enlarged it
    if (i+2>sizeA)
        SetLocalInt(store,name+"_A",i+2);
    if (j+2>sizeB)
        SetLocalInt(store,name+"_B",j+2);

    return SDL_SUCCESS;
}


int array_2d_set_int(object store, string name, int i, int j, int entry)
{
    return array_2d_set_string(store,name,i,j,IntToString(entry));
}

int array_2d_set_float(object store, string name, int i, int j, float entry)
{
    return array_2d_set_string(store,name,i,j,FloatToString(entry));
}

int array_2d_set_object(object store, string name, int i, int j, object entry)
{
    // object is a little more complicated.
    // we want to create an object as a local variable too
    if (!GetIsObjectValid(entry))
        return SDL_ERROR_NOT_VALID_OBJECT;

    int results=array_2d_set_string(store,name,i,j,"OBJECT");
    if (results==SDL_SUCCESS)
        SetLocalObject(store,name+"_"+IntToString(i)+"_"+IntToString(j)+"_OBJECT",entry);

    return results;
}


string array_2d_get_string(object store, string name, int i, int j)
{
    int sizeA=GetLocalInt(store,name+"_A");
    if (sizeA==0 || i>sizeA)
        return "";
    int sizeB=GetLocalInt(store,name+"_B");
    if (sizeB==0 || j>sizeB)
        return "";

    return GetLocalString(store,name+"_"+IntToString(i)+"_"+IntToString(j));
}

int array_2d_get_int(object store, string name, int i, int j)
{
    return StringToInt(array_2d_get_string(store,name,i,j));
}

float array_2d_get_float(object store, string name, int i, int j)
{
    return StringToFloat(array_2d_get_string(store,name,i,j));
}

object array_2d_get_object(object store, string name, int i, int j)
{
    return GetLocalObject(store,name+"_"+IntToString(i)+"_"+IntToString(j)+"_OBJECT");
}


int array_2d_shrink(object store, string name, int size_new, int axis)
{
    // error checking
    int sizeA=GetLocalInt(store,name+"_A");
    if (sizeA==0)
        return SDL_ERROR_DOES_NOT_EXIST;
    int sizeB=GetLocalInt(store,name+"_B");
    if (sizeB==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    if (axis == 1 &&
        (sizeA==size_new || sizeA<size_new))
        return SDL_SUCCESS;
    if (axis == 2 &&
        (sizeB==size_new || sizeB<size_new))
        return SDL_SUCCESS;

    int i; int j;
    if(axis==1)
    {
        for (i=size_new; i<sizeA; i++)
        {
            for(j=0;j<sizeB+5;j++)
            {
                DeleteLocalString(store,name+"_"+IntToString(i)+"_"+IntToString(j));

                // just in case, delete possible object names
                DeleteLocalObject(store,name+"_"+IntToString(i)+"_"+IntToString(j)+"_OBJECT");
            }
        }

        SetLocalInt(store,name+"_A",size_new+1);
        return SDL_SUCCESS;
    }
    else if(axis==2)
    {
        for (j=size_new; j<sizeB; j++)
        {
            for(i=0;i<sizeA+5;i++)
            {
                DeleteLocalString(store,name+"_"+IntToString(i)+"_"+IntToString(j));

                // just in case, delete possible object names
                DeleteLocalObject(store,name+"_"+IntToString(i)+"_"+IntToString(j)+"_OBJECT");
            }
        }

        SetLocalInt(store,name+"_B",size_new+1);
        return SDL_SUCCESS;
    }
    else
        return SDL_ERROR_DOES_NOT_EXIST;
}

int array_2d_get_size(object store, string name, int axis)
{
    if(axis==1)
        return GetLocalInt(store,name+"_A")-1;
    else if(axis==2)
        return GetLocalInt(store,name+"_B")-1;
    else
        return 0;
}

int array_2d_exists(object store, string name)
{
    if (GetLocalInt(store,name+"_A")==0||GetLocalInt(store,name+"_B")==0)
        return FALSE;
    else
        return TRUE;
}
