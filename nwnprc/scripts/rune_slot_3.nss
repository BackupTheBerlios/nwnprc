#include "prc_class_const"

int StartingConditional()
{

    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount3 = 0;

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

       if(GetLocalString(oScribe, "f_ccw") == "1"
            ||GetLocalString(oScribe, "lh_ccw") == "1"
            ||GetLocalString(oScribe, "la_ccw") == "1"
            ||GetLocalString(oScribe, "lc_ccw") == "1"
            ||GetLocalString(oScribe, "rh_ccw") == "1"
            ||GetLocalString(oScribe, "ra_ccw") == "1"
            ||GetLocalString(oScribe, "rc_ccw") == "1")
            {
            SpellCount3 += 1;
            }

            if(GetLocalString(oScribe, "f_divpower") == "1"
               ||GetLocalString(oScribe, "lh_divpower") == "1"
               ||GetLocalString(oScribe, "la_divpower") == "1"
               ||GetLocalString(oScribe, "lc_divpower") == "1"
               ||GetLocalString(oScribe, "rh_divpower") == "1"
               ||GetLocalString(oScribe, "ra_divpower") == "1"
               ||GetLocalString(oScribe, "rc_divpower") == "1")
            {
            SpellCount3 += 1;
            }

            if(GetLocalString(oScribe, "f_dward") == "1"
               ||GetLocalString(oScribe, "lh_dward") == "1"
               ||GetLocalString(oScribe, "la_dward") == "1"
               ||GetLocalString(oScribe, "lc_dward") == "1"
               ||GetLocalString(oScribe, "rh_dward") == "1"
               ||GetLocalString(oScribe, "ra_dward") == "1"
               ||GetLocalString(oScribe, "rc_dward") == "1")
            {
            SpellCount3 += 1;
            }

            if(GetLocalString(oScribe, "f_gmw") == "1"
               ||GetLocalString(oScribe, "lh_gmw") == "1"
               ||GetLocalString(oScribe, "la_gmw") == "1"
               ||GetLocalString(oScribe, "lc_gmw") == "1"
               ||GetLocalString(oScribe, "rh_gmw") == "1"
               ||GetLocalString(oScribe, "ra_gmw") == "1"
               ||GetLocalString(oScribe, "rc_gmw") == "1")
            {
            SpellCount3 += 1;
            }

            if(GetLocalString(oScribe, "f_haste") == "1"
               ||GetLocalString(oScribe, "lh_haste") == "1"
               ||GetLocalString(oScribe, "la_haste") == "1"
               ||GetLocalString(oScribe, "lc_haste") == "1"
               ||GetLocalString(oScribe, "rh_haste") == "1"
               ||GetLocalString(oScribe, "ra_haste") == "1"
               ||GetLocalString(oScribe, "rc_haste") == "1")
            {
            SpellCount3 += 1;
            }

          }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 5)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 5 && SpellCount3 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 6 && SpellCount3 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 7 && SpellCount3 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 8 && SpellCount3 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 9 && SpellCount3 == 3)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
