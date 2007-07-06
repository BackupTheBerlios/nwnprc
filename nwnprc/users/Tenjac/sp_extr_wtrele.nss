//::///////////////////////////////////////////////
//:: Name      Extract Water Elemental
//:: FileName  sp_extr_wtrele.nss
//:://////////////////////////////////////////////
/**@file Extract Water Elemental
Transmutation [Water]
Level: Druid 6, sorcerer/wizard 6
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./level)
Target: One living creature
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

This brutal spell causes the targeted
creature to dehydrate horribly as the
moisture in its body is forcibly extracted
through its eyes, nostrils, mouth, and
pores. This deals 1d6 points of damage
per caster level (maximum 20d6), or
half damage on a successful Fortitude
save. If the targeted creature is slain
by this spell, the extracted moisture is
transformed into a water elemental of
a size equal to the slain creature (up to
Huge). The water elemental is under
your control, as if you summoned it,
and disappears after 1 minute.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SummonElemental(object oTarget);

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDam = d6(min(nCasterLevel, 20));
        int nSaveDC = PRCGetSaveDC(oTarget, oPC);
        int nType = MyPRCGetRacialType(oTarget);
       
        if(nType == RACIAL_TYPE_UNDEAD ||
        nType == RACIAL_TYPE_ELEMENTAL ||
        nType == RACIAL_TYPE_CONSTRUCT)
        
        {
               SendMessageToPC(oPC, "This spell must be cast on a living target")
               SPSetSchool();
               return;
        }
       
        if(nMetaMagic == METAMAGIC_MAXIMIZE)
        {
                nDam = 6*(min(nCasterLevel, 20));
        }
        
        if(nMetaMagic == METAMAGIC_EMPOWER)
        {
                nDam += (nDam/2);
        }
        
        //SR check
        if(!MyPRCResistSpell(oPC, oTarget, (nCasterLvl + SPGetPenetr()))
        {
                //VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_WATER), oTarget);
                
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
                {
                        nDam = nDam/2;
                }
                
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
                
                if(GetIsDead(oTarget))
                {
                        SummonElemental(oTarget);
                }
        }
        SPSetSchool();
}

void SummonElemental(object oTarget)
{
        location lLoc = GetLocation(oTarget);
        int nSize = GetCreatureSize(oTarget);
        string sResref;
        
        if(nSize == CREATURE_SIZE_HUGE) sResref = "nw_watergreat"
        
        else if (nSize == CREATURE_SIZE_LARGE) sResref = "nw_waterhuge"
        
        else if (nSize == CREATURE_SIZE_MEDIUM) sResref = "nw_water"
        
        else if (nSize == CREATURE_SIZE_SMALL) sResref = "nw_water"
        
        else if (nSize == CREATURE_SIZE_TINY) sResref = "nw_water"
        
        else
        {
                SendMessageToPC(oPC, "Creature Size Invalid");
                return;
        }
        
        MultisummonPreSummon();
        
        effect eSummon = EffectSummonCreature(sResref, VFX_FNF_SUMMON_EPIC_UNDEAD);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLoc, 60.0f);
}
        
        
        
               
}