#include "prc_class_const"

int StartingConditional()
{

    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount4 = 0;

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

       if(GetLocalString(oScribe, "f_rest") == "1"
               ||GetLocalString(oScribe, "lh_rest") == "1"
               ||GetLocalString(oScribe, "la_rest") == "1"
               ||GetLocalString(oScribe, "lc_rest") == "1"
               ||GetLocalString(oScribe, "rh_rest") == "1"
               ||GetLocalString(oScribe, "ra_rest") == "1"
               ||GetLocalString(oScribe, "rc_rest") == "1")
            {
            SpellCount4 += 1;
            }

            if(GetLocalString(oScribe, "f_rmight") == "1"
               ||GetLocalString(oScribe, "lh_rmight") == "1"
               ||GetLocalString(oScribe, "la_rmight") == "1"
               ||GetLocalString(oScribe, "lc_rmight") == "1"
               ||GetLocalString(oScribe, "rh_rmight") == "1"
               ||GetLocalString(oScribe, "ra_rmight") == "1"
               ||GetLocalString(oScribe, "rc_rmight") == "1")
            {
            SpellCount4 += 1;
            }

            if(GetLocalString(oScribe, "f_stone") == "1"
               ||GetLocalString(oScribe, "lh_stone") == "1"
               ||GetLocalString(oScribe, "la_stone") == "1"
               ||GetLocalString(oScribe, "lc_stone") == "1"
               ||GetLocalString(oScribe, "rh_stone") == "1"
               ||GetLocalString(oScribe, "ra_stone") == "1"
               ||GetLocalString(oScribe, "rc_stone") == "1")
            {
            SpellCount4 += 1;
            }

            if(GetLocalString(oScribe, "f_impinv") == "1"
               ||GetLocalString(oScribe, "lh_impinv") == "1"
               ||GetLocalString(oScribe, "la_impinv") == "1"
               ||GetLocalString(oScribe, "lc_impinv") == "1"
               ||GetLocalString(oScribe, "rh_impinv") == "1"
               ||GetLocalString(oScribe, "ra_impinv") == "1"
               ||GetLocalString(oScribe, "rc_impinv") == "1")
            {
            SpellCount4 += 1;
            }

            if(GetLocalString(oScribe, "f_pois") == "1"
               ||GetLocalString(oScribe, "lh_pois") == "1"
               ||GetLocalString(oScribe, "la_pois") == "1"
               ||GetLocalString(oScribe, "lc_pois") == "1"
               ||GetLocalString(oScribe, "rh_pois") == "1"
               ||GetLocalString(oScribe, "ra_pois") == "1"
               ||GetLocalString(oScribe, "rc_pois") == "1")
            {
            SpellCount4 += 1;
            }

          }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 7)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 7 && SpellCount4 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 8 && SpellCount4 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 9 && SpellCount4 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 10 && SpellCount4 == 3)
        return FALSE;

    if(GetAbilityScore(GetPCSpeaker(),ABILITY_WISDOM) < 14)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}