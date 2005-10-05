//::///////////////////////////////////////////////
//:: Maze area OnEnter
//:: prc_maze_onenter
//:://////////////////////////////////////////////
/** @file
    This script is the Maze spell's maze area
    OnEnter script. It will set the creature
    into commandable cutscene mode.


    @author Ornedan
    @date   Created - 2005.10.6
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
    object oCreature = GetEnteringObject();
    // Store old commandability and set it to true
    SetLocalInt(oCreature, "PRC_Maze_EnteringCommandability", GetCommandable(oCreature));
    SetCommandable(TRUE, oCreature);

    // Enter cutscene mode
    SetCutsceneMode(oCreature, TRUE);
}
