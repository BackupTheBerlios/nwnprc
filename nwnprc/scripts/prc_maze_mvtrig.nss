//::///////////////////////////////////////////////
//:: Maze area movement trigger onenter
//:: prc_maze_mvtrig
//:://////////////////////////////////////////////
/** @file
    This script is used with the Maze spell's maze
    area movement control triggers. It determines
    the directions the PC can go and randomly
    selects one. If possible, it avoids moving
    to the same direction the PC came from.

    The directions possible are stored as bit flags
    on a local integer called "directions" on the
    trigger.
    The non-preferred direction is stored as
    local integer "PRC_Maze_Direction" on the creature.


    @author Ornedan
    @date   Created - 2005.10.6
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_debug"

// Direction constants
const int NORTH = 0x1000;
const int SOUTH = 0x0100;
const int WEST  = 0x0010;
const int EAST  = 0x0001;



const int LOCAL_DEBUG = FALSE;



/******************\
* Helper functions *
\******************/

string DebugDir2String(int n)
{
    return (n == NORTH ? "NORTH":
            n == SOUTH ? "SOUTH":
            n == WEST  ? "WEST" :
            n == EAST  ? "EAST" :
            "ERROR"
            );
}

void GoDirection(object oCreature, int nDirection)
{
    if(LOCAL_DEBUG) DoDebug("prc_maze_mvtrig: GoDirection(): Direction is " + DebugDir2String(nDirection));
    // Generate location for the direction
    location lDir;
    vector v = GetPosition(oCreature);
    if(nDirection == NORTH || nDirection == SOUTH)
    {
        v.y = nDirection == NORTH ? 160.0f : 0.0f;
        lDir = Location(GetArea(oCreature), v, 0.0f);
    }
    else
    {
        v.x = nDirection == EAST ? 160.0f : 0.0f;
        lDir = Location(GetArea(oCreature), v, 0.0f);
    }
    // Generate a location at the center of the trigger
    location lTrigCenter;
    v = GetPosition(OBJECT_SELF);
    v.x = IntToFloat(((FloatToInt(v.x) / 10) * 10) + 5);
    v.y = IntToFloat(((FloatToInt(v.y) / 10) * 10) + 5);
    lTrigCenter = Location(GetArea(oCreature), v, GetFacing(oCreature));

    // Nuke current action and move to the direction
    AssignCommand(oCreature, ClearAllActions());
    AssignCommand(oCreature, ActionMoveToLocation(lTrigCenter));
    AssignCommand(oCreature, ActionMoveToLocation(lDir));
    // Turn the camera
    AssignCommand(oCreature, SetCameraFacing((nDirection == NORTH ? 90.0f  :
                                              nDirection == SOUTH ? 270.0f :
                                              nDirection == WEST  ? 180.0f :
                                                         /*EAST*/  0.0f
                                              ),
                                             -1.0f, -1.0f, CAMERA_TRANSITION_TYPE_FAST)
                  );

    // Store the direction one should not move to from the next junction
    switch(nDirection)
    {
        case NORTH: SetLocalInt(oCreature, "PRC_Maze_Direction", SOUTH); break;
        case SOUTH: SetLocalInt(oCreature, "PRC_Maze_Direction", NORTH); break;
        case WEST:  SetLocalInt(oCreature, "PRC_Maze_Direction", EAST);  break;
        case EAST:  SetLocalInt(oCreature, "PRC_Maze_Direction", WEST);  break;
    }
}

int SelectRandomDirection(int nPosDirFlags, int nNumDirs)
{
    // Determine which of the possible directions to use
    int nChoice;
    switch(nNumDirs)
    {
        case 1:
            nChoice = 1;
            break;
        case 2:
            nChoice = d2();
            break;
        case 3:
            nChoice = d3();
            break;
    }

    // Determine the choiceth direction
    int nFound = 0, i;
    for(i = EAST; i <= NORTH; i <<= 4)
    {
       if(nPosDirFlags & i){
            nFound++;
            if(LOCAL_DEBUG) DoDebug("prc_maze_mvtrig: SelectRandomDirection(): Found a 1 bit, value = " + DebugDir2String(i) + "\nRemaining to find: " + IntToString(nChoice - nFound));
        }
        if(nFound == nChoice)
            return i;
    }

    string s = "";
    if(nPosDirFlags & NORTH) s += " NORTH";
    if(nPosDirFlags & SOUTH) s += " SOUTH";
    if(nPosDirFlags & WEST)  s += " WEST";
    if(nPosDirFlags & EAST)  s += " EAST";

    if(LOCAL_DEBUG) DoDebug("prc_maze_mvtrig: SelectRandomDirection(): ERROR: Direction not chosen in loop! Possible directions: " + s);

    return 0;
}


void main()
{
    object oCreature = GetEnteringObject();
    int nDirCameFrom = GetLocalInt(oCreature, "PRC_Maze_Direction");
    int nPosDirFlags = GetLocalInt(OBJECT_SELF, "directions");
    int nNumDirs = 0;
    int nChoice;

    // Nuke the old forbidden direction

    // Determine how many directions are possible
    if(nPosDirFlags & NORTH) nNumDirs++;
    if(nPosDirFlags & SOUTH) nNumDirs++;
    if(nPosDirFlags & WEST)  nNumDirs++;
    if(nPosDirFlags & EAST)  nNumDirs++;

    if(LOCAL_DEBUG) DoDebug("prc_maze_mvtrig: Possible directions = " + IntToString(nNumDirs) + "; Non-preferred direction: " + DebugDir2String(nDirCameFrom));

    switch(nNumDirs)
    {
        case 1:
            // Go to the only possible direction
            if(nPosDirFlags & NORTH) GoDirection(oCreature, NORTH);
            if(nPosDirFlags & SOUTH) GoDirection(oCreature, SOUTH);
            if(nPosDirFlags & WEST)  GoDirection(oCreature, WEST);
            if(nPosDirFlags & EAST)  GoDirection(oCreature, EAST);
            break;
        case 2:
        case 3:
        case 4:
            nChoice = SelectRandomDirection(nPosDirFlags ^ nDirCameFrom, nNumDirs - 1); // Remove the direction the creature came from from the set of possibilities
            GoDirection(oCreature, nChoice);
            break;

        default:
            if(LOCAL_DEBUG) DoDebug("prc_maze_mvtrig: ERROR: No directions defined on trigger");
    }
}
