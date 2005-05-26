//::///////////////////////////////////////////////
//:: Metalocation include
//:: inc_metalocation
//:://////////////////////////////////////////////
/** @file
    A metalocation is intended for reliable (independent
    of object locations in memory) storage of location
    data across module boundaries for possible eventual
    re-entry to the same module. For example, to
    carry location data over server resets.
    
    This file specifies the metalocation structure,
    which contains data equivalent to a standard
    location, and in addition name of the module the
    metalocation resides in and, if defined, the name
    of the metalocation.
    The area reference is built of two strings instead
    of a memory pointer. First string specifies the
    tag of the area containing the metalocation. The
    second string specifies the resref of the area and
    is used obtain exact match in cases where there are
    several areas with the same tag.
    
    In addition, this file contains a group of functions
    for abstracted handling of metalocation data.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.05.2005
//:://////////////////////////////////////////////

#include "inc_persist_loca"


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * A dismantled version of location with some metadata attached.
 * Intended for use of persistent storage of location data over
 * module boundaries. For example over server resets
 */
struct metalocation{
    /// Tag of the area the location is in.
    string sAreaTag;
    /// Resref of the area the location is in. Used to differentiate between
    /// areas with the same tag.
    string sAreaResRef;
    /// The coordinates of the location within the area.
    vector vCoords;
    /// The direction the location is facing.
    float  fFacing;
    /// The metalocation may be named and the name is stored in this member.
    string sName;
    /// Name of the module containing the location.
    string sModule;
    };


/**
 * Converts a standard location to equivalent metalocation.
 *
 * @param locL  The location to convert.
 * @param sName The name of the created metalocation, if any.
 * @return      The metalocation created from locL.
 */
struct metalocation LocationToMetalocation(location locL, string sName = "");

/**
 * Convert a metalocation to equivalent standard location.
 * 
 * NOTE! Will return the current module's starting location if the given
 * metalocation is not valid or not within current module.
 * As such, it is recommended that you run GetIsMetalocationInModule()
 * on the metalocation before using this.
 *
 * @param mlocL The metalocation to convert.
 * @return      The location created from mlocL.
 */
location MetalocationToLocation(struct metalocation mlocL);

/**
 * Checks whether the given metalocation is in the module currently being run.
 *
 * @param mlocL The metalocation to test.
 * @return      TRUE if mlocL refers to a location within current module,
 *              FALSE otherwise.
 */
int GetIsMetalocationInModule(struct metalocation mlocL);

/**
 * Stores the given metalocation persistantly, so that it will remain in the
 * character data over character exports.
 *
 * @param oObject The object to store the metalocation on.
 * @param sName   The local variable name the metalocation will be stored as.
 * @param mlocL   The metalocation to store.
 *
 * @see inc_persist_loca
 */
void SetPersistantLocalMetalocation(object oObject, string sName,
                                    struct metalocation mlocL);

/**
 * Retrieves the metalocation persistantly stored on the given object under
 * the given name.
 * NOTE! If there was no metalocation stored with the given name, the returned
 * value will have all it's fields blank.
 * 
 * @param oObject The object the metalocation was stored on.
 * @param sName   The name the metalocation was stored under.
 * @return        A copy of the stored metalocation.
 */
struct metalocation GetPersistantLocalMetalocation(object oObject, string sName);

/**
 * Creates a map pin based on the given metalocation. It will be created at the
 * end of the map pin array, with name equal to the metalocation's.
 *
 * @param mlocL The metalocation to create a map pin from.
 * @param oPC   The player character in whose map pin array to create the map pin in.
 */
void CreateMapPinFromMetalocation(struct metalocation mlocL, object oPC);



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

struct metalocation LocationToMetalocation(location locL, string sName = "")
{
    struct metalocation mlocL;
    object oArea = GetAreaFromLocation(locL);
    mlocL.sAreaTag    = GetTag(oArea);
    mlocL.sAreaResRef = GetResRef(oArea);
    mlocL.vCoords     = GetPositionFromLocation(locL);
    mlocL.fFacing     = GetFacingFromLocation(locL);
    mlocL.sName       = sName;
    mlocL.sModule     = GetName(GetModule());
    //mlocL.nAssociatedMapPinID = -1;
    
    return mlocL;
}

location MetalocationToLocation(struct metalocation mlocL)
{
    // Check whether the metalocation is in this module
    if(!GetIsMetalocationInModule(mlocL))
        return GetStartingLocation(); // Must return a valid location, so return starting location.
    
    // Get the area
    object oArea = GetObjectByTag(mlocL.sAreaTag);
    // Multiple areas with same tag?
    if(GetResRef(oArea) != mlocL.sAreaResRef)
    {
        int i = 1;
        oArea = GetObjectByTag(mlocL.sAreaTag, i);
        while(GetIsObjectValid(oArea) && GetResRef(oArea) != mlocL.sAreaResRef)
            oArea = GetObjectByTag(mlocL.sAreaTag, ++i);
        
        
        if(!GetIsObjectValid(oArea))
            // No such area in the module, so return starting location
            return GetStartingLocation();
    }
    
    // Construct and return the location
    return Location(oArea, mlocL.vCoords, mlocL.fFacing);
}

int GetIsMetalocationInModule(struct metalocation mlocL)
{
    return GetName(GetModule()) == mlocL.sModule;
}


