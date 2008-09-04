//////////////////////////////////////////////////////////////
// Weeping Stone
// sp_weepstn.nss
/////////////////////////////////////////////////////////////
/*
Weeping Stone: Created through alchemical processes
that inflict terrible—and sometimes lethal—pain on a
living being, a weeping stone causes anyone touching it to
his or her face to begin to weep and feel great sorrow. Such a
character is considered shaken for 1d6 rounds.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = GetSpellTargetObject();
        int nTouch = PRCDoRangedTouchAttack(oTarget);
        
        if(nTouch)
        {
                //-2 attack, skills, saves, and ability checks
                effect eShaken = EffectLinkEffects(EffectAttackDecrease(2), EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
                       eShaken = EffectLinkEffects(eShaken, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));