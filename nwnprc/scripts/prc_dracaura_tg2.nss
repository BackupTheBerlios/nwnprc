
#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(154));
     int nCurrentAura = GetLocalInt(oPC, "DraconicAura2");
     int nOtherAura = GetLocalInt(oPC, "DraconicAura1");
                  
     if(nCurrentAura == 0)
     { 
     	if((GetSpellId() == SPELL_SECOND_AURA_PRESENCE && nOtherAura == SPELL_DRACONIC_AURA_PRESENCE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_VIGOR && nOtherAura == SPELL_DRACONIC_AURA_VIGOR)
     	   || (GetSpellId() == SPELL_SECOND_AURA_TOUGHNESS && nOtherAura == SPELL_DRACONIC_AURA_TOUGHNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_ENERGY_SHIELD && nOtherAura == SPELL_DRACONIC_AURA_ENERGY_SHIELD)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_DRACONIC_AURA_RESISTANCE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_POWER && nOtherAura == SPELL_DRACONIC_AURA_POWER)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SENSES && nOtherAura == SPELL_DRACONIC_AURA_SENSES)
     	   || (GetSpellId() == SPELL_SECOND_AURA_INSIGHT && nOtherAura == SPELL_DRACONIC_AURA_INSIGHT)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESOLVE && nOtherAura == SPELL_DRACONIC_AURA_RESOLVE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_STAMINA && nOtherAura == SPELL_DRACONIC_AURA_STAMINA)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SWIFTNESS && nOtherAura == SPELL_DRACONIC_AURA_SWIFTNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_PRESENCE && nOtherAura == SPELL_MARSHAL_AURA_PRESENCE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_TOUGHNESS && nOtherAura == SPELL_MARSHAL_AURA_TOUGHNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SENSES && nOtherAura == SPELL_MARSHAL_AURA_SENSES)
     	   || (GetSpellId() == SPELL_SECOND_AURA_INSIGHT && nOtherAura == SPELL_MARSHAL_AURA_INSIGHT)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESOLVE && nOtherAura == SPELL_MARSHAL_AURA_RESOLVE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_STAMINA && nOtherAura == SPELL_MARSHAL_AURA_STAMINA)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SWIFTNESS && nOtherAura == SPELL_MARSHAL_AURA_SWIFTNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTACID && nOtherAura == SPELL_MARSHAL_AURA_RESISTACID)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTCOLD && nOtherAura == SPELL_MARSHAL_AURA_RESISTCOLD)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTELEC && nOtherAura == SPELL_MARSHAL_AURA_RESISTELEC)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTFIRE && nOtherAura == SPELL_MARSHAL_AURA_RESISTFIRE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_MARSHAL_AURA_RESISTACID)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_MARSHAL_AURA_RESISTCOLD)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_MARSHAL_AURA_RESISTELEC)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_MARSHAL_AURA_RESISTFIRE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_PRESENCE && nOtherAura == SPELL_BONUS_AURA_PRESENCE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_TOUGHNESS && nOtherAura == SPELL_BONUS_AURA_TOUGHNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SENSES && nOtherAura == SPELL_BONUS_AURA_SENSES)
     	   || (GetSpellId() == SPELL_SECOND_AURA_INSIGHT && nOtherAura == SPELL_BONUS_AURA_INSIGHT)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESOLVE && nOtherAura == SPELL_BONUS_AURA_RESOLVE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_STAMINA && nOtherAura == SPELL_BONUS_AURA_STAMINA)
     	   || (GetSpellId() == SPELL_SECOND_AURA_SWIFTNESS && nOtherAura == SPELL_BONUS_AURA_SWIFTNESS)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTACID && nOtherAura == SPELL_BONUS_AURA_RESISTACID)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTCOLD && nOtherAura == SPELL_BONUS_AURA_RESISTCOLD)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTELEC && nOtherAura == SPELL_BONUS_AURA_RESISTELEC)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTFIRE && nOtherAura == SPELL_BONUS_AURA_RESISTFIRE)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_BONUS_AURA_RESISTACID)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_BONUS_AURA_RESISTCOLD)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_BONUS_AURA_RESISTELEC)
     	   || (GetSpellId() == SPELL_SECOND_AURA_RESISTANCE && nOtherAura == SPELL_BONUS_AURA_RESISTFIRE))
     	     sMes = "That aura is already active.";
     	   
     	else if(TakeSwiftAction(oPC))
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
            sMes = "*Draconic Aura Two Activated*";
            SetLocalInt(oPC, "DraconicAura2", GetSpellId());
        }
     }
     else     
     {
        // Removes effects
        RemoveSpellEffects(nCurrentAura, oPC, oPC);
        sMes = "*Draconic Aura Two Deactivated*";
        DeleteLocalInt(oPC,"SecondDraconicAura");
        DeleteLocalInt(oPC,"DraconicAura2");
        //clear the old aura a second time to ensure it clears
        RemoveSpellEffects(nCurrentAura, oPC, oPC);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}