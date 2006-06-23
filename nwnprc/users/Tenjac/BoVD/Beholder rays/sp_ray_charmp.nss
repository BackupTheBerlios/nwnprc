//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Charm Person
//:: FileName  sp_ray_charmp.nss
//:://////////////////////////////////////////////


#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link persistant effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = 13;
    int nDuration = 2 + CasterLvl/3;
    int nPenetr = CasterLvl + SPGetPenetr();
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    
    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    
    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
    
    if (nTouch)
    {
	    //Make Metamagic check for extend
	    if ((nMetaMagic & METAMAGIC_EXTEND))
	    {
		    nDuration = nDuration * 2;
	    }
	    if(!GetIsReactionTypeFriendly(oTarget))
	    {
		    //Fire cast spell at event for the specified target
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
		    //Make SR Check
		    if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
		    {
			    //Verify that the Racial Type is humanoid
			    if  ((nRacial == RACIAL_TYPE_DWARF) ||
			    (nRacial == RACIAL_TYPE_ELF) ||
			    (nRacial == RACIAL_TYPE_GNOME) ||
			    (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
			    (nRacial == RACIAL_TYPE_HALFLING) ||
			    (nRacial == RACIAL_TYPE_HUMAN) ||
			    (nRacial == RACIAL_TYPE_HALFELF) ||
			    (nRacial == RACIAL_TYPE_HALFORC) ||
			    (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
			    (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
			    (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
			    {
				    //Make a Will Save check
				    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
				    {
					    //Apply impact and linked effects
					    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
					    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				    }
			    }
		    }
	    }
    }
}