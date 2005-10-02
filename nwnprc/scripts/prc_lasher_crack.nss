//::///////////////////////////////////////////////
//:: Lasher - Crack of Fate/Doom
//:: Copyright (c) 2005
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC

    code "borrowed" from tempest two weapon feats
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: Sept 29, 2005
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "inc_2dacache"
#include "nw_i0_spells"

void main()
{
    object oPC = GetSpellTargetObject();
    string sMessage = "";

    int iClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);
    int nAttacks;
    int nPenalty;


    if(!GetHasSpellEffect(SPELL_LASHER_CRACK, oPC) )
    {
        if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_WHIP)
        {   //apply effects if holding a whip

            nAttacks = ((iClassLevel + 2) / 5);
            nPenalty = nAttacks * 2;

            effect eAttacks = SupernaturalEffect(EffectModifyAttacks(nAttacks));
            effect ePenalty = SupernaturalEffect(EffectAttackDecrease(nPenalty));
            effect eLink = EffectLinkEffects(eAttacks, ePenalty);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
        }
        else
        {
            FloatingTextStringOnCreature("*Invalid Weapon. Ability Not Activated!*", oPC, FALSE);
        }
    }
    else
    {
        // Removes effects, not too sure if I need this bit
        RemoveSpellEffects(SPELL_LASHER_CRACK, oPC, oPC);

    }
}