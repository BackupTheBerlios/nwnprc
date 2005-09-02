//::///////////////////////////////////////////////
//:: Summon Monster IX
//:: NW_S0_Summon9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a elder elemental to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "x2_inc_spellhook"
#include "prc_inc_switch"
void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

     /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook
    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    int nRoll = d4();
    if(GetHasFeat(FEAT_SUMMON_ALIEN))
    {
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("PSEUDOAIRELDER");
            break;

            case 2:
                eSummon = EffectSummonCreature("PSEUDOWATERELDER");
            break;

            case 3:
                eSummon = EffectSummonCreature("PSEUDOEARTHELDER");
            break;

            case 4:
                eSummon = EffectSummonCreature("PSEUDOFIREELDER");
            break;

        }
    }
    else
    switch (nRoll)
    {
        case 1:
            eSummon = EffectSummonCreature("NW_S_AIRELDER");
        break;

        case 2:
            eSummon = EffectSummonCreature("NW_S_WATERELDER");
        break;

        case 3:
            eSummon = EffectSummonCreature("NW_S_EARTHELDER");
        break;

        case 4:
            eSummon = EffectSummonCreature("NW_S_FIREELDER");
        break;
    }
    //Make metamagic check for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
