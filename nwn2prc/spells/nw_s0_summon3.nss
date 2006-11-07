//::///////////////////////////////////////////////
//:: Summon Monster III
//:: NW_S0_Summon3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dire wolf to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Brenon Holmes
//:: Created On: Dec 10 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 12, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "x2_inc_spellhook"
#include "inc_utility"
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
    effect eSummon = EffectSummonCreature("NW_S_WOLFDIRE");
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        eSummon = EffectSummonCreature("NW_S_SPIDDIRE");
    }
    if(GetHasFeat(FEAT_SUMMON_ALIEN))
    {
        eSummon = EffectSummonCreature("PSEUDODIREWOLF");
        if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
        {
            eSummon = EffectSummonCreature("PSEUDOSPIDDIRE");
        }
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
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
