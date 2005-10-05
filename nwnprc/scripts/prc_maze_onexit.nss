//::///////////////////////////////////////////////
//:: Maze area OnExit
//:: prc_maze_onexit
//:://////////////////////////////////////////////
/** @file
    This script is the Maze spell's maze area
    OnExit script. It will stop the cutscene mode
    and restore old commandability setting.


    @author Ornedan
    @date   Created - 2005.10.6
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
    object oCreature = GetExitingObject();
    // Restore old commandability
    SetCommandable(GetLocalInt(oCreature, "PRC_Maze_EnteringCommandability"), oCreature);

    // Exit cutscene mode
    SetCutsceneMode(oCreature, FALSE);

    // Clean up locals
    DeleteLocalInt(oCreature, "PRC_Maze_EnteringCommandability");
    DeleteLocalInt(oCreature, "PRC_Maze_Direction");
}
