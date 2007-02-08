/***************************************************************************************
// This script is designed to allow the dragon shaman to use an aura that gives 
// + bonuses on a variety of things depending on which aura they have active. These 
// auras also give benefits to any party members currently in the group in a 30yd radius.
***************************************************************************************/
// Script designed for PRC for use with the dragon shaman class
// Script written by: Morgoth Marr
// Script writton on: Nov 2006

#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "prc_inc_dragsham"

void RunPersistentAura(object oCaster, int nSpellId)
{		 
    // Verify that the player is still running the same aura
    int nAuraSpellId = GetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE");
    if(nAuraSpellId == nSpellId)
    {
        //Declare major variables, replace with CLASS_TYPE_DRAGON_SHAMAN when available.
        int nLevel      = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
	int nAuraBonus  = 0;
	effect eLink;

        if     (nLevel >= 20)  { nAuraBonus = 5; }
        else if(nLevel >= 15)  { nAuraBonus = 4; }
        else if(nLevel >= 10)  { nAuraBonus = 3; }
	else if(nLevel >= 5)   { nAuraBonus = 2; }
	else                   { nAuraBonus = 1; }
		
	if(nAuraSpellId == 3762) // replace with proper spellId - Damage Reduction
	{
            effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nAuraBonus) );
            effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS) );
        	   eLink   = ExtraordinaryEffect( EffectLinkEffects(eDamRed, eDur) );
	}
        else if(nAuraSpellId == 3761) // replace with proper spellId - Regeneration
	{
	    effect eFastHeal = ExtraordinaryEffect( EffectRegenerate(nAuraBonus, TurnsToSeconds(1)) );
            effect eDur      = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_REGENERATION) );
                   eLink     = ExtraordinaryEffect( EffectLinkEffects(eFastHeal, eDur) );
	}
        else if(nAuraSpellId == 13760) // replace with proper spellId - Conversation skill bonuses
	{
	    effect eDipInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_DIPLOMACY, nAuraBonus) );
            effect eBlfInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_BLUFF, nAuraBonus) );
	    effect eIntInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_INTIMIDATE, nAuraBonus) );
            effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE) );
                   eLink   = ExtraordinaryEffect( EffectLinkEffects(eDipInc, eDur) );
	           eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eBlfInc) );
	           eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eIntInc) );
	}
	else if(nAuraSpellId == 3766) // replace with proper spellid - senses aura
	{
	    effect eListen = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LISTEN, nAuraBonus) );
	    effect eSpot   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPOT, nAuraBonus) );
            effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE) );
                   eLink   = ExtraordinaryEffect( EffectLinkEffects(eListen, eDur) );
                   eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eSpot) );
	}
	else if(nAuraSpellId == 3763) // replace with proper spellId - damage shield
	{
	    nAuraBonus *= 2;
	    int nDamageType = GetDragonDamageType(oCaster);

            effect eDmgShld  = ExtraordinaryEffect( EffectDamageShield(nAuraBonus, 0, nDamageType) );
            effect eDur      = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS) );
                   eLink     = ExtraordinaryEffect( EffectLinkEffects(eDmgShld, eDur) );
	}
        else if(nAuraSpellId == 3764) // replace with proper spellid - damage resist
	{
            nAuraBonus *= 5;
	    int nDamageType = GetDragonDamageType(oCaster);

            effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nAuraBonus) );
            effect eDur      = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_SPELL_ABJURATION) );
                   eLink     = ExtraordinaryEffect( EffectLinkEffects(eResist, eDur) );
	}
	else if(nAuraSpellId == 3765) // replace with proper spellid - power aura
        {
	    effect eDmgInc = ExtraordinaryEffect( EffectDamageIncrease(nAuraBonus, DAMAGE_TYPE_MAGICAL));
            effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_HEROICS) );
                   eLink   = ExtraordinaryEffect( EffectLinkEffects(eDmgInc, eDur) );
	}

        ApplyFriendlyAuraEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
        // Schedule the next ping
        DelayCommand(2.5f, RunPersistentAura(oCaster, nSpellId));
    }
}

void main()
{
    if(StartDragonShamanAura(OBJECT_SELF, GetSpellId()))
    {
	    effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_SPELL_GOOD_AURA) );
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

        DelayCommand(0.1f, RunPersistentAura(OBJECT_SELF, GetSpellId()));
    }
}