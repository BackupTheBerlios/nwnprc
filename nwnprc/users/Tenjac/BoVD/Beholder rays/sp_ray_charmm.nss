//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Charm Monster
//:: FileName  sp_ray_charmm.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = 13;
    int nDuration = 3 + CasterLvl/2;
    int nPenetr = CasterLvl + SPGetPenetr();
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    
    
    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    
    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
    
    if (nTouch)
    {
	    if(!GetIsReactionTypeFriendly(oTarget))	    
	    {
		    //Fire cast spell at event for the specified target
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
		    // Make SR Check
		    if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
		    {
			    // Make Will save vs Mind-Affecting
			    if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 18, SAVING_THROW_TYPE_MIND_SPELLS))
			    {
				    //Apply impact and linked effect
				    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
				    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			    }
		    }
	    }
    }
}
    