void SetLocalMetalocation(object oObject, string sName, struct metalocation mlocL)
{
    SetLocalString(oObject, "Metalocation_" + sName + "_AreaTag",    mlocL.sAreaTag);
    SetLocalString(oObject, "Metalocation_" + sName + "_AreaResRef", mlocL.sAreaResRef);
    SetLocalFloat(oObject,  "Metalocation_" + sName + "_X",          mlocL.vCoords.x);
    SetLocalFloat(oObject,  "Metalocation_" + sName + "_Y",          mlocL.vCoords.y);
    SetLocalFloat(oObject,  "Metalocation_" + sName + "_Z",          mlocL.vCoords.z);
    SetLocalFloat(oObject,  "Metalocation_" + sName + "_Facing",     mlocL.fFacing);
    SetLocalString(oObject, "Metalocation_" + sName + "_Name",       mlocL.sName);
    SetLocalString(oObject, "Metalocation_" + sName + "_Module",     mlocL.sModule);
}

void SetPersistantLocalMetalocation(object oObject, string sName, struct metalocation mlocL)
{
    SetPersistantLocalString(oObject, "Metalocation_" + sName + "_AreaTag",    mlocL.sAreaTag);
    SetPersistantLocalString(oObject, "Metalocation_" + sName + "_AreaResRef", mlocL.sAreaResRef);
    SetPersistantLocalFloat(oObject,  "Metalocation_" + sName + "_X",          mlocL.vCoords.x);
    SetPersistantLocalFloat(oObject,  "Metalocation_" + sName + "_Y",          mlocL.vCoords.y);
    SetPersistantLocalFloat(oObject,  "Metalocation_" + sName + "_Z",          mlocL.vCoords.z);
    SetPersistantLocalFloat(oObject,  "Metalocation_" + sName + "_Facing",     mlocL.fFacing);
    SetPersistantLocalString(oObject, "Metalocation_" + sName + "_Name",       mlocL.sName);
    SetPersistantLocalString(oObject, "Metalocation_" + sName + "_Module",     mlocL.sModule);
}

struct metalocation GetLocalMetalocation(object oObject, string sName)
{
    struct metalocation mlocL;
    mlocL.sAreaTag    = GetLocalString(oObject, "Metalocation_" + sName + "_AreaTag");
    mlocL.sAreaResRef = GetLocalString(oObject, "Metalocation_" + sName + "_AreaResRef");
    mlocL.vCoords = Vector(GetLocalFloat(oObject, "Metalocation_" + sName + "_X"),
                           GetLocalFloat(oObject, "Metalocation_" + sName + "_Y"),
                           GetLocalFloat(oObject, "Metalocation_" + sName + "_Z")
                           );
    mlocL.fFacing = GetLocalFloat(oObject,  "Metalocation_" + sName + "_Facing");
    mlocL.sName   = GetLocalString(oObject, "Metalocation_" + sName + "_Name");
    mlocL.sModule = GetLocalString(oObject, "Metalocation_" + sName + "_Module");
    
    return mlocL;
}

struct metalocation GetPersistantLocalMetalocation(object oObject, string sName)
{
    struct metalocation mlocL;
    mlocL.sAreaTag    = GetPersistantLocalString(oObject, "Metalocation_" + sName + "_AreaTag");
    mlocL.sAreaResRef = GetPersistantLocalString(oObject, "Metalocation_" + sName + "_AreaResRef");
    mlocL.vCoords = Vector(GetPersistantLocalFloat(oObject, "Metalocation_" + sName + "_X"),
                           GetPersistantLocalFloat(oObject, "Metalocation_" + sName + "_Y"),
                           GetPersistantLocalFloat(oObject, "Metalocation_" + sName + "_Z")
                           );
    mlocL.fFacing = GetPersistantLocalFloat(oObject,  "Metalocation_" + sName + "_Facing");
    mlocL.sName   = GetPersistantLocalString(oObject, "Metalocation_" + sName + "_Name");
    mlocL.sModule = GetPersistantLocalString(oObject, "Metalocation_" + sName + "_Module");
    
    return mlocL;
}


/*
Map pin data:
Local int "NW_TOTAL_MAP_PINS"
 - Number of existing map pins.

Local string "NW_MAP_PIN_NRTY_#"
 - Name of the nth map pin.
 - # is string representation of the map pin's index number, base 1.

Local float "NW_MAP_PIN_XPOS_#"
 - The map pin's X coordinate in the area.
 - # is string representation of the map pin's index number, base 1.

Local float "NW_MAP_PIN_YPOS_#"
 - The map pin's Y coordinate in the area.
 - # is string representation of the map pin's index number, base 1.

Local object "NW_MAP_PIN_AREA_#"
 - Object reference to the area where the map pin is located.
 - # is string representation of the map pin's index number, base 1.
*/
void CreateMapPinFromMetalocation(struct metalocation mlocL, object oPC)
{
    int nID = GetLocalInt(oPC, "NW_TOTAL_MAP_PINS") + 1;
    SetLocalInt(oPC, "NW_TOTAL_MAP_PINS", nID);
    SetLocalString(oPC, "NW_MAP_PIN_NRTY_" + IntToString(nID), mlocL.sName);
    SetLocalFloat( oPC, "NW_MAP_PIN_XPOS_" + IntToString(nID), mlocL.vCoords.x);
    SetLocalFloat( oPC, "NW_MAP_PIN_YPOS_" + IntToString(nID), mlocL.vCoords.y);
    SetLocalObject(oPC, "NW_MAP_PIN_AREA_" + IntToString(nID), GetAreaFromLocation(MetalocationToLocation(mlocL)));
}



//void main(){} // Test main