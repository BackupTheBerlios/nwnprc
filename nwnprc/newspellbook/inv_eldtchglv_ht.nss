//::///////////////////////////////////////////////
//:: Name      Eldritch Blast - Hideous Blow
//:: FileName  inv_hideous_blow.nss
//:://////////////////////////////////////////////

#include "spinc_common"
#include "inv_inc_invfunc"

//internal function for delayed damage
void DoDelayedBlast(object oTarget, int nEssence = INVOKE_BRIMSTONE_BLAST)
{
    int nDamageType = DAMAGE_TYPE_FIRE;
    int nVFX = VFX_IMP_FLAME_M;
    if(nEssence == INVOKE_VITRIOLIC_BLAST) 
    {
        nDamageType = DAMAGE_TYPE_ACID;
        nVFX = VFX_IMP_ACID_S;
    }
    effect eDam = EffectDamage(d6(2), nDamageType);
    effect eVis = EffectVisualEffect(nVFX);
    effect eLink = EffectLinkEffects(eDam, eVis);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    int nEssence = GetLocalInt(oPC, "BlastEssence");
    effect eEssence;
	
	//calculate DC for essence effects
	int nBlastLvl = min((GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2, 9);
	nBlastLvl = max(max(GetLocalInt(oPC, "EssenceLevel"), 2), nBlastLvl);
	int nDC = 10 + nBlastLvl + GetAbilityModifier(ABILITY_CHARISMA);
	
	int nDmgDice;
	int nDamageType = DAMAGE_TYPE_MAGICAL;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    int nBeamVFX = VFX_BEAM_DISINTEGRATE;
    int nPenetr = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + SPGetPenetr();
    
    int iAttackRoll = 0;    //placeholder
    if(GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) < 13)
        nDmgDice = (GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2;
    else
        nDmgDice = (GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 7) / 3;
    int nDam = d6(nDmgDice);
    
    //Essence effects that modify the blast itself
    if(nEssence == INVOKE_PENETRATING_BLAST) nPenetr += 4;
    else if(nEssence == INVOKE_BRIMSTONE_BLAST)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        nBeamVFX = VFX_BEAM_FIRE;
    }
    else if(nEssence == INVOKE_HELLRIME_BLAST)
    {
        nDamageType = DAMAGE_TYPE_COLD;
        eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        nBeamVFX = VFX_BEAM_COLD;
    }
    else if(nEssence == INVOKE_VITRIOLIC_BLAST)
    {
        nDamageType = DAMAGE_TYPE_ACID;
        eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    }
    else if(nEssence == INVOKE_UTTERDARK_BLAST)
    {
        nDamageType = DAMAGE_TYPE_NEGATIVE;
        eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        nBeamVFX = VFX_BEAM_BLACK;
    }
    switch(MyPRCGetRacialType(oTarget))
    {
        case RACIAL_TYPE_OUTSIDER:
            if(nEssence == INVOKE_BANEFUL_BLAST_OUTSIDER)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_UNDEAD:
            if(nEssence == INVOKE_BANEFUL_BLAST_UNDEAD)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_ELEMENTAL:
            if(nEssence == INVOKE_BANEFUL_BLAST_ELEMENTAL)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_CONSTRUCT:
            if(nEssence == INVOKE_BANEFUL_BLAST_CONSTRUCT)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_PLANT:
            if(nEssence == INVOKE_BANEFUL_BLAST_PLANT)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_ABERRATION:
            if(nEssence == INVOKE_BANEFUL_BLAST_ABBERATION)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_DRAGON:
            if(nEssence == INVOKE_BANEFUL_BLAST_DRAGON)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_SHAPECHANGER:
            if(nEssence == INVOKE_BANEFUL_BLAST_SHAPECHANGER)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_GIANT:
            if(nEssence == INVOKE_BANEFUL_BLAST_GIANT)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_FEY:
            if(nEssence == INVOKE_BANEFUL_BLAST_FEY)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
            if(nEssence == INVOKE_BANEFUL_BLAST_MONSTEROUS)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_BEAST:
            if(nEssence == INVOKE_BANEFUL_BLAST_BEAST)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_DWARF:
            if(nEssence == INVOKE_BANEFUL_BLAST_DWARF)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_ELF:
            if(nEssence == INVOKE_BANEFUL_BLAST_ELF)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_GNOME:
            if(nEssence == INVOKE_BANEFUL_BLAST_GNOME)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HALFLING:
            if(nEssence == INVOKE_BANEFUL_BLAST_HALFLING)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HUMANOID_ORC:
            if(nEssence == INVOKE_BANEFUL_BLAST_ORC)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HUMAN:
            if(nEssence == INVOKE_BANEFUL_BLAST_HUMAN)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
            if(nEssence == INVOKE_BANEFUL_BLAST_GOBLINOID)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            if(nEssence == INVOKE_BANEFUL_BLAST_REPTILIAN)
               nDam += d6(2); break;
        
        case RACIAL_TYPE_VERMIN:
            if(nEssence == INVOKE_BANEFUL_BLAST_VERMIN)
               nDam += d6(2); break;
        
    }
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && nEssence != INVOKE_HAMMER_BLAST)
        nDam /= 2;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_ELDRITCH_GLAIVE_ONHIT));

        //Make SR Check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr) && nEssence != INVOKE_VITRIOLIC_BLAST)
        {
             // perform ranged touch attack and apply sneak attack if any exists
             ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDam, nDamageType);
             
             //Apply secondary effects from essence invocations
             if(nEssence == INVOKE_PENETRATING_BLAST)
             {
                 eEssence = EffectSpellResistanceDecrease(5);
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
             }
             else if(nEssence == INVOKE_HINDERING_BLAST && PRCGetIsAliveCreature(oTarget))
             {
                 eEssence = EffectSlow();
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_BINDING_BLAST)
             {
                 eEssence = EffectStunned();
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_BEWITCHING_BLAST)
             {
                 eEssence = EffectConfused();
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_BESHADOWED_BLAST && PRCGetIsAliveCreature(oTarget))
             {
                 eEssence = EffectBlindness();
                 if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_HELLRIME_BLAST)
             {
                 eEssence = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
                 if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(10));
             }
             else if(nEssence == INVOKE_UTTERDARK_BLAST)
             {
                 eEssence = EffectNegativeLevel(2);
                 if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, HoursToSeconds(1));
             }
            else if(nEssence == INVOKE_FRIGHTFUL_BLAST)
            {
                 effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                 effect eFear = EffectFrightened();
                 effect eAttackD = EffectAttackDecrease(2);
                 effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
                 effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
                 effect Skill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
                
                 eEssence = EffectLinkEffects(eDmgD, eDur2);
                 eEssence = EffectLinkEffects(eEssence, eAttackD);
                 eEssence = EffectLinkEffects(eEssence, SaveD);
                 eEssence = EffectLinkEffects(eEssence, eFear);
                 eEssence = EffectLinkEffects(eEssence, Skill);
                     
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_NOXIOUS_BLAST)
             {
                 eEssence = EffectDazed();
                 if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
             }
             else if(nEssence == INVOKE_SICKENING_BLAST && PRCGetIsAliveCreature(oTarget))
             {
                 effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                 effect eAttackD = EffectAttackDecrease(2);
                 effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
                 effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
                 effect Skill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
                    
                 eEssence = EffectLinkEffects(eDmgD, eDur2);
                 eEssence = EffectLinkEffects(eEssence, eAttackD);
                 eEssence = EffectLinkEffects(eEssence, SaveD);
                 eEssence = EffectLinkEffects(eEssence, Skill);
                     
                 if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
             }
             else if(nEssence == INVOKE_BRIMSTONE_BLAST && !GetLocalInt(oTarget, "BrimstoneFire"))
             {
                 if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
                 {
                    SetLocalInt(oTarget, "BrimstoneFire", TRUE);
                    int nDuration = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) / 5;
                    DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oTarget, "BrimstoneFire"));
                    
                    switch(nDuration)
                    {
                        case 8:
                        DelayCommand(RoundsToSeconds(8), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 7:
                        DelayCommand(RoundsToSeconds(7), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 6:
                        DelayCommand(RoundsToSeconds(6), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 5:
                        DelayCommand(RoundsToSeconds(5), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 4:
                        DelayCommand(RoundsToSeconds(4), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 3:
                        DelayCommand(RoundsToSeconds(3), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 2:
                        DelayCommand(RoundsToSeconds(2), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                        case 1:
                        DelayCommand(RoundsToSeconds(1), DoDelayedBlast(oTarget, INVOKE_BRIMSTONE_BLAST));
                    }
                 }
             }
         }
         //Vitriolic ignores SR
         else if(nEssence == INVOKE_VITRIOLIC_BLAST)
         {
             // perform ranged touch attack and apply sneak attack if any exists
             ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDam, nDamageType);
             PRCBonusDamage(oTarget);

             //Apply the VFX impact and damage effect
             SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             
             //Apply secondary effect from essence invocations
             int nDuration = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) / 5;
                    
             switch(nDuration)
             {
                case 8:
                DelayCommand(RoundsToSeconds(8), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 7:
                DelayCommand(RoundsToSeconds(7), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 6:
                DelayCommand(RoundsToSeconds(6), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 5:
                DelayCommand(RoundsToSeconds(5), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 4:
                DelayCommand(RoundsToSeconds(4), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 3:
                DelayCommand(RoundsToSeconds(3), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 2:
                DelayCommand(RoundsToSeconds(2), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
                case 1:
                DelayCommand(RoundsToSeconds(1), DoDelayedBlast(oTarget, INVOKE_VITRIOLIC_BLAST));
            }
         }
                
    }
}