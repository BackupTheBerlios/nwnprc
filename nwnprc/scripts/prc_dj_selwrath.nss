//::///////////////////////////////////////////////
//:: Name Selvetarm's Wrath
//:: FileName prc_dj_selwrath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
The Selvetarm's Wrath feat for the Drow Judicator
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_spell_const"

int GetDamageBonusType(object oPC, int nClass);

void main()
{
object oPC   = OBJECT_SELF;
object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

int nSpell   = GetSpellId();
int nClass;
int nBonus   = GetDamageBonusType(oPC, nClass);

//Check if PC has a weapon equipped
if(oItem==OBJECT_INVALID)
    {
    SendMessageToPC(oPC, "You must have a melee weapon equipped to use this feat.");
    //debug
    //SendMessageToPC(oPC, "Step 1 failure");
    return;
    }

if(nSpell==SPELL_SELVETARMS_WRATH)
    {
    if(IPGetIsMeleeWeapon(oItem))
        {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nBonus, DAMAGE_TYPE_NEGATIVE), oPC, 9.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
        }
    else SendMessageToPC(oPC, "You must have a melee weapon equipped to use this feat.");
    }

}

int GetDamageBonusType(object oPC, int nClass)
{
object oPC;
int nClass=GetLevelByClass(CLASS_TYPE_JUDICATOR);
int nBonus;

switch (nClass)
    {
    case 1:
        {
        nBonus=DAMAGE_BONUS_1;
        break;
        }
    case 2:
        {
        nBonus=DAMAGE_BONUS_2;
        break;
        }
    case 3:
        {
        nBonus=DAMAGE_BONUS_3;
        break;
        }
    case 4:
        {
        nBonus=DAMAGE_BONUS_4;
        break;
        }
    case 5:
        {
        nBonus=DAMAGE_BONUS_5;
        break;
        }
    case 6:
        {
        nBonus=DAMAGE_BONUS_6;
        break;
        }
    case 7:
        {
        nBonus=DAMAGE_BONUS_7;
        break;
        }
    case 8:
        {
        nBonus=DAMAGE_BONUS_8;
        break;
        }
    case 9:
        {
        nBonus=DAMAGE_BONUS_9;
        break;
        }
    case 10:
        {
        nBonus=DAMAGE_BONUS_10;
        break;
        }
    }


return nBonus;
}
