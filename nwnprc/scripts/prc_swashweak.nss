#include "prc_feat_const"

void main()
{
   if (GetIsImmune(GetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT)) return;
   object oWeap=GetSpellCastItem();
   int nThreat = 20;
   int dice=d20();

   if (GetBaseItemType(oWeap)==BASE_ITEM_HANDAXE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_HAND_AXE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_HANDAXE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_BATTLEAXE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_BATTLE_AXE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_BATTLEAXE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_DOUBLEAXE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DOUBLE_AXE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_DOUBLEAXE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_DWARVENWARAXE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_DWAXE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_GREATAXE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_AXE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATAXE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_CLUB)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_CLUB) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_LIGHTFLAIL)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_HEAVYFLAIL)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_HALBERD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_HALBERD) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_HALBERD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_LIGHTHAMMER)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_WARHAMMER)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_WAR_HAMMER) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_WARHAMMER) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_KAMA)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_KAMA) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_KAMA) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_KATANA)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_KATANA) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_KATANA) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_KUKRI)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 3;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_KUKRI) == TRUE)
             {
             nThreat = nThreat - 3;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_KUKRI) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 3;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_DAGGER)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_DAGGER) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_DIREMACE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DIRE_MACE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_DIREMACE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_LIGHTMACE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_MACE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTMACE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_MORNINGSTAR)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_MORNING_STAR) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_MORNINGSTAR) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_RAPIER)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 3;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER) == TRUE)
             {
             nThreat = nThreat - 3;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_RAPIER) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 3;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_SCIMITAR)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 3;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SCIMITAR) == TRUE)
             {
             nThreat = nThreat - 3;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SCIMITAR) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 3;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_SCYTHE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SCYTHE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SCYTHE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_SICKLE)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SICKLE) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SICKLE) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_SHORTSPEAR)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSPEAR) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_QUARTERSTAFF)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_STAFF) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_BASTARDSWORD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_BASTARD_SWORD) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_BASTARDSWORD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_GREATSWORD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATSWORD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_SHORTSWORD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSWORD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_LONGSWORD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_LONGSWORD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_TWOBLADEDSWORD)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 2;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD) == TRUE)
             {
             nThreat = nThreat - 2;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 2;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }
   if (GetBaseItemType(oWeap)==BASE_ITEM_WHIP)
        {
        if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
             {
             nThreat = nThreat - 1;
             }

        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_WHIP) == TRUE)
             {
             nThreat = nThreat - 1;
             }
   
        if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_WHIP) && GetHasFeat(FEAT_KI_CRITICAL))
             {
             nThreat = nThreat - 1;
             }
                           
        if (dice>=nThreat)
             {
             FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
             if (GetHasFeat(WEAKENING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),GetSpellTargetObject());
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_STRENGTH, 2),GetSpellTargetObject());
                 }
             if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),GetSpellTargetObject());
                 }
             }
        }


}
