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

/*
PnP TT:
Tenser's Transformation
Transmutation
Level: Sor/Wiz 6
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: You
Duration: 1 round/level
You become a virtual fighting machine—
stronger, tougher, faster, and more skilled
in combat. Your mind-set changes so that
you relish combat and you can’t cast spells,
even from magic items.
You gain 1d6 temporary hit points per
caster level, a +4 natural armor bonus to
AC, a +2d4 Strength enhancement bonus,
a +2d4 Dexterity enhancement bonus, a +1
base attack bonus per two caster levels
(which may give you an extra attack), a +5
competence bonus on Fortitude saves, and
proficiency with all simple and martial
weapons. You attack opponents with
melee or ranged weapons if you can, even
resorting to unarmed attacks if that’s all
you can do.
Material Component: A potion of bull’s
strength, which you drink (and whose
effects are subsumed by the spell effects).
*/
#include "spinc_common"

#include "x2_inc_spellhook"

#include "prc_alterations"
#include "x2_inc_shifter"

#include "pnp_shft_poly"

int CalculateAttackBonus()
{
   int iBAB = GetBaseAttackBonus(OBJECT_SELF);
   int iHD = GetHitDice(OBJECT_SELF);
   int iBonus = (iHD > 20) ? ((20 + (iHD - 19) / 2) - iBAB) : (iHD - iBAB); // most confusing line ever. :)

   return (iBonus > 0) ? iBonus : 0;
}

void PnPTensTransPseudoHB()
{
    if(!GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION))
    {
        //remove IPs for simple + martial weapon prof
        object oSkin = GetPCSkin(OBJECT_SELF);
        int nSimple;
        int nMartial;
        itemproperty ipTest = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(!nSimple
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_SIMPLE)
            {
                RemoveItemProperty(oSkin, ipTest);
                nSimple = TRUE;
            }
            if(!nMartial
                && GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
                && GetItemPropertyDurationType(ipTest) == DURATION_TYPE_TEMPORARY
                && GetItemPropertyCostTableValue(ipTest) == IP_CONST_FEAT_WEAPON_PROF_MARTIAL)
            {
                RemoveItemProperty(oSkin, ipTest);
                nMartial = TRUE;
            }
            ipTest = GetNextItemProperty(oSkin);
        }
        //end the pseudoHB
        return;
    }
    if(GetCurrentAction() != ACTION_ATTACKOBJECT)
    {
        ClearAllActions();
        object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
            REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1,
                CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN_AND_HEARD,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
        if(GetDistanceToObject(oTarget) > 5.0)
        {
            ActionEquipMostDamagingRanged(oTarget);
        }
        else
        {
            int nTwoWeapon;
            if(GetHasFeat(FEAT_AMBIDEXTERITY))
                nTwoWeapon++;
            if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING))
                nTwoWeapon++;
            if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING))
                nTwoWeapon++;
            ActionEquipMostDamagingMelee(oTarget, nTwoWeapon);
        }
        ActionAttack(oTarget);
    }
    DelayCommand(6.0, PnPTensTransPseudoHB());
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if(GetPRCSwitch(PRC_PNP_TENSERS_TRANSFORMATION))
    {

        if (!X2PreSpellCastCode())
        {
            return;
        }

        //Declare major variables
        int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
        float fDuration = RoundsToSeconds(nCasterLvl);
        int nMeta = PRCGetMetaMagicFeat();
        int nHP;
        int nBAB = nCasterLvl / 2;
        int nStr = d4(2);
        int nDex = d4(2);
        int nCon = d4(2);
        object oSkin = GetPCSkin(OBJECT_SELF);

        int nTotalAttacks = (nBAB + GetBaseAttackBonus(OBJECT_SELF)/5)+1;
        if(nTotalAttacks>5)
            nTotalAttacks = 5;
        int nCurrAttacks  = (GetBaseAttackBonus(OBJECT_SELF)/5)+1;
        if(nCurrAttacks>5)
            nCurrAttacks = 5;
        int nAttacks = nTotalAttacks - nCurrAttacks;
        if(nAttacks > 5)
            nAttacks = 5;
        if(nAttacks < 0)
            nAttacks = 0;


        //Determine bonus HP
        nHP += d6(nCasterLvl);

        //Metamagic
        if(nMeta & METAMAGIC_MAXIMIZE)
        {
            nHP = nCasterLvl * 6;
            nStr = 8;
            nDex = 8;
            nCon = 8;
        }
        else if(nMeta & METAMAGIC_EMPOWER)
        {
            nHP += nHP/2;
            nStr += nStr/2;
            nDex += nDex/2;
            nCon += nCon/2;
        }
        else if(nMeta & METAMAGIC_EXTEND)
        {
            fDuration *= 2.0;
        }

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
        effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon);
        effect eBAB = EffectAttackIncrease(nBAB);
        effect eAttacks = EffectModifyAttacks(nAttacks);
        effect eHP = EffectTemporaryHitpoints(nHP); //apply separately
        effect eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eLink;
        eLink = EffectLinkEffects(eStr, eDex);
        eLink = EffectLinkEffects(eLink, eCon);
        eLink = EffectLinkEffects(eLink, eBAB);
        eLink = EffectLinkEffects(eLink, eAttacks);
        eLink = EffectLinkEffects(eLink, eFort);
        itemproperty ipSimple = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
        itemproperty ipMartial = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, fDuration, TRUE, -1, nCasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, TRUE, -1, nCasterLvl);
        //AddItemProperty(DURATION_TYPE_TEMPORARY, ipSimple, oSkin, fDuration);
        //AddItemProperty(DURATION_TYPE_TEMPORARY, ipMartial, oSkin, fDuration);
        IPSafeAddItemProperty(oSkin, ipSimple,  fDuration);
        IPSafeAddItemProperty(oSkin, ipMartial, fDuration);

        DelayCommand(6.0, PnPTensTransPseudoHB());

        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        // Getting rid of the integer used to hold the spells spell school
        return;
    }



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
    int nDuration = CasterLvl;
    int nMeta = PRCGetMetaMagicFeat();
    int nHP, nCnt;

    //Determine bonus HP
    for(nCnt; nCnt <= CasterLvl; nCnt++)
    {
        nHP += d6();
    }

    //Metamagic
    if(nMeta & METAMAGIC_MAXIMIZE)
    {
        nHP = CasterLvl * 6;
    }
    else if(nMeta & METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
    }
    else if(nMeta & METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    // Get The PC's Equipment
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
    object oShieldOld = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

    if (GetBaseItemType(oShieldOld) != BASE_ITEM_SMALLSHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_LARGESHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_TOWERSHIELD)
    {
        oShieldOld = OBJECT_INVALID;
    }

    //Declare effects
    effect eAttack = EffectAttackIncrease(CalculateAttackBonus());
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSwing = EffectModifyAttacks(2);
    effect ePoly = EffectPolymorph(28);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, ePoly);

    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(OBJECT_SELF);

    ClearAllActions(); // prevents an exploit

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);

    // Get the Polymorphed form's stuff
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    // Tenser's Sword is overpowerful with equipment merging -- no longer do you
    // need a +3 flaming longsword if you have reasonably good equipment.
    itemproperty ip = GetFirstItemProperty(oWeaponNew);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeaponNew, ip);
        ip = GetNextItemProperty(oWeaponNew);
    }

    // I like that nice flaming effect though.
    itemproperty ipFlaming = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
    IPSafeAddItemProperty(oWeaponNew, ipFlaming);

    // Merges in your stuff so that you're not weakened by the morph.
    IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNew, TRUE);
    IPWildShapeCopyItemProperties(oArmorOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oShieldOld, oArmorNew, TRUE);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
