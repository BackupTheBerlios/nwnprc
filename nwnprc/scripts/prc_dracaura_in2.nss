//::///////////////////////////////////////////////
//:: Draconic Aura Enter - Secondary Auras
//:: prc_dracaura_ou2.nss
//::///////////////////////////////////////////////
/*
    Handles PCs entering the Aura AoE for secondary
    draconic auras.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 27, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_dragsham"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oTarget = GetEnteringObject();
    object PCShaman = GetAreaOfEffectCreator();

    int nAuraBonus;
    int nShamanBonus;
    int nMarshalBonus;
    int nExtraBonus;
    int nDamageType;



    if         (GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_9, PCShaman))  { nShamanBonus = 9; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_8, PCShaman))  { nShamanBonus = 8; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_7, PCShaman))  { nShamanBonus = 7; }
    else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_6, PCShaman))  { nShamanBonus = 6; }
    else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_5, PCShaman))  { nShamanBonus = 5; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_4, PCShaman))  { nShamanBonus = 4; }
        else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_3, PCShaman))  { nShamanBonus = 3; }
    else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_2, PCShaman))  { nShamanBonus = 2; }
    else if(GetHasFeat(FEAT_DRACONIC_AURA_LEVEL_1, PCShaman))  { nShamanBonus = 1; }

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

    int nExtraAuraBonus = max(nExtraBonus, nMarshalBonus);
    nAuraBonus = max(nExtraAuraBonus, nShamanBonus);

    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
            //Toughness
            if(GetHasSpellEffect(SPELL_SECOND_AURA_TOUGHNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDamRed = ExtraordinaryEffect( EffectDamageReduction(nAuraBonus, DAMAGE_POWER_PLUS_TWENTY) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamRed, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Vigor
            if(GetHasSpellEffect(SPELL_SECOND_AURA_VIGOR, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFastHeal = ExtraordinaryEffect( EffectRegenerate(nShamanBonus, TurnsToSeconds(1)) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFastHeal, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Presence
            if(GetHasSpellEffect(SPELL_SECOND_AURA_PRESENCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
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
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Senses
            if(GetHasSpellEffect(SPELL_SECOND_AURA_SENSES, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eListen = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LISTEN, nAuraBonus) );
             effect eSpot   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPOT, nAuraBonus) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eListen, eSpot) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Energy Shield
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGY_SHIELD, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             nDamageType = GetDragonDamageType(PCShaman);
                 effect eDmgShld  = ExtraordinaryEffect( EffectDamageShield(2 * nShamanBonus, 0, nDamageType) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgShld, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Resistance
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESISTANCE, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nAuraBonus *= 5;
             nDamageType = GetDragonDamageType(PCShaman);

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nShamanBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Power
            if(GetHasSpellEffect(SPELL_SECOND_AURA_POWER, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eDmgInc = ExtraordinaryEffect( EffectDamageIncrease(nShamanBonus, DAMAGE_TYPE_MAGICAL));
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgInc, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Insight
            if(GetHasSpellEffect(SPELL_SECOND_AURA_INSIGHT, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eLore        = ExtraordinaryEffect( EffectSkillIncrease(SKILL_LORE, nAuraBonus) );
             effect eSpellcraft  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_SPELLCRAFT, nAuraBonus) );
                 effect eLink        = ExtraordinaryEffect( EffectLinkEffects(eLore, eSpellcraft) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Resolve
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESOLVE, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eConc  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_CONCENTRATION, nAuraBonus) );
             effect eFear  = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_WILL, nAuraBonus, SAVING_THROW_TYPE_FEAR) );
                 effect eLink  = ExtraordinaryEffect( EffectLinkEffects(eConc, eFear) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Stamina
            if(GetHasSpellEffect(SPELL_SECOND_AURA_STAMINA, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eFort = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_FORT, nAuraBonus) );
             ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Swiftness
            if(GetHasSpellEffect(SPELL_SECOND_AURA_SWIFTNESS, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 effect eJump   = ExtraordinaryEffect( EffectSkillIncrease(SKILL_JUMP, nAuraBonus) );
             effect eSpeed  = ExtraordinaryEffect( EffectMovementSpeedIncrease(nAuraBonus * 5) );
                 effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eJump, eSpeed) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }


            //Resist Acid
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESISTACID, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraAuraBonus *= 5;
             int nDamageType = DAMAGE_TYPE_ACID;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraAuraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Resist Cold
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESISTCOLD, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraAuraBonus *= 5;
             int nDamageType = DAMAGE_TYPE_COLD;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraAuraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Resist Electricity
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESISTELEC, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraAuraBonus *= 5;
             int nDamageType = DAMAGE_TYPE_ELECTRICAL;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraAuraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Resist Fire
            if(GetHasSpellEffect(SPELL_SECOND_AURA_RESISTFIRE, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 nExtraAuraBonus *= 5;
             int nDamageType = DAMAGE_TYPE_FIRE;

                 effect eResist   = ExtraordinaryEffect( EffectDamageResistance(nDamageType, nExtraAuraBonus) );
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist, oTarget);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Magic Power
            if(GetHasSpellEffect(SPELL_SECOND_AURA_MAGICPOWER, PCShaman)
              && (nExtraAuraBonus > GetLocalInt(oTarget,"MagicPowerAura")))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
                 SetLocalInt(oTarget,"MagicPowerAura",nExtraAuraBonus);
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }

            //Energy
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGY, PCShaman))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             nDamageType = GetDragonDamageType(PCShaman);
             switch(nDamageType)
                 {
                case DAMAGE_TYPE_ACID:
                    if(nExtraAuraBonus > GetLocalInt(oTarget,"AcidEnergyAura"))
                        SetLocalInt(oTarget,"AcidEnergyAura",nExtraAuraBonus); break;
                case DAMAGE_TYPE_COLD:
                    if(nExtraAuraBonus > GetLocalInt(oTarget,"ColdEnergyAura"))
                        SetLocalInt(oTarget,"ColdEnergyAura",nExtraAuraBonus); break;
                case DAMAGE_TYPE_ELECTRICAL:
                    if(nExtraAuraBonus > GetLocalInt(oTarget,"ElecEnergyAura"))
                        SetLocalInt(oTarget,"ElecEnergyAura",nExtraAuraBonus); break;
                case DAMAGE_TYPE_FIRE:
                    if(nExtraAuraBonus > GetLocalInt(oTarget,"FireEnergyAura"))
                        SetLocalInt(oTarget,"FireEnergyAura",nExtraAuraBonus); break;
                 }
                 SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Energy - Acid
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGYACID, PCShaman)
              && (nExtraAuraBonus > GetLocalInt(oTarget,"AcidEnergyAura")))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             SetLocalInt(oTarget,"AcidEnergyAura",nExtraAuraBonus);
             SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Energy - Cold
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGYCOLD, PCShaman)
              && (nExtraAuraBonus > GetLocalInt(oTarget,"ColdEnergyAura")))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             SetLocalInt(oTarget,"ColdEnergyAura",nExtraAuraBonus);
             SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Energy - Electric
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGYELEC, PCShaman)
              && (nExtraAuraBonus > GetLocalInt(oTarget,"ElecEnergyAura")))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             SetLocalInt(oTarget,"ElecEnergyAura",nExtraAuraBonus);
             SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
            //Energy - Fire
            if(GetHasSpellEffect(SPELL_SECOND_AURA_ENERGYFIRE, PCShaman)
              && (nExtraAuraBonus > GetLocalInt(oTarget,"FireEnergyAura")))
              {
              if (GetLocalInt(oTarget,"SecondDraconicAura")>0)
                 {
                 return;
                 }
              else
                 {
             SetLocalInt(oTarget,"FireEnergyAura",nExtraAuraBonus);
             SetLocalInt(PCShaman,"SecondDraconicAura",1);
                 }
              }
    }
}
