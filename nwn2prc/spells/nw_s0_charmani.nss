//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [NW_S0_DomAni.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
/**@file charm animal
Enchantment (Charm) [Mind-Affecting]
Level: 	    Drd 1, Rgr 1
Target: 	One animal

This spell functions like charm person, except that it affects a 
creature of the animal type. 

*/

//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

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
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);
    //Link the charm and duration visual effects
    effect eLink = EffectLinkEffects(eVis, eCharm);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    int nPenetr = nCasterLvl + SPGetPenetr();
    //Meta magic duration check
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON_OR_ANIMAL, FALSE));
        //Make SR Check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            //Make sure the racial type of the target is applicable
            if  (nRacial == RACIAL_TYPE_ANIMAL)
            {
                //Make Will Save
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact effects and linked duration and charm effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,PRCGetSpellId(),nCasterLvl);
                }
            }
        }
    }
    SPSetSchool();

}
