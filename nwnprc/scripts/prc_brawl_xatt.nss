#include "prc_feat_const"
#include "prc_spell_const"
#include "nw_i0_spells"

void main()
{
    object oCreature = OBJECT_SELF;
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);   
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    int iExtraAttacks = 0;
    int iMonkAttackPenalty = 0;
    int iBrawlerAttacks = GetLocalInt(oCreature, "BrawlerAttacks");
        
    //Monk attack penalty
    if (GetLevelByClass(CLASS_TYPE_MONK, oCreature)) iMonkAttackPenalty = 10;
    
    if (!GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT, oCreature))
    {
        if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_1, oCreature))
        {
            if (!GetIsObjectValid(oRighthand))
            {
                if (!GetIsObjectValid(oLefthand))
                {
                if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_2, oCreature))
                    {
                        iExtraAttacks = 2;
                        FloatingTextStringOnCreature("*Extra unarmed attacks enabled: Two extra attacks per round*", oCreature, FALSE);
                    }
                    else
                    {
                        iExtraAttacks = 1;
                        FloatingTextStringOnCreature("*Extra unarmed attack enabled: One extra attack per round*", oCreature, FALSE);
                    }
                }
                else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Shield equipped*", oCreature, FALSE);
            }
            else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Weapon equipped*", oCreature, FALSE);
        }

        if (!iExtraAttacks) return;
        
	SetLocalInt(oCreature, "BrawlerAttacks", iExtraAttacks);
        
        effect eExtraAttacks = SupernaturalEffect(EffectModifyAttacks(iExtraAttacks));
        effect eMonkAttackPenalty = SupernaturalEffect(EffectAttackDecrease(iMonkAttackPenalty));
        effect eLinked = eExtraAttacks;
       
        if (iMonkAttackPenalty) eLinked = EffectLinkEffects(eExtraAttacks, eMonkAttackPenalty);
        
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinked, oCreature);
    }
    else
    {
        if (GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT))
        {
            RemoveSpellEffects(SPELL_BRAWLER_EXTRA_ATT, oCreature, oCreature);
            if (GetLocalInt(oCreature, "BrawlerAttacks"))
            {
                FloatingTextStringOnCreature("*Extra unarmed attacks disabled*", oCreature, FALSE);
                DeleteLocalInt(oCreature, "BrawlerAttacks");
            }
        }
    }
}
