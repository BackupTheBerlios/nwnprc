//:://////////////////////////////////////////////
//:: Created By: Solowing
//:: Created On: September 2, 2004
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{
object oPC = OBJECT_SELF;
if(!GetLocalInt(oPC,"arcstrikeactive"))
{
SetLocalInt(oPC,"arcstrikeactive",TRUE);
FloatingTextStringOnCreature("Spell Storing Activated",oPC);
SetLocalString(GetModule(),"arcstrikeovscript",GetModuleOverrideSpellscript());
SetModuleOverrideSpellscript("prc_arc_strike");
}
else
{
SetModuleOverrideSpellscript(GetLocalString(GetModule(),"arcstrikeovscript"));
FloatingTextStringOnCreature("Spell Storing Deactivated",oPC);
DeleteLocalInt(oPC,"arcstrikeactive");
}
}
