
#include "prc_alterations"
#include "prc_inc_dragsham"

void main()
{
    object oPC = GetSpellTargetObject();
    object oTarget = GetEnteringObject();
    object PCShaman = GetAreaOfEffectCreator();

    int nAuraBonus;
    int nMarshalBonus;
    int nExtraBonus;
    int nDamageType;

    if         (GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_9, PCShaman))  { nAuraBonus = 9; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_8, PCShaman))  { nAuraBonus = 8; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_7, PCShaman))  { nAuraBonus = 7; }
	else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_6, PCShaman))  { nAuraBonus = 6; }
	else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_5, PCShaman))  { nAuraBonus = 5; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_4, PCShaman))  { nAuraBonus = 4; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_3, PCShaman))  { nAuraBonus = 3; }
	else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_2, PCShaman))  { nAuraBonus = 2; }
	else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_1, PCShaman))  { nAuraBonus = 1; }

    if         (GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_8, PCShaman))  { nMarshalBonus = 8; }
        else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_7, PCShaman))  { nMarshalBonus = 7; }
	else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_6, PCShaman))  { nMarshalBonus = 6; }
	else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_5, PCShaman))  { nMarshalBonus = 5; }
        else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_4, PCShaman))  { nMarshalBonus = 4; }
        else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_3, PCShaman))  { nMarshalBonus = 3; }
	else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_2, PCShaman))  { nMarshalBonus = 2; }
	else if(GetHasFeat(FEAT_MARSHAL_DRACONIC_AURA_LEVEL_1, PCShaman))  { nMarshalBonus = 1; }

    if         (GetHasFeat(FEAT_BONUS_DRACONIC_AURA_LEVEL_4, PCShaman))  { nExtraBonus = 4; }
        else if(GetHasFeat(FEAT_BONUS_DRACONIC_AURA_LEVEL_3, PCShaman))  { nExtraBonus = 3; }
	else if(GetHasFeat(FEAT_BONUS_DRACONIC_AURA_LEVEL_2, PCShaman))  { nExtraBonus = 2; }
	else if(GetHasFeat(FEAT_BONUS_DRACONIC_AURA_LEVEL_1, PCShaman))  { nExtraBonus = 1; }
	

    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
            //Toughness
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_TOUGHNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nAuraBonus, DAMAGE_POWER_PLUS_TWENTY) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamRed, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }

            //Vigor
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_VIGOR, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFastHeal = ExtraordinaryEffect( EffectRegenerate(nAuraBonus, TurnsToSeconds(1)) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFastHeal, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Presence
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_PRESENCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDipInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_PERSUADE, nAuraBonus) );
                 effect eBlfInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_BLUFF, nAuraBonus) );
	         effect eIntInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_INTIMIDATE, nAuraBonus) );
	         effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDipInc, eBlfInc) );
	         eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eIntInc) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Senses
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_SENSES, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eListen = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LISTEN, nAuraBonus) );
	         effect eSpot   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPOT, nAuraBonus) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eListen, eSpot) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Energy Shield
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_ENERGY_SHIELD, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nDamageType = GetDragonDamageType(PCShaman);
                 effect eDmgShld  = ExtraordinaryEffect( EffectDamageShield(2 * nAuraBonus, 0, nDamageType) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgShld, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resistance
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_RESISTANCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nAuraBonus *= 5;
	         int nDamageType = GetDragonDamageType(PCShaman);

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nAuraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Power
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_POWER, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDmgInc = ExtraordinaryEffect( EffectDamageIncrease(nAuraBonus, DAMAGE_TYPE_MAGICAL));
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgInc, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Insight
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_INSIGHT, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eLore        = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LORE, nAuraBonus) );
	         effect eSpellcraft  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPELLCRAFT, nAuraBonus) );
                 effect eLink        = ExtraordinaryEffect( EffectLinkEffects(eLore, eSpellcraft) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Resolve
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_RESOLVE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eConc  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_CONCENTRATION, nAuraBonus) );
	         effect eFear  = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_WILL, nAuraBonus, SAVING_THROW_TYPE_FEAR) );
                 effect eLink  = ExtraordinaryEffect( EffectLinkEffects(eConc, eFear) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Stamina
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_STAMINA, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFort = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_FORT, nAuraBonus) );
	         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Swiftness
            if(GetHasSpellEffect(SPELL_DRACONIC_AURA_SWIFTNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eJump   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_JUMP, nAuraBonus) );
	         effect eSpeed  = ExtraordinaryEffect( EffectMovementSpeedIncrease(nAuraBonus * 5) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eJump, eSpeed) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
              
            /////////////////END SHAMAN, BEGIN MARSHAL/////////////
            
            //Resist Acid
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTACID, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nMarshalBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_ACID;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nMarshalBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Cold
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTCOLD, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nMarshalBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_COLD;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nMarshalBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Electricity
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTELEC, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nMarshalBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_ELECTRICAL;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nMarshalBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Fire
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTFIRE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nMarshalBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_FIRE;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nMarshalBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }            
            //Toughness
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_TOUGHNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nMarshalBonus, DAMAGE_POWER_PLUS_TWENTY) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamRed, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Presence
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_PRESENCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDipInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_PERSUADE, nMarshalBonus) );
                 effect eBlfInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_BLUFF, nMarshalBonus) );
	         effect eIntInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_INTIMIDATE, nMarshalBonus) );
	         effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDipInc, eBlfInc) );
	         eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eIntInc) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Senses
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_SENSES, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eListen = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LISTEN, nMarshalBonus) );
	         effect eSpot   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPOT, nMarshalBonus) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eListen, eSpot) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Insight
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_INSIGHT, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eLore        = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LORE, nMarshalBonus) );
	         effect eSpellcraft  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPELLCRAFT, nMarshalBonus) );
                 effect eLink        = ExtraordinaryEffect( EffectLinkEffects(eLore, eSpellcraft) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Resolve
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESOLVE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eConc  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_CONCENTRATION, nMarshalBonus) );
	         effect eFear  = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_WILL, nMarshalBonus, SAVING_THROW_TYPE_FEAR) );
                 effect eLink  = ExtraordinaryEffect( EffectLinkEffects(eConc, eFear) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Stamina
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_STAMINA, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFort = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_FORT, nMarshalBonus) );
	         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Swiftness
            if(GetHasSpellEffect(SPELL_MARSHAL_AURA_SWIFTNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eJump   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_JUMP, nMarshalBonus) );
	         effect eSpeed  = ExtraordinaryEffect( EffectMovementSpeedIncrease(nMarshalBonus * 5) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eJump, eSpeed) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
              
            /////////////////END MARSHAL, BEGIN EXTRA/////////////
            
            //Resist Acid
            if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTACID, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_ACID;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Cold
            if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTCOLD, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_COLD;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Electricity
            if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTELEC, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_ELECTRICAL;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Resist Fire
            if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTFIRE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraBonus *= 5;
	         int nDamageType = DAMAGE_TYPE_FIRE;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }            
            //Toughness
            if(GetHasSpellEffect(SPELL_BONUS_AURA_TOUGHNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nExtraBonus, DAMAGE_POWER_PLUS_TWENTY) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamRed, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Presence
            if(GetHasSpellEffect(SPELL_BONUS_AURA_PRESENCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDipInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_PERSUADE, nExtraBonus) );
                 effect eBlfInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_BLUFF, nExtraBonus) );
	         effect eIntInc = ExtraordinaryEffect( EffectSkillIncrease(SKILL_INTIMIDATE, nExtraBonus) );
	         effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDipInc, eBlfInc) );
	         eLink   = ExtraordinaryEffect( EffectLinkEffects(eLink, eIntInc) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Senses
            if(GetHasSpellEffect(SPELL_BONUS_AURA_SENSES, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eListen = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LISTEN, nExtraBonus) );
	         effect eSpot   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPOT, nExtraBonus) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eListen, eSpot) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            //Insight
            if(GetHasSpellEffect(SPELL_BONUS_AURA_INSIGHT, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eLore        = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LORE, nExtraBonus) );
	         effect eSpellcraft  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPELLCRAFT, nExtraBonus) );
                 effect eLink        = ExtraordinaryEffect( EffectLinkEffects(eLore, eSpellcraft) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Resolve
            if(GetHasSpellEffect(SPELL_BONUS_AURA_RESOLVE, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eConc  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_CONCENTRATION, nExtraBonus) );
	         effect eFear  = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_WILL, nExtraBonus, SAVING_THROW_TYPE_FEAR) );
                 effect eLink  = ExtraordinaryEffect( EffectLinkEffects(eConc, eFear) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Stamina
            if(GetHasSpellEffect(SPELL_BONUS_AURA_STAMINA, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFort = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_FORT, nExtraBonus) );
	         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
            
            //Swiftness
            if(GetHasSpellEffect(SPELL_BONUS_AURA_SWIFTNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"DraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eJump   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_JUMP, nExtraBonus) );
	         effect eSpeed  = ExtraordinaryEffect( EffectMovementSpeedIncrease(nExtraBonus * 5) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eJump, eSpeed) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"DraconicAura",1);
                 }
              }
    }
}
