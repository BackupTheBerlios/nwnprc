//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "x2_inc_spellhook"

#include "x2_inc_itemprop"
#include "x2_inc_shifter"

void PolyAndMergeEquipment(float fDur, int iLvl)
{
    // Get The PC's Equipment
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    object oArmsOld   = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);
    
        if (GetIsObjectValid(oShield))
        {
            if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
                GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
                GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
            {
                oShield = OBJECT_INVALID;
            }
        }

    // Polymorph
    effect ePoly = EffectPolymorph(28);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, fDur, TRUE, -1, iLvl);

    // Get the Polymorph's stuff
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    // Buffs you up based on your equipment
    IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);

    IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
    IPWildShapeCopyItemProperties(oShield,oArmorNew);

    IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
    IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
    IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
    IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
    IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
    IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    
    IPWildShapeCopyItemProperties(oArmsOld,oArmorNew);
}

int CalculateAttackBonus()
{
   int iBAB = GetBaseAttackBonus(OBJECT_SELF);
   int iHD = GetHitDice(OBJECT_SELF);
   int iBonus = (iHD > 20) ? ((20 + (iHD - 20) / 2) - iBAB) : (iHD - iBAB); // most confusing line ever. :)
   
   return (iBonus > 0) ? iBonus : 0;
}

int CalculateFortitudeBonus()
{
   int iFort = GetFortitudeSavingThrow(OBJECT_SELF);
   int iHD = GetHitDice(OBJECT_SELF);
   int iBonus = ((iHD / 2 + 2) - iFort); // yep, this is the formula, trust me, look at the tables :)
   
   return (iBonus > 0) ? iBonus : 0;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nHP, nCnt, nDuration;
    nDuration = CasterLvl;
    //Determine bonus HP
    for(nCnt; nCnt <= CasterLvl; nCnt++)
    {
        nHP += d6();
    }

    int nMeta = GetMetaMagicFeat();
    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nHP = CasterLvl * 6;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    //Declare effects
    effect eAttack = EffectAttackIncrease(CalculateAttackBonus());
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, CalculateFortitudeBonus());
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSwing = EffectModifyAttacks(CalcNumberOfAttacks());

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);

    effect eHP = EffectTemporaryHitpoints(nHP);

    //effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
    PolyAndMergeEquipment(RoundsToSeconds(nDuration), CasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
