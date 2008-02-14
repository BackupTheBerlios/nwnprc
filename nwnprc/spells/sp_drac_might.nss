//::///////////////////////////////////////////////
//:: Name      Draconic Might
//:: FileName  sp_drac_might.nss
//:://////////////////////////////////////////////
/**@file Draconic Might
Transmutation
Level: Paladin 4, sorcerer/wizard 5
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: 1 minute/level (D)
Saving Throw: Fortitude negates
(harmless)
Spell Resistance: Yes (harmless)

The subject of the spell gains a +4
enhancement bonus to Strength, Constitution,
and Charisma. It also gains
a +4 enhancement bonus to natural
armor. Finally, it has immunity to
magic sleep and paralysis effects.
Special: Sorcerers cast this spell at +1
caster level.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nType = MyPRCGetRacialType(oTarget);
        
        if(nType == RACIAL_TYPE_UNDEAD ||
           nType == RACIAL_TYPE_ELEMENTAL ||
           (nType == RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_WARFORGED))
           
           {
                   SendMessageToPC(oPC, "This spell must be cast on a living target");
                   SPSetSchool();
                   return;
           }
        
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        //Determine if we need to adjust nCasterLvl
        int nClass1 = PRCGetClassByPosition(1, oPC);
        int nClass2 = PRCGetClassByPosition(2, oPC);
        int nClass3 = PRCGetClassByPosition(3, oPC);
        
        if(nClass1 == CLASS_TYPE_SORCERER ||
           nClass2 == CLASS_TYPE_SORCERER ||
           nClass3 == CLASS_TYPE_SORCERER)
        {
                //not sure whether we can have 40+ caster levels now...
                nCasterLvl = min(nCasterLvl + 1, 40);
        }
        
        float fDur = TurnsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        if(nMetaMagic == METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }
                
        //Create effect
        effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
               eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_NATURAL_BONUS));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLEEP));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
        
        //VFX
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, SPELL_DRACONIC_MIGHT, nCasterLvl);
        
        SPSetSchool();
}      