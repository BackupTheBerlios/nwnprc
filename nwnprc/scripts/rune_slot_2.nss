#include "prc_class_const"

int StartingConditional()
{

    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount2 = 0;

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

         if(GetLocalString(oScribe, "f_bulls") == "1"
            ||GetLocalString(oScribe, "lh_bulls") == "1"
            ||GetLocalString(oScribe, "la_bulls") == "1"
            ||GetLocalString(oScribe, "lc_bulls") == "1"
            ||GetLocalString(oScribe, "rh_bulls") == "1"
            ||GetLocalString(oScribe, "ra_bulls") == "1"
            ||GetLocalString(oScribe, "rc_bulls") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_csw") == "1"
            ||GetLocalString(oScribe, "lh_csw") == "1"
            ||GetLocalString(oScribe, "la_csw") == "1"
            ||GetLocalString(oScribe, "lc_csw") == "1"
            ||GetLocalString(oScribe, "rh_csw") == "1"
            ||GetLocalString(oScribe, "ra_csw") == "1"
            ||GetLocalString(oScribe, "rc_csw") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_endur") == "1"
            ||GetLocalString(oScribe, "lh_endur") == "1"
            ||GetLocalString(oScribe, "la_endur") == "1"
            ||GetLocalString(oScribe, "lc_endur") == "1"
            ||GetLocalString(oScribe, "rh_endur") == "1"
            ||GetLocalString(oScribe, "ra_endur") == "1"
            ||GetLocalString(oScribe, "rc_endur") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_invis") == "1"
            ||GetLocalString(oScribe, "lh_invis") == "1"
            ||GetLocalString(oScribe, "la_invis") == "1"
            ||GetLocalString(oScribe, "lc_invis") == "1"
            ||GetLocalString(oScribe, "rh_invis") == "1"
            ||GetLocalString(oScribe, "ra_invis") == "1"
            ||GetLocalString(oScribe, "rc_invis") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_keen") == "1"
            ||GetLocalString(oScribe, "lh_keen") == "1"
            ||GetLocalString(oScribe, "la_keen") == "1"
            ||GetLocalString(oScribe, "lc_keen") == "1"
            ||GetLocalString(oScribe, "rh_keen") == "1"
            ||GetLocalString(oScribe, "ra_keen") == "1"
            ||GetLocalString(oScribe, "rc_keen") == "1")
            {
            SpellCount2 += 1;
            }

         }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 3)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 3 && SpellCount2 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 4 && SpellCount2 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 5 && SpellCount2 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 6 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 7 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 8 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 9 && SpellCount2 == 4)
        return FALSE;

    if(GetAbilityScore(GetPCSpeaker(),ABILITY_WISDOM) < 12)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}