// "sdl_array"

/////////////////////////////////////
// Functions
/////////////////////////////////////

int array_create(object store, string name);
int array_delete(object store, string name);

int array_set_string(object store, string name, int i, string entry);
int array_set_int(object store, string name, int i, int entry);
int array_set_float(object store, string name, int i, float entry);
int array_set_object(object store, string name, int i, object entry);

// returns "" or 0 on error
string array_get_string(object store, string name, int i);
int array_get_int(object store, string name, int i);
float array_get_float(object store, string name, int i);
object array_get_object(object store, string name, int i);

// changes memory usage of array (deletes x[ > size_new])
int array_shrink(object store, string name, int size_new);

// gets current maximum size of array
int array_get_size(object store, string name);

int array_exists(object store, string name);

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

int SDL_SUCCESS = 1;
int SDL_ERROR_ALREADY_EXISTS = 1001;
int SDL_ERROR_DOES_NOT_EXIST = 1002;
int SDL_ERROR_OUT_OF_BOUNDS = 1003;
int SDL_ERROR_NO_ZERO_SIZE = 1004;
int SDL_ERROR_NOT_VALID_OBJECT = 1005;

/////////////////////////////////////
// Implementation
/////////////////////////////////////

int array_create(object store, string name)
{
    // error checking
    if (GetLocalInt(store,name))
        return SDL_ERROR_ALREADY_EXISTS;
    else
    {
        // Initialize the size (always one greater than the actual size)
        SetLocalInt(store,name,1);
        return SDL_SUCCESS;
    }
}

int array_delete(object store, string name)
{
    // error checking
    int size=GetLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    int i;
    for (i=0; i<size+5; i++)
    {
        DeleteLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeleteLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    DeleteLocalInt(store,name);

    return SDL_SUCCESS;
}

int array_set_string(object store, string name, int i, string entry)
{
    int size=GetLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    SetLocalString(store,name+"_"+IntToString(i),entry);

    // save size if we've enlarged it
    if (i+2>size)
        SetLocalInt(store,name,i+2);

    return SDL_SUCCESS;
}

int array_set_int(object store, string name, int i, int entry)
{
    return array_set_string(store,name,i,IntToString(entry));
}

int array_set_float(object store, string name, int i, float entry)
{
    return array_set_string(store,name,i,FloatToString(entry));
}

int array_set_object(object store, string name, int i, object entry)
{
    // object is a little more complicated.
    // we want to create an object as a local variable too
    if (!GetIsObjectValid(entry))
        return SDL_ERROR_NOT_VALID_OBJECT;

    int results=array_set_string(store,name,i,"OBJECT");
    if (results==SDL_SUCCESS)
        SetLocalObject(store,name+"_"+IntToString(i)+"_OBJECT",entry);

    return results;
}

string array_get_string(object store, string name, int i)
{
    // error checking
    int size=GetLocalInt(store,name);
    if (size==0 || i>size)
        return "";

    return GetLocalString(store,name+"_"+IntToString(i));
}

int array_get_int(object store, string name, int i)
{
    return StringToInt(array_get_string(store,name,i));
}

float array_get_float(object store, string name, int i)
{
    return StringToFloat(array_get_string(store,name,i));
}

object array_get_object(object store, string name, int i)
{
    return GetLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
}

int array_shrink(object store, string name, int size_new)
{
    // error checking
    int size=GetLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;
    if (size==size_new || size<size_new)
        return SDL_SUCCESS;

    int i;
    for (i=size_new; i<size; i++)
    {
        DeleteLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeleteLocalString(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    SetLocalInt(store,name,size_new+1);

    return SDL_SUCCESS;
}

int array_get_size(object store, string name)
{
    return GetLocalInt(store,name)-1;
}

int array_exists(object store, string name)
{
    if (GetLocalInt(store,name)==0)
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

// sdl_queue

/////////////////////////////////////
// Functions
/////////////////////////////////////

int queue_create(object store, string name);
int queue_delete(object store, string name);

int queue_push_string(object store, string name, string entry);
int queue_push_int(object store, string name, int entry);
int queue_push_float(object store, string name, float entry);
int queue_push_object(object store, string name, object entry);

string queue_pop_string(object store, string name);
int queue_pop_int(object store, string name);
float queue_pop_float(object store, string name);
object queue_pop_object(object store, string name);

string queue_peek_string(object store, string name);
int queue_peek_int(object store, string name);
float queue_peek_float(object store, string name);
object queue_peek_object(object store, string name);

int queue_is_empty(object store, string name);
int queue_get_size(object store, string name);

/////////////////////////////////////
// Notes:
//
// * first object in array is head location
// * second object in array is tail location
// * this queue will eventually fail when it gets to int(max);
//   this can be fixed either by using a linked list or catching
//   this condition
/////////////////////////////////////

/////////////////////////////////////
// Implementation
/////////////////////////////////////

const int QUEUE_HEAD = 0;
const int QUEUE_TAIL = 1;

int queue_create(object store, string name)
{
    int results=array_create(store,name);

    // set head and tail of queue
    if (results==SDL_SUCCESS)
    {
        array_set_int(store,name,QUEUE_HEAD,2);
        array_set_int(store,name,QUEUE_TAIL,2);
    }

    return results;
}

int queue_delete(object store, string name)
{
    return array_delete(store,name);
}

int queue_push_string(object store, string name, string entry)
{
    // error checking
    if (!array_exists(store,name))
        return SDL_ERROR_DOES_NOT_EXIST;

    int tail=array_get_int(store,name,QUEUE_TAIL);

    int results=array_set_string(store,name,tail,entry);
    if (results!=SDL_SUCCESS)
        return results;

    return array_set_int(store,name,QUEUE_TAIL,tail+1);
}

int queue_push_int(object store, string name, int entry)
{
    return queue_push_string(store,name,IntToString(entry));
}

int queue_push_float(object store, string name, float entry)
{
    return queue_push_string(store,name,FloatToString(entry));
}

int queue_push_object(object store, string name, object entry)
{
    // error checking
    if (!array_exists(store,name))
        return SDL_ERROR_DOES_NOT_EXIST;

    int tail=array_get_int(store,name,QUEUE_TAIL);

    int results=array_set_object(store,name,tail,entry);
    if (results!=SDL_SUCCESS)
        return results;

    return array_set_int(store,name,QUEUE_TAIL,tail+1);
}

string queue_pop_string(object store, string name)
{
    // error checking
    if (!array_exists(store,name))
        return "";
    int head=array_get_int(store,name,QUEUE_HEAD);
    if (head==0)
        return "";
    else
    {
        string popped=array_get_string(store,name,head);
//        array_shrink(store,name,size);
        array_set_int(store,name,QUEUE_HEAD,head+1);

        return popped;
    }
}

int queue_pop_int(object store, string name)
{
    return StringToInt(queue_pop_string(store,name));
}

float queue_pop_float(object store, string name)
{
    return StringToFloat(queue_pop_string(store,name));
}

object queue_pop_object(object store, string name)
{
/* No error checking :(
    // error checking
    if (!array_exists(store,name))
        return "";
*/
    int head=array_get_int(store,name,QUEUE_HEAD);
/*    if (head==0)
        return "";*/

    object popped=array_get_object(store,name,head);
//        array_shrink(store,name,size);
    array_set_int(store,name,QUEUE_HEAD,head+1);

    return popped;
}

string queue_peek_string(object store, string name)
{
    // error checking
    if (!array_exists(store,name))
        return "";
    int head=array_get_int(store,name,QUEUE_HEAD);
    if (head==0)
        return "";
    else
    {
        string popped=array_get_string(store,name,head);
        return popped;
    }
}

int queue_peek_int(object store, string name)
{
    return StringToInt(queue_peek_string(store,name));
}

float queue_peek_float(object store, string name)
{
    return StringToFloat(queue_peek_string(store,name));
}

object queue_peek_object(object store, string name)
{
/* No error checking :(
    // error checking
    if (!array_exists(store,name))
        return "";
*/
    int head=array_get_int(store,name,QUEUE_HEAD);
/*    if (head==0)
        return "";*/

    object popped=array_get_object(store,name,head);

    return popped;
}

int queue_is_empty(object store, string name)
{
    if (array_get_int(store,name,QUEUE_HEAD)==array_get_int(store,name,QUEUE_TAIL))
        return TRUE;
    else
        return FALSE;
}

int queue_get_size(object store, string name)
{
    return array_get_int(store,name,QUEUE_TAIL)-array_get_int(store,name,QUEUE_HEAD);
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

/////////////////////////////////////
// Functions
/////////////////////////////////////

int stack_create(object store, string name);
int stack_delete(object store, string name);

int stack_push_string(object store, string name, string entry);
int stack_push_int(object store, string name, int entry);
int stack_push_float(object store, string name, float entry);
int stack_push_object(object store, string name, object entry);

string stack_pop_string(object store, string name);
int stack_pop_int(object store, string name);
float stack_pop_float(object store, string name);
object stack_pop_object(object store, string name);

int stack_is_empty(object store, string name);

/////////////////////////////////////
// Notes:
//
// * first object in array is stack size
/////////////////////////////////////

/////////////////////////////////////
// Implementation
/////////////////////////////////////

int stack_create(object store, string name)
{
    int results=array_create(store,name);

    // set size of array
    if (results==SDL_SUCCESS)
        array_set_int(store,name,0,0);

    return results;
}

int stack_delete(object store, string name)
{
    return array_delete(store,name);
}

int stack_push_string(object store, string name, string entry)
{
    // error checking
    if (!array_exists(store,name))
        return SDL_ERROR_DOES_NOT_EXIST;

    int size=array_get_int(store,name,0);

    int results=array_set_string(store,name,size+1,entry);
    if (results!=SDL_SUCCESS)
        return results;

    return array_set_int(store,name,0,size+1);
}

int stack_push_int(object store, string name, int entry)
{
    return stack_push_string(store,name,IntToString(entry));
}

int stack_push_float(object store, string name, float entry)
{
    return stack_push_string(store,name,FloatToString(entry));
}

int stack_push_object(object store, string name, object entry)
{
    // error checking
    if (!array_exists(store,name))
        return SDL_ERROR_DOES_NOT_EXIST;

    int size=array_get_int(store,name,0);

    int results=array_set_object(store,name,size+1,entry);
    if (results!=SDL_SUCCESS)
        return results;
    else
        return array_set_int(store,name,0,size+1);
}

string stack_pop_string(object store, string name)
{
    // error checking
    if (!array_exists(store,name))
        return "";
    int size=array_get_int(store,name,0);
    if (size==0)
        return "";
    else
    {
        string popped=array_get_string(store,name,size);
        array_shrink(store,name,size);
        array_set_int(store,name,0,size-1);

        return popped;
    }
}

int stack_pop_int(object store, string name)
{
    return StringToInt(stack_pop_string(store,name));
}

float stack_pop_float(object store, string name)
{
    return StringToFloat(stack_pop_string(store,name));
}

object stack_pop_object(object store, string name)
{
/* No error checking :(
    // error checking
    if (!array_exists(store,name))
        return SDL_ERROR_DOES_NOT_EXIST;
*/
    int size=array_get_int(store,name,0);

/* no error checking :(
    if (size==0)
        return "";
*/
    object popped=array_get_object(store,name,size);
    array_shrink(store,name,size);
    array_set_int(store,name,0,size-1);

    return popped;
}

int stack_is_empty(object store, string name)
{
    int size=array_get_size(store,name);

    if (size==1 || size==0)
        return TRUE;
    else
        return FALSE;
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

