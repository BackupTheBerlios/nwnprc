/*
   ----------------
   Form of Doom (THIS IS THE LAST POWER TO BE CODED BEFORE BETA)
   
   psi_pow_formdoom
   ----------------

   13/12/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 6
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
   You wrench from your subconscious a terrifying visage of deadly hunger and become one with it. You are transformed into a 
   nightmarish version of yourself, complete with an ooze-sleek skin coating, lashing tentacles, and a fright-inducing countenance. 
   You effectively gain a +10 bonus on Intimidate. Opponents within 30 feet of you that have fewer Hit Dice or levels than you become
   shaken for 5d6 rounds if they fail a Will save (DC 16 + your Cha modifier). An opponent that succeeds on the saving throw is 
   immune to your frightful presence for 24 hours. Frightful presence is a mind-affecting fear effect. Your horrific form grants you
   a natural armor bonus of +5, damage reduction 5/-, and a +4 bonus to your Strength score. In addition, you gain a 1/3rd increase
   to your land speed as well as a +10 bonus on Jump checks. A nest of violently flailing black tentacles sprout from your hair and
   back. You can make up to four additional attacks with these tentacles in addition to your regular melee attacks. Each tentacle 
   attacks at your highest base attack bonus with a -5 penalty. These tentacles deal 2d8 points of damage plus one-half your 
   Strength bonus on each successful strike.
   
   Augment: For every additional power point spent, the duration increases by 2. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

void TentacleAttack(object oCaster)
{
	// Get the target and make sure he's in melee
    	object oTarget = GetAttackTarget(oCaster);
    	if (GetIsInMeleeRange(oTarget, oCaster))
    	{	// Roll the attack
    		int nAttack = GetAttackRoll(oTarget, oCaster, OBJECT_INVALID);
    		// If the tentacle hits
    		if (nAttack > 0)
    		{	
    			// Do damage and visual effects
    			effect eHit = EffectVisualEffect(VFX_COM_HIT_ACID);
    			int nDamage = d8(2) + (GetAbilityModifier(ABILITY_STRENGTH, oCaster) / 2);
    			// Critical hit, double damage
    			if (nAttack == 2) nDamage += d8(2) + (GetAbilityModifier(ABILITY_STRENGTH, oCaster) / 2);
    			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
    		}
    	}
}

void Tentacles(object oCaster, int nSpell)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpell,oCaster,oCaster))
    {
        return;
    }

    // No need to run the tentacle code if he isnt in combat
    if (GetIsInCombat(oCaster))
    {
    	// Spread the attacks out over a round, there's 4 total
	TentacleAttack(oCaster);
	DelayCommand(1.0, TentacleAttack(oCaster));
	DelayCommand(3.0, TentacleAttack(oCaster));
	DelayCommand(5.0, TentacleAttack(oCaster));
    }

}

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nDur = nCaster;
    	if (nMetaPsi == 2)	nDur *= 2;
    	
    	effect eAC = EffectACIncrease(5, AC_NATURAL_BONUS);
    	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    	effect eSlash = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5);
    	effect ePierce = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5);
    	effect eBludge = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5);
    	effect eJump = EffectSkillIncrease(SKILL_JUMP, 10);
    	effect eIntim = EffectSkillIncrease(SKILL_INTIMIDATE, 10);
    	
    	effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    	effect eVis = EffectVisualEffect(PSI_DUR_SHADOW_BODY);
    	effect eVis2 = EffectVisualEffect(VFX_DUR_TENTACLE);
    	
    	// Frightful Prescence AoE
	effect eAOE = EffectAreaOfEffect(AOE_MOB_FORM_DOOM);
    	
    	effect eLink = EffectLinkEffects(eAC, eStr);
        eLink = EffectLinkEffects(eLink, eSlash);
        eLink = EffectLinkEffects(eLink, ePierce);
        eLink = EffectLinkEffects(eLink, eBludge);
        eLink = EffectLinkEffects(eLink, eJump);
        eLink = EffectLinkEffects(eLink, eIntim);
        eLink = EffectLinkEffects(eLink, eShadow);
        eLink = EffectLinkEffects(eLink, eVis);
        eLink = EffectLinkEffects(eLink, eVis2);
        eLink = EffectLinkEffects(eLink, eAOE);
    	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
    }
}