//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Chilling Tentacles  ON ENTER
//:: nw_s0_chilltent.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Chilling Tentacles
        Complete Arcane, pg. 132  PHB 229
        Spell Level:	5
        Class: 		    Misc   

        This functions identically to the Evard's black tentacles spell 
        (4th level wizard) except that each creature in the area of effect
        takes an additional 2d6 of cold damage per round regardless 
        if tentacles hit them or not.
	
		Upon entering the mass of "soul-chilling" rubbery tentacles the
		target is struck by 1d4 tentacles.  Each has a chance to hit of 5 + 1d20. 
		If it succeeds then it does 2d6 damage and the target must make
		a Fortitude Save versus paralysis or be paralyzed for 1 round.

	PnP Rules for Evard's Tentacles
	Grapple Check = BaB + STR Mod + Size Mod  (Can Use Escape Artist Check to Break Free)
	Grapple Check vs. Tentacles = Caster Level+8
	Once grappling a foe, make another check to deal 1d6+4 bludgeoning damage.
	-50% movement speed to ANYONE in the Area of Effect.
*/
//:://////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"

// values should be turned into switches for PRC pack
const int TENTACLE_STACK_NO = 0;	// no stacking of tentacle grapples, cold damage, etc.
const int TENTACLE_STACK_CASTER = 1;	// stacks, but only if cast by different casters
const int TENTACLE_STACK_ALL = 2;	// all tentacles stack

int currentStackType = TENTACLE_STACK_CASTER;

int DoGrappleCheckTentacle(object oCaster, object oTarget)
{
	int nAttackerBonus = 0;
	int nDefenderBonus = 0;
	int nSize = GetCreatureSize(oTarget);
	
	// Size Bonus/Penalty - exlcudes sizes not in NwN2
	// Fine -16, Dimminutive -12, Gargantuan+12, Collosal+16 in the game.
	if( nSize == CREATURE_SIZE_HUGE ) 	nDefenderBonus = 8;
	else if( nSize == CREATURE_SIZE_LARGE ) nDefenderBonus = 4;
	else if( nSize == CREATURE_SIZE_SMALL ) nDefenderBonus = -4;
	else if( nSize == CREATURE_SIZE_TINY ) 	nDefenderBonus = -8;
	
	// Any size greater than HUGE would automatically fail... should we add that, code goes here.
	
	// tentacles - 19 STR, LARGE, BaB = Caster Level
	nAttackerBonus = GetCasterLevel(oCaster) + 8;
	nDefenderBonus = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + nDefenderBonus;
	int nCasterVal = d20(1) + nAttackerBonus;
	int nTargetVal = d20(1) + nDefenderBonus;
	
	if(nCasterVal > nTargetVal)	return TRUE;
	else if (nCasterVal == nTargetVal )
		if(nAttackerBonus > nDefenderBonus)	return TRUE;
		else if ( nAttackerBonus == nDefenderBonus)	return DoGrappleCheckTentacle(oCaster, oTarget);
		else					return FALSE;
	else				return FALSE;
}

void main()
{
	//SpawnScriptDebugger();
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eImmoble = EffectCutsceneImmobilize();
    effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eVis, eImmoble);
    effect eDam;

    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = 0;
    
    string sVar = "PRC_grappledby_" + GetName(oCaster) + "_tentacle";
    string sStackVar = "PRC_effectedby_";    
    if (currentStackType == TENTACLE_STACK_CASTER) sStackVar += GetName(oCaster);    
    sStackVar += "_tentacle";

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator())  && (currentStackType == TENTACLE_STACK_ALL || GetLocalInt(oTarget, sStackVar)) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt( oCaster, SPELL_I_CHILLING_TENTACLES));
        
     	// apply slowing effect to all in the area.
    	DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1)));
    
    	// if the target is already grappled, or you successfully start a new grapple
    	if( GetLocalInt(oTarget, sVar) || DoGrappleCheckTentacle (oCaster, oTarget) )
    	{
    		// set already grappled to true
    		SetLocalInt(oTarget, sVar, TRUE);
    	
    		// target is held and takes damage
    	 	if( DoGrappleCheckTentacle (oCaster, oTarget) )
    		{
    			nDamage = d6()+4;
			//Enter Metamagic conditions
    	            	if (nMetaMagic == METAMAGIC_MAXIMIZE)
                	{
                		nDamage = 6 + 4;//Damage is at max
                	}
                	else if (nMetaMagic == METAMAGIC_EMPOWER)
                	{
                		nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                	}    		
		
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);  // Book does not say the tentacles do magical damage.
	        	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    		}
    	
    		// oTarget attempts to break free
    		if( DoGrappleCheckTentacle (oCaster, oTarget) )
    		{
    			SetLocalInt(oTarget, sVar, FALSE);
    		
    			// only stop them for half the round, since breaking a grapple is equivalent to an attack/standard action.
     			DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)/2 ));
 		}
    		else
    		{
    			DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
    		}
    		
    		SetLocalInt(oTarget, sStackVar, 1);
    		DelayCommand(5.8, DeleteLocalInt(oTarget, sStackVar));
    	}

        // Apply Cold Damage regardless of whether or not any tentacles struck the target.... 
        float fDelay  = GetRandomDelay(0.4, 0.8);
        nDamage = d6(2);
        nDamage = ApplyMetamagicVariableMods( nDamage, 2*6 );
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}