//::///////////////////////////////////////////////
//:: Aid
//:: NW_S0_Aid.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature gains +1 to attack rolls and
    saves vs fear. Also gain +1d8 +1/lvl temporary HP.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 6, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// (Updated JLR - OEI 07/05/05 NWN2 3.5)
// (Updated JLR - OEI 08/01/05 NWN2 3.5 -- Metamagic cleanup)
// JLR - OEI 08/23/05 -- Metamagic changes

/* ADD BACK IN */
// #include "nwn2_inc_spells"


#include "x2_inc_spellhook"
#include "prc_sp_func"

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
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nBonus = d8(1);
    
    int nSpellID = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nBonus = 8;//Damage is at max
    }
    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nBonus = nBonus + (nBonus/2); //Damage/Healing is +50%
    }
    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration *2; //Duration is +100%
    }

    if( nCasterLvl > 10 )
    {
        nBonus = nBonus + 10;
    }
    else
    {
        nBonus = nBonus + nCasterLvl;
    }

    // need to add NWN2 metamagic here
    int nDurType = DURATION_TYPE_TEMPORARY;


    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eHP = EffectTemporaryHitpoints(nBonus);

    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
    object oTarget = PRCGetSpellTargetObject();
    
    effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = EffectLinkEffects(eLink, eHP);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(nDurType, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLvl);
    
    SPSetSchool();
}