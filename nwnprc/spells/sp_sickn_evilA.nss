//::///////////////////////////////////////////////
//:: Sicken Evil: On Enter
//:: sp_sickn_evilA.nss
//:: 
//:://////////////////////////////////////////////
/*
    
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac 
//:: Created On: 6/30/06
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oTarget = GetEnteringObject();
        object oPC = GetAreaOfEffectCreator();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        //AoEInts
        ActionDoCommand(SetAllAoEInts(SPELL_SICKEN_EVIL,OBJECT_SELF, GetSpellSaveDC()));
        
        //if valid                     and not caster
        if(GetIsObjectValid(oTarget) && oTarget != oPC)
        {
                if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                {
                        //Spell resistance
                        if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                        {
                                //Sicken
                                effect eLink = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
                                eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
                                eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
                                
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                                
                                //VFX
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);
                        }
                }
        }
}
                                
                                
                        
                        
                