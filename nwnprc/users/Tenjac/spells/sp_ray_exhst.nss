//::///////////////////////////////////////////////
//:: Name      Ray of Exhaustion
//:: FileName  sp_ray_exhst.nss
//:://////////////////////////////////////////////
/**@file Ray of Exhaustion
Necromancy
Level: 	Sor/Wiz 3
Components: 	V, S, M
Casting Time: 	1 standard action
Range: 	Close (25 ft. + 5 ft./2 levels)
Effect: 	Ray
Duration: 	1 min./level
Saving Throw: 	Fortitude partial; see text
Spell Resistance: 	Yes

A black ray projects from your pointing finger. You
must succeed on a ranged touch attack with the ray 
to strike a target.

The subject is immediately exhausted for the spell�s 
duration. A successful Fortitude save means the 
creature is only fatigued.

A character that is already fatigued instead becomes
exhausted.

This spell has no effect on a creature that is 
already exhausted. Unlike normal exhaustion or fatigue,
the effect ends as soon as the spell�s duration expires.
Material Component

A drop of sweat.

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date  : 29.9.06
//::////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fMaxDuration = (60.0f * nCasterLevel); 
    
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
	    fDur += fDur;
    }

    SPRaiseSpellCastAt(oTarget, TRUE);

    //INSERT SPELL CODE HERE
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    
    //Beam
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f); 
    
    if (iAttackRoll > 0)
    {
	    //Touch attack code goes here
	    if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
	    {
		    effect eSpeed = EffectMovementSpeedDecrease(50);
		    int nDrain = 6;
		    		    
		    //Fort save
		    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
		    {
			    if(GetHasMettle(oTarget, SAVING_THROW_FORT))
			    {
				    SPSetSchool()
				    return;
			    }
			    
			    else
			    {
				    eSpeed = EffectMovementSpeedDecrease(25);
				    nDrain = 2;
			    }
		    }
		    
		    effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, nDrain), EffectAbilityDecrease(ABILITY_DEXTERITY, nDrain));
		           eLink = EffectLinkEffects(eLink, eSpeed);
		    
		    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);			    
	    }
    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}