
#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(153));
     int nCurrentAura = GetLocalInt(oPC, "DraconicAura1");
     int nOtherAura = GetLocalInt(oPC, "DraconicAura2");
                  
     if(nCurrentAura == 0)
     { 
     	if((nOtherAura == SPELL_SECOND_AURA_PRESENCE && GetSpellId() == SPELL_DRACONIC_AURA_PRESENCE)
     	   || (nOtherAura == SPELL_SECOND_AURA_VIGOR && GetSpellId() == SPELL_DRACONIC_AURA_VIGOR)
     	   || (nOtherAura == SPELL_SECOND_AURA_TOUGHNESS && GetSpellId() == SPELL_DRACONIC_AURA_TOUGHNESS)
     	   || (nOtherAura == SPELL_SECOND_AURA_ENERGY_SHIELD && GetSpellId() == SPELL_DRACONIC_AURA_ENERGY_SHIELD)
     	   || (nOtherAura == SPELL_SECOND_AURA_RESISTANCE && GetSpellId() == SPELL_DRACONIC_AURA_RESISTANCE)
     	   || (nOtherAura == SPELL_SECOND_AURA_POWER && GetSpellId() == SPELL_DRACONIC_AURA_POWER)
     	   || (nOtherAura == SPELL_SECOND_AURA_SENSES && GetSpellId() == SPELL_DRACONIC_AURA_SENSES)
     	   || (nOtherAura == SPELL_SECOND_AURA_INSIGHT && GetSpellId() == SPELL_DRACONIC_AURA_INSIGHT)
     	   || (nOtherAura == SPELL_SECOND_AURA_RESOLVE && GetSpellId() == SPELL_DRACONIC_AURA_RESOLVE)
     	   || (nOtherAura == SPELL_SECOND_AURA_STAMINA && GetSpellId() == SPELL_DRACONIC_AURA_STAMINA)
     	   || (nOtherAura == SPELL_SECOND_AURA_SWIFTNESS && GetSpellId() == SPELL_DRACONIC_AURA_SWIFTNESS)
     	   || (nOtherAura == SPELL_SECOND_AURA_MAGICPOWER && GetSpellId() == SPELL_DRACONIC_AURA_MAGICPOWER))
     	     sMes = "That aura is already active.";
     	   
     	else if(TakeSwiftAction(oPC))
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
            sMes = "*Draconic Aura Activated*";
            SetLocalInt(oPC, "DraconicAura1", GetSpellId());
        }
        
     }
     else     
     {
        // Removes effects
        RemoveSpellEffects(nCurrentAura, oPC, oPC);
        sMes = "*Draconic Aura Deactivated*";
        DeleteLocalInt(oPC,"DraconicAura");
        DeleteLocalInt(oPC,"DraconicAura1");
        //clear the old aura a second time to ensure it clears
        RemoveSpellEffects(nCurrentAura, oPC, oPC);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}