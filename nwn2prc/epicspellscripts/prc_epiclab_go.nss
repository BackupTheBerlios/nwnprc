
#include "prc_alterations"
#include "inc_dispel"


//Put this on action taken in the conversation editor
void main()
{
//Make sure you can't run this script if the builder doesn't want it to run...
if (GetPRCSwitch(PRC_SPELLSLAB) > 2) return;

object oPC = GetPCSpeaker();

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("epiclabportal");

lTarget = GetLocation(oTarget);

//only do the jump if the location is valid.
//though not flawless, we just check if it is in a valid area.
//the script will stop if the location isn't valid - meaning that
//nothing put after the teleport will fire either.
//the current location won't be stored, either

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

SetLocalLocation(oPC, "epiclab_stored_loc", GetLocation(oPC));

//Make it impossible to teleport loop inside the lab
object oLaboratory = GetArea(oTarget);
SetLocalInt(oLaboratory, "IN_THE_LAB", 1);

AssignCommand(oPC, ClearAllActions());

DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

oTarget = oPC;

//Visual effects can't be applied to waypoints, so if it is a WP
//apply to the WP's location instead

int nInt;
nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));

}
