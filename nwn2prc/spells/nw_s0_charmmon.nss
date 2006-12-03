//::///////////////////////////////////////////////
//:: [Charm Monster]
//:: [NW_S0_CharmMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per 2 caster levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001
/** @file Charm Monster
Enchantment (Charm) [Mind-Affecting]
Level: 	    Brd 3, Sor/Wiz 4
Target: 	One living creature
Duration: 	One day/level

This spell functions like charm person, except that the effect 
is not restricted by creature type or size. 
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
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    //Link effects
    effect eLink = EffectLinkEffects(eVis, eCharm);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl;
    int nPenetr = nCasterLvl + SPGetPenetr();
    nDuration = GetScaledDuration(nDuration, oTarget);

    //Metamagic extend check
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
        // Make SR Check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            // Make Will save vs Mind-Affecting
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration*24),TRUE,PRCGetSpellId(),nCasterLvl);
            }
        }
    }
    SPSetSchool();

}
