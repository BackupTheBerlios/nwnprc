#include "prc_class_const"

int StartingConditional()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount1 = 0;

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

         if(GetLocalString(oScribe, "f_cmw") == "1"
            ||GetLocalString(oScribe, "lh_cmw") == "1"
            ||GetLocalString(oScribe, "la_cmw") == "1"
            ||GetLocalString(oScribe, "lc_cmw") == "1"
            ||GetLocalString(oScribe, "rh_cmw") == "1"
            ||GetLocalString(oScribe, "ra_cmw") == "1"
            ||GetLocalString(oScribe, "rc_cmw") == "1")
            {
            SpellCount1 += 1;
            }

         if(GetLocalString(oScribe, "f_divfavor") == "1"
            ||GetLocalString(oScribe, "lh_divfavor") == "1"
            ||GetLocalString(oScribe, "la_divfavor") == "1"
            ||GetLocalString(oScribe, "lc_divfavor") == "1"
            ||GetLocalString(oScribe, "rh_divfavor") == "1"
            ||GetLocalString(oScribe, "ra_divfavor") == "1"
            ||GetLocalString(oScribe, "rc_divfavor") == "1")
            {
            SpellCount1 += 1;
            }

         if(GetLocalString(oScribe, "f_seein") == "1"
            ||GetLocalString(oScribe, "lh_seein") == "1"
            ||GetLocalString(oScribe, "la_seein") == "1"
            ||GetLocalString(oScribe, "lc_seein") == "1"
            ||GetLocalString(oScribe, "rh_seein") == "1"
            ||GetLocalString(oScribe, "ra_seein") == "1"
            ||GetLocalString(oScribe, "rc_seein") == "1")
            {
            SpellCount1 += 1;
            }

         if(GetLocalString(oScribe, "f_truestrike") == "1"
            ||GetLocalString(oScribe, "lh_truestrike") == "1"
            ||GetLocalString(oScribe, "la_truestrike") == "1"
            ||GetLocalString(oScribe, "lc_truestrike") == "1"
            ||GetLocalString(oScribe, "rh_truestrike") == "1"
            ||GetLocalString(oScribe, "ra_truestrike") == "1"
            ||GetLocalString(oScribe, "rc_truestrike") == "1")
            {
            SpellCount1 += 1;
            }

         }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 1)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 1 && SpellCount1 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 2 && SpellCount1 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 3 && SpellCount1 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 4 && SpellCount1 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 5 && SpellCount1 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 6 && SpellCount1 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 7 && SpellCount1 == 4)
        return FALSE;

    if(GetAbilityScore(GetPCSpeaker(),ABILITY_WISDOM) < 11)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}