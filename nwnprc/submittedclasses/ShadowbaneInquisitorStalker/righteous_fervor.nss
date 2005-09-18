//::///////////////////////////////////////////////
//:: Knight of the Middle Circle - Combat Sense
//:: prc_kotmc_combat.nss
//:://////////////////////////////////////////////
//:: Applies a temporary AC and Attack bonus vs
//:: monsters of the targets racial type
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 16, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"
#include "prc_alterations"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oTarget = GetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR, oPC);
    int nDur = nClass + 3;
    int nDamage = 1;
    int nAttack = 1;

    //if (GetLocalInt(oPC, "KOTMCCombat") == TRUE) return;
      if (GetLocalInt(oPC, "RighteousFervor") == TRUE) return;

    effect eAttack = EffectAttackIncrease(nAttack, ATTACK_BONUS_MISC);
    effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_DIVINE);

    eAttack = VersusRacialTypeEffect(eAttack, nRace);
    eDamage = VersusRacialTypeEffect(eDamage, nRace);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, RoundsToSeconds(nDur));

    //SetLocalInt(oPC, "KOTMCCombat", TRUE);
      SetLocalInt(oPC, "RighteousFervor", TRUE);
    //DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oPC, "KOTMCCombat"));
      DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oPC, "RighteousFervor"));
}