//::///////////////////////////////////////////////
//:: Name      Aberrate
//:: FileName  sp_aberrate.nss
//:://////////////////////////////////////////////
/**@file Aberrate 
Transmutation [Evil] 
Level: Sor/Wiz 1 
Components: V, S, Fiend 
Casting Time: 1 action 
Range: Touch
Target: One living creature 
Duration: 10 minutes/level 
Saving Throw: Fortitude negates 
Spell Resistance: Yes
 
The caster transforms one creature into an aberration.
The subject's form twists and mutates into a hideous 
mockery of itself. The subject's type changes to 
aberration, and it gains a +1 natural armor bonus to 
AC (due to the toughening and twisting of the flesh) 
for every four levels the caster has, up to a maximum
of +5.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{   
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oSkin = GetPCSkin(oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = (600.0f * nCasterLvl);
    int bFriendly = TRUE;
    int nDC = SPGetSpellSaveDC(oTarget, oPC);
    if(oPC == oTarget) bFriendly = FALSE;
    
    
    //spellhook
    if(!X2PreSpellCastCode()) return;
    
    SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    
    //Signal spell firing 
    SPRaiseSpellCastAt(oTarget, bFriendly, SPELL_ABERRATE, oPC);
    
    //if friendly
    if(GetIsReactionTypeFriendly(oTarget, oPC) || 
    //or failed SR check
    (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr())))
    {
        //if friendly
        if(GetIsReactionTypeFriendly(oTarget, oPC) || 
        //or failed save
        (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL)))
        {
            int nBonus = 1;
            
            if(nCasterLvl > 7) nBonus = 2;
            
            if(nCasterLvl > 11) nBonus = 3;
            
            if(nCasterLvl > 15) nBonus = 4;
            
            if(nCasterLvl > 19) nBonus = 5;
                        
            itemproperty ipRace = PRCItemPropertyBonusFeat(FEAT_ABERRATION);   
            effect eArmor = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
            
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ipRace, oSkin, fDur);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oTarget, fDur);          
        }
    }
    
    SPEvilShift(oPC);
    SPSetSchool();
}
    
    
    