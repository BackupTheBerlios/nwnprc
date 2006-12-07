/***************************************************************************************
// This script is designed to allow the dragon shaman to use an aura of power that gives 
// + skill bonus on Diplomacy, Bluff and Intimidate rolls. These auras also give their
// benefits to any party members currently in the group.
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
	string sMes = "Damage Reduction running.";
    if(nAuraSpellId == nSpellId)
    {
        //Declare major variables, replace with CLASS_TYPE_DRAGON_SHAMAN when available.
        int nLevel      = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
		int nAuraBonus;

        if(nLevel >= 20)	   { nAuraBonus = 5; }
        else if(nLevel >= 15)  { nAuraBonus = 4; }
        else if(nLevel >= 10)  { nAuraBonus = 3; }
		else if(nLevel >= 5	)  { nAuraBonus = 2; }
		else                   { nAuraBonus = 1; }

        effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nAuraBonus) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDamRed, eDur) );

        ApplyFriendlyAuraEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
        // Schedule the next ping
		FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
        DelayCommand(2.5f, RunPersistentAura(oCaster, nSpellId));
    }
}

void main()
{
    if(StartDragonShamanAura(OBJECT_SELF, GetSpellId()))
    {
	    effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_SPELL_STONESKIN) );
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

        DelayCommand(0.1f, RunPersistentAura(OBJECT_SELF, GetSpellId()));
    }
}