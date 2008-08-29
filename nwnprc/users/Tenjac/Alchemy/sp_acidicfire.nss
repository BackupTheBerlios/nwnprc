////////////////////////////////////////////////////////////////////
// Acidic Fire
// sp_acidfire.nss
///////////////////////////////////////////////////////////////////

/*
Acidic Fire: The alchemical concoction combines alchemical fire with a strong acid. 
A direct hit with acidic fire deals 1d4 points of acid damage and 1d4 points of fire damage.
Every creature within 5 feet of the point where the acidic fire hits takes 1 point of acid 
damage and 1 point of fire damage from the splash. On the round following a direct hit, the 
target takes an additional 1d4 points of fire damage; this damage can be avoided in the same
way as for alchemist’s fire.

Taken from x0_s3_alchem
*/

void AddFlamingEffectToWeapon(object oTarget, float fDuration)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProptery(oTArget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d4), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}

void main()
{
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    object oMyWeapon;
    int nTarget = GetObjectType(oTarget);
    int nDuration = 4;
    int nCasterLvl = 1;

    if(nTarget == OBJECT_TYPE_ITEM)
    {
        oMyWeapon = oTarget;
        int nItem = IPGetIsMeleeWeapon(oMyWeapon);
        if(nItem == TRUE)
        {
            if(GetIsObjectValid(oMyWeapon))
            {
                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                if (nDuration > 0)
                {
                    // haaaack: store caster level on item for the on hit spell to work properly
                    SetLocalInt(oMyWeapon,"X2_SPELL_CLEVEL_FLAMING_WEAPON",nCasterLvl);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
                    AddFlamingEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
                }
                    return;
            }
        }
        else
        {
            FloatingTextStrRefOnCreature(100944,OBJECT_SELF);
        }
    }
    else if(nTarget == OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE)
    {
        DoGrenade(d4(1),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        DoGrenade(d4(1),1, VFX_IMP_ACID_L, VFX_FNF_GAS_EXPLOSION_ACID, DAMAGE_TYPE_ACID, RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}