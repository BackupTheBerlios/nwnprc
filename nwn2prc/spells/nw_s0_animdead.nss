//::///////////////////////////////////////////////
//:: Animate Dead
//:: NW_S0_AnimDead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a powerful skeleton or zombie depending
    on caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"
#include "prc_inc_clsfunc"

void main()
{
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
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
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel; // nwn2 change
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    int nHD;
    //Metamagic extension if needed
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        // Skeleton
		eSummon = EffectSummonCreature("c_skeleton", VFX_FNF_SUMMON_UNDEAD);
        nHD = 1;
    }
    else if ((nCasterLevel >= 6) && (nCasterLevel <= 9))
    {
        // Zombie
		eSummon = EffectSummonCreature("c_zombie", VFX_FNF_SUMMON_UNDEAD);
        nHD = 2;
    }
    else
    {
        // Skeleton Warrior
		eSummon = EffectSummonCreature("c_skeletonwarrior", VFX_FNF_SUMMON_UNDEAD);
        nHD = 3;
    }

    //Apply the summon visual and summon the two undead.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_PNP_ANIMATE_DEAD))
    {
        int nMaxHD = nCasterLevel*4;
        int nTotalHD = GetControlledUndeadTotalHD();
        if((nTotalHD+nHD)<=nMaxHD)
        {        
            //eSummon = ExtraordinaryEffect(eSummon); //still goes away on rest, use supernatural instead
            eSummon = SupernaturalEffect(eSummon);    
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
        }
        else
            FloatingTextStringOnCreature("You cannot create more undead at this time.", OBJECT_SELF);
        FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);
    }
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(nDuration));
    SPEvilShift(OBJECT_SELF);
    SPSetSchool();

}


