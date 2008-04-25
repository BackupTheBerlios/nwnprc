/////////////////////////////////////////////////////////
//  Creeping Cold
//  sp_creep_cold.nss
/////////////////////////////////////////////////////////
/** @file Creeping Cold
Transmutation [Cold]
Level: Druid 2
Components: V, S, F
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 3 rounds
Saving Throw: Fortitude half
Spell Resistance: Yes

Reaching out your hand and making a crushing motion, you turn the subject’s
sweat to ice, creating blisters as the ice forms on and inside the skin.

The subject takes 1d6 cumulative points of cold damage per round (that is, 1d6
on the 1st round, 2d6 on the second, and 3d6 on the third). Only one save is
allowed against the spell; if successful, it halves the damage each round.
Focus: A small glass or pottery vessel worth at least 25 gp filled with ice,
snow, or water.

*/
//////////////////////////////////////////////////////////
//  Tenjac   10/1/07
//////////////////////////////////////////////////////////

#include "prc_inc_spells"

void ColdLoop(object oTarget, int nSave, int nCount, int nMetaMagic);

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD);
        
        if(!PRCDoResistSpell(oTarget, oPC, nCasterLvl + SPGetPenetr()))
        {
                ColdLoop(oTarget, nDC, 1, PRCGetMetaMagicFeat());
        }
        PRCSetSchool();
}

void ColdLoop(object oTarget, int nSave, int nCount, int nMetaMagic)
{
        int nDam = d6(nCount);
        
        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6 * nCount;
        
        //Save for 1/2
        if(nSave) nDam /= 2;
        
        if(nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_COLD), oTarget);
        
        nCount++;
        
        if(nCount < 3)
        {
                DelayCommand(RoundsToSeconds(1), ColdLoop(oTarget, nSave, nCount, nMetaMagic));
        }
}            