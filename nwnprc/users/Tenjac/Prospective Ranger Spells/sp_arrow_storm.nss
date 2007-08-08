//::///////////////////////////////////////////////
//:: Name      Arrow Storm
//:: FileName  sp_arrow_storm.nss
//:://////////////////////////////////////////////
/**@file Arrow Storm
Transmutation
Level: Ranger 3
Components: V
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

After casting arrow storm, you use a full-round 
action to make one ranged attack with a bow with 
which you are proficient against every foe within 
range. You can attack a maximum number of individual
targets equal to your character level.

Author:    Tenjac
Created:   8/8/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oPC = OBJECT_SELF;
