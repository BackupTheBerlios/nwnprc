//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Charm Monster
//:: FileName  sp_ray_charmm.nss
//:://////////////////////////////////////////////

#include "spinc_common"


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
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
	    //Metamagic extend check
	    if ((nMetaMagic & METAMAGIC_EXTEND))
	    {
		    nDuration = nDuration * 2;
	    }
	    if(!GetIsReactionTypeFriendly(oTarget))
	    
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
				    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
				    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			    }
		    }
	    }
    }
}
    