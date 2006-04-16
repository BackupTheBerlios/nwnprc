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

#include "x2_inc_spellhook"
#include "inc_utility"
#include "prc_inc_clsfunc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    int nDuration = 24;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    string sResRef;
    int nHD;
    //Metamagic extension if needed
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        //Tyrant Fog Zombie
        eSummon = EffectSummonCreature("NW_S_ZOMBTYRANT",VFX_FNF_SUMMON_UNDEAD);
        sResRef = "NW_S_ZOMBTYRANT";
        nHD = 4;
    }
    else if ((nCasterLevel >= 6) && (nCasterLevel <= 9))
    {
        //Skeleton Warrior
        eSummon = EffectSummonCreature("NW_S_SKELWARR",VFX_FNF_SUMMON_UNDEAD);
        sResRef = "NW_S_SKELWARR";
        nHD = 6;
    }
    else
    {
        //Skeleton Chieftain
        eSummon = EffectSummonCreature("NW_S_SKELCHIEF",VFX_FNF_SUMMON_UNDEAD);
        sResRef = "NW_S_SKELCHIEF";
        nHD = 7;
    }
    //Apply the summon visual and summon the two undead.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_PNP_ANIMATE_DEAD))
    {
        int i = 1;
        int nTotalHD;
        int nMaxHD = nCasterLevel*4;
        object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
        while(GetIsObjectValid(oSummonTest))
        {
            if(GetResRef(oSummonTest)=="nw_s_zombtyrant"//"NW_S_ZOMBTYRANT"
                || GetResRef(oSummonTest)=="nw_s_skelwarr"//"NW_S_SKELWARR"
                || GetResRef(oSummonTest)=="nw_s_skelchief"//"NW_S_SKELCHIEF"
                || GetHasSpellEffect(SPELL_ANIMATE_DEAD, oSummonTest))
                nTotalHD += GetHitDice(oSummonTest);
            if(DEBUG)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), OBJECT_SELF);
            i++;
            oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
        }
        if((nTotalHD+nHD)<=nMaxHD)
        {        
            //eSummon = ExtraordinaryEffect(eSummon); //still goes away on rest, use supernatural instead
            eSummon = SupernaturalEffect(eSummon);    
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
        }
        else
        {
            FloatingTextStringOnCreature("You cannot summon more undead at this time.", OBJECT_SELF);
        }
        FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);
    }
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}


