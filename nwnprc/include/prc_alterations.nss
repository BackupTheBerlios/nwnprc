//
//   This is the original include file for the PRC Spell Engine.
//
//   Various spells, components and designs within this system have
//   been contributed by many individuals within and without the PRC.
//

// Generic includes
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_racial_const"
#include "prc_misc_const"
#include "inc_fileends"

// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prc_inc_spells"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
#include "prcsp_engine"
#include "prc_inc_racial"
#include "inc_abil_damage"


// Checks if target is a frenzied Bersker with Deathless Frenzy Active
// If so removes imortality flag so that Death Spell can kill them
void DeathlessFrenzyCheck(object oTarget);

const int SAVING_THROW_NONE = 4;

// Added by Oni5115
void DeathlessFrenzyCheck(object oTarget)
{
     if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget) && GetHasFeatEffect(FEAT_FRENZY, oTarget) )
     {
          SetImmortal(oTarget, FALSE);
     }
}

//return a location that PCs will never be able to access
location PRC_GetLimbo()
{
    int i = 0;
    location lLimbo;

    while (1)
    {
        object oLimbo = GetObjectByTag("Limbo", i++);
    
        if (oLimbo == OBJECT_INVALID) {
            PrintString("PRC ERROR: no Limbo area! (did you import the latest PRC .ERF file?)");
            return lLimbo;
        }

        if (GetName(oLimbo) == "Limbo" && GetArea(oLimbo) == OBJECT_INVALID)
        {
            vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
            lLimbo = Location(oLimbo, vLimbo, 0.0f);
        }
    }
    return lLimbo;      //never reached
}

effect EffectShaken()
{
    effect eReturn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    int i;
    eReturn = EffectLinkEffects(eReturn, EffectAttackDecrease(2));
    eReturn = EffectLinkEffects(eReturn, EffectSavingThrowDecrease(SAVING_THROW_ALL,2));
    eReturn = EffectLinkEffects(eReturn, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
    return eReturn;
}


