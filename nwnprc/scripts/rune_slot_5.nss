#include "prc_class_const"

int StartingConditional()
{

    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount5 = 0;

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

       if(GetLocalString(oScribe, "f_spellr") == "1"
               ||GetLocalString(oScribe, "lh_spellr") == "1"
               ||GetLocalString(oScribe, "la_spellr") == "1"
               ||GetLocalString(oScribe, "lc_spellr") == "1"
               ||GetLocalString(oScribe, "rh_spellr") == "1"
               ||GetLocalString(oScribe, "ra_spellr") == "1"
               ||GetLocalString(oScribe, "rc_spellr") == "1")
            {
            SpellCount5 += 1;
            }

            if(GetLocalString(oScribe, "f_heal") == "1"
               ||GetLocalString(oScribe, "lh_heal") == "1"
               ||GetLocalString(oScribe, "la_heal") == "1"
               ||GetLocalString(oScribe, "lc_heal") == "1"
               ||GetLocalString(oScribe, "rh_heal") == "1"
               ||GetLocalString(oScribe, "ra_heal") == "1"
               ||GetLocalString(oScribe, "rc_heal") == "1")
            {
            SpellCount5 += 1;
            }

          }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 9)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 9 && SpellCount5 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 10 && SpellCount5 == 2)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
