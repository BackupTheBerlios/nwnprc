//::///////////////////////////////////////////////
//:: Name      Darkflame Arrow
//:: FileName  sp_drkflm_arrow.nss
//:://////////////////////////////////////////////
/**@file Darkflame Arrow
Evocation
Level: Assassin 3, Ranger 3
Components: V, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous; see text
Saving Throw: None
Spell Resistance: Yes

Upon casting this spell, you fire a magical or masterwork
arrow or bolt, engulfing its head in black fire. The arrow deals
normal damage and wreaths the target in black flame that deals an 
extra 2d6 points of damage.

The black flames continue to engulf the victim for 2 more rounds,
dealing 2d6 points of damage each subsequent round, and they cannot
be extinguished (although they can be dispelled). The arrow or bolt 
must be fired during the same round the spell is cast, or the magic 
dissipates and is lost. Creatures with immunity or resistance to fire 
take full damage from the black flames. 

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void Burn(object oTarget, int nCounter, int nCasterLvl);

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eImp = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE)
        effect eBurn = EffectVisualEffect(VFX_DUR_INFERNO);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        
        int nType = GetBaseItemType(oWeapon);
        
        if(nType != BASE_ITEM_LONGBOW && 
           nType != BASE_ITEM_SHORTBOW &&
           nType != BASE_ITEM_LIGHTCROSSBOW && 
           nType != BASE_ITEM_HEAVYCROSSBOW)
        {
                SPSetSchool();
                return;
        }
        
        PerformAttack(oTarget, oPC, eImp);
        
        //if hit
        if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
                Burn(oTarget, 3, nCasterLvl);
        }
        
        SPSetSchool();
        return;
}

void Burn(object oTarget, int nCounter, int nCasterLvl)
{
        if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
        {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_MAGICAL), oTarget);
                nCounter--;
                DelayCommand(RoundsToSeconds(1), Burn(oTarget, nCounter, nCasterLvl));
        }
}
        
        