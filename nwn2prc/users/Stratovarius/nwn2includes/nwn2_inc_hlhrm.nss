//\/////////////////////////////////////////////////////////////////////////////
//
//  nwn2_inc_hlhrm.nss
//
//  Shared functions for the Heal and Harm spells for NWN2
//
//  (c) Obsidian Entertainment Inc., 2005
//
//\/////////////////////////////////////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"    
#include "x0_i0_petrify"


///////////////////////////////////////////////////////////////////////////////
// HealTarget
///////////////////////////////////////////////////////////////////////////////
//
// Created By:	Brock Heinz
// Created On:	08/17/2005
// Description: Heals the target for 10 hit points per level of the caster, 
//              capped at 150. Harm spells cast on Undead should call this 
//              instead of HarmTarget
// 
///////////////////////////////////////////////////////////////////////////////
void HealTarget( object oTarget, object oCaster, int nSpellID )
{
	int 	nCasterLevel 	= GetCasterLevel( oCaster );
	int 	nHealAmt		= ClampInt( 10*nCasterLevel, 0, 250 );
    effect  eHeal 			= EffectHeal( nHealAmt );
	effect 	eVisual;

	if ( nSpellID == SPELL_HEAL ) 	eVisual = EffectVisualEffect(VFX_IMP_HEALING_X);
	else     						eVisual = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_6);

	//Apply the heal effect and the VFX impact
	if ( nSpellID == SPELL_HEAL )
	{
		RemoveEffectOfType( oTarget, EFFECT_TYPE_WOUNDING );
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
}

///////////////////////////////////////////////////////////////////////////////
// HarmTarget
///////////////////////////////////////////////////////////////////////////////
//
// Created By:	Brock Heinz
// Created On:	08/17/2005
// Description: Damages the target for 10 hit points per level of the caster, 
//              capped at 150. Heal spells cast on Undead should call this 
//              instead of HealTarget
// 
///////////////////////////////////////////////////////////////////////////////

void HarmTarget( object oTarget, object oCaster, int nSpellID )
{

	 //Make a touch attack
    if ( TouchAttackMelee(oTarget) != TOUCH_ATTACK_RESULT_MISS )
    {
        //Make SR check
        if ( !MyResistSpell(oCaster, oTarget) )
        {
            // Let the Harming begin!
			int 	nCasterLevel 	= GetCasterLevel( oCaster );
			int 	nDamageAmt		= ClampInt( 10*nCasterLevel, 0, 250 );
			int 	nDamageType;
			effect 	eVisual;
			
			if ( nSpellID == SPELL_HARM ) 		nDamageType = DAMAGE_TYPE_NEGATIVE;
			else     							nDamageType = DAMAGE_TYPE_POSITIVE;
			
			if ( nSpellID == SPELL_HARM ) 	eVisual = EffectVisualEffect( VFX_HIT_SPELL_INFLICT_6 );
			else     						eVisual = EffectVisualEffect( VFX_IMP_HEALING_G );

            //Set damage
            effect 	eDamage = EffectDamage( nDamageAmt, nDamageType );
			
			if ( nSpellID == SPELL_HEAL )
			{
				RemoveEffectOfType( oTarget, EFFECT_TYPE_WOUNDING );
			}

            //Apply damage effect and VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
        }
    }

}