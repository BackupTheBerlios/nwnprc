//////////////////////////////////////////////////////
// Greater Creeping Cold
// sp_gcreep_cold.nss
//////////////////////////////////////////////////////////
/** @file Creeping Cold, Greater
Transmutation [Cold]
Level: Druid 4
Duration: See text

This spell is the same as creeping cold, but the duration increases by 1 round,
during which the subject takes 4d6 points of cold damage. If you are at least
15th level, the spell lasts for 5 rounds and deals 5d6 points of cold damage.
If you are at least 20th level, the spell lasts for 6 rounds and deals 6d6 points
of cold damage.
*/
//////////////////////////////////////////////////////////
// Tenjac   10/1/07
//////////////////////////////////////////////////////////

#include "prc_inc_spells"

void ColdLoop(object oTarget, int nSave, int nCount, int nStopCount, int nMetaMagic);

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD);
        int nStopCount = 4;
                
        if(nCasterLvl > 14) nStopCount++;
        if(nCasterLvl > 19) nStopCount++;
        
        if(!PRCDoResistSpell(oTarget, oPC, nCasterLvl + SPGetPenetr()))
        {
                ColdLoop(oTarget, nDC, 1, nStopCount, PRCGetMetaMagicFeat());
        }
        PRCSetSchool();
}

void ColdLoop(object oTarget, int nSave, int nCount, int nStopCount, int nMetaMagic)
{
        int nDam = d6(nCount);
        
        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6 * nCount;
        
        //Save for 1/2
        if(nSave)
        {
                nDam /= 2;
        }
        
        if(nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_COLD), oTarget);
                
        if(nCount < nStopCount)
        {      
                nCount++;         
                DelayCommand(RoundsToSeconds(1), ColdLoop(oTarget, nSave, nCount, nStopCount));
        }
}