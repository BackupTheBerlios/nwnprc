//::///////////////////////////////////////////////
//:: Wild Surge: Off
//:: prc_wld_srg_off
//::///////////////////////////////////////////////
/** @file
    Turns Wild Surge off on the using character.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, "WildSurge", 0);
    FloatingTextStrRefOnCreature(16823612, oPC, FALSE);
}