//::///////////////////////////////////////////////
//:: Name      Eldritch Blast - Normal
//:: FileName  inv_eldtch_blast.nss
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
    int nEssence2 = GetLocalInt(oPC, "BlastEssence2");
    effect eEssence;
    location lTargetArea = PRCGetSpellTargetLocation();
    int nShape;
    int nShapeLevel;
    float fRange;
    
    if(GetSpellId() == INVOKE_ELDRITCH_CONE)
    {
        nShape = SHAPE_SPELLCONE;
        fRange = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC) ? FeetToMeters(120.0) : FeetToMeters(30.0);
        nShapeLevel = 5;
    }
    else if(GetSpellId() == INVOKE_ELDRITCH_LINE)
    {
        nShape = SHAPE_SPELLCYLINDER;
        fRange = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC) ? FeetToMeters(120.0) : FeetToMeters(60.0);
        nShapeLevel = 5;
    }
    else if(GetSpellId() == INVOKE_ELDRITCH_DOOM)
    {
        nShape = SHAPE_SPHERE;
        fRange = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC) ? FeetToMeters(40.0) : FeetToMeters(20.0);
        nShapeLevel = 8;
    }
	
	//calculate DC for essence effects
	int nBlastLvl = min((GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) + 1) / 2, 9);
	if(DEBUG) DoDebug("inv_eldtch_shape: Calculating DC");
	nBlastLvl = max(nShapeLevel, max(max(GetLocalInt(oPC, "EssenceLevel"), GetLocalInt(oPC, "EssenceLevel2")), nBlastLvl));
	int nDC = 10 + nBlastLvl + GetAbilityModifier(ABILITY_CHARISMA);
	if(GetHasFeat(FEAT_LORD_OF_ALL_ESSENCES)) nDC += 2;
	
	int nDmgDice;
	int nDamageType = DAMAGE_TYPE_MAGICAL;
	int nDamageType2 = DAMAGE_TYPE_MAGICAL;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    int nBeamVFX = VFX_BEAM_DISINTEGRATE;
    int nPenetr = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + SPGetPenetr();
    int nAtkBns = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC) ? 2 : 0;
    int nReflexSaveType = SAVING_THROW_TYPE_SPELL;
    effect eDoom = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    
    int iAttackRoll = 0;    //placeholder
    if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) < 13)
        nDmgDice = (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) + 1) / 2;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) < 20)
        nDmgDice = (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) + 7) / 3;
    else
        nDmgDice = 9 + (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) - 20) / 2;
        
    //check for the epic feats
    if(GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_I))
    { 
        int nFeatAmt = 0;
        int bDone = FALSE;
        while(!bDone)
        {   if(nFeatAmt >= 9) 
                bDone = TRUE;
            else if(GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_II + nFeatAmt))
                nFeatAmt++;
            else
                bDone = TRUE;
        }
        nDmgDice += nFeatAmt;
    }
    
    int nDam = d6(nDmgDice);
    
    //Essence effects that modify the blast itself
	if(DEBUG) DoDebug("inv_eldtch_shape: Determining Damage Type");
    if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST) nPenetr += 4;
    else if((nEssence == INVOKE_BRIMSTONE_BLAST && nEssence2 == INVOKE_HELLRIME_BLAST) ||
            (nEssence2 == INVOKE_BRIMSTONE_BLAST && nEssence == INVOKE_HELLRIME_BLAST))
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        nDamageType2 = DAMAGE_TYPE_COLD;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M), EffectVisualEffect(VFX_IMP_FROST_S)); 
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        nReflexSaveType = SAVING_THROW_TYPE_FIRE;
    }
    else if((nEssence == INVOKE_BRIMSTONE_BLAST && nEssence2 == INVOKE_VITRIOLIC_BLAST) ||
            (nEssence2 == INVOKE_BRIMSTONE_BLAST && nEssence == INVOKE_VITRIOLIC_BLAST))
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        nDamageType2 = DAMAGE_TYPE_ACID;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M), EffectVisualEffect(VFX_IMP_ACID_S)); 
        nReflexSaveType = SAVING_THROW_TYPE_ACID;
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    }
    else if((nEssence == INVOKE_BRIMSTONE_BLAST && nEssence2 == INVOKE_UTTERDARK_BLAST) ||
            (nEssence2 == INVOKE_BRIMSTONE_BLAST && nEssence == INVOKE_UTTERDARK_BLAST))
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        nDamageType2 = DAMAGE_TYPE_NEGATIVE;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M), EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY)); 
        nBeamVFX = VFX_BEAM_BLACK;
        nReflexSaveType = SAVING_THROW_TYPE_NEGATIVE;
    }
    else if((nEssence == INVOKE_HELLRIME_BLAST && nEssence2 == INVOKE_VITRIOLIC_BLAST) ||
            (nEssence2 == INVOKE_HELLRIME_BLAST && nEssence == INVOKE_VITRIOLIC_BLAST))
    {
        nDamageType = DAMAGE_TYPE_COLD;
        nDamageType2 = DAMAGE_TYPE_ACID;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FROST_S), EffectVisualEffect(VFX_IMP_ACID_S)); 
        nBeamVFX = VFX_BEAM_COLD;
        nReflexSaveType = SAVING_THROW_TYPE_ACID;
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    }
    else if((nEssence == INVOKE_HELLRIME_BLAST && nEssence2 == INVOKE_UTTERDARK_BLAST) ||
            (nEssence2 == INVOKE_HELLRIME_BLAST && nEssence == INVOKE_UTTERDARK_BLAST))
    {
        nDamageType = DAMAGE_TYPE_COLD;
        nDamageType2 = DAMAGE_TYPE_NEGATIVE;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FROST_S), EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY)); 
        nBeamVFX = VFX_BEAM_BLACK;
        nReflexSaveType = SAVING_THROW_TYPE_NEGATIVE;
    }
    else if((nEssence == INVOKE_VITRIOLIC_BLAST && nEssence2 == INVOKE_UTTERDARK_BLAST) ||
            (nEssence2 == INVOKE_VITRIOLIC_BLAST && nEssence == INVOKE_UTTERDARK_BLAST))
    {
        nDamageType = DAMAGE_TYPE_NEGATIVE;
        nDamageType2 = DAMAGE_TYPE_ACID;
        eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_ACID_S), EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY)); 
        nBeamVFX = VFX_BEAM_BLACK;
        nReflexSaveType = SAVING_THROW_TYPE_NEGATIVE;
    }
    else if(nEssence == INVOKE_BRIMSTONE_BLAST || nEssence2 == INVOKE_BRIMSTONE_BLAST)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        nBeamVFX = VFX_BEAM_FIRE;
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
        nReflexSaveType = SAVING_THROW_TYPE_FIRE;
    }
    else if(nEssence == INVOKE_HELLRIME_BLAST || nEssence2 == INVOKE_HELLRIME_BLAST)
    {
        nDamageType = DAMAGE_TYPE_COLD;
        eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        nBeamVFX = VFX_BEAM_COLD;
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_COLD);
        nReflexSaveType = SAVING_THROW_TYPE_COLD;
    }
    else if(nEssence == INVOKE_VITRIOLIC_BLAST || nEssence2 == INVOKE_VITRIOLIC_BLAST)
    {
        nDamageType = DAMAGE_TYPE_ACID;
        eVis = EffectVisualEffect(VFX_IMP_ACID_S);
        nReflexSaveType = SAVING_THROW_TYPE_ACID;
        eDoom = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    }
    else if(nEssence == INVOKE_UTTERDARK_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST)
    {
        nDamageType = DAMAGE_TYPE_NEGATIVE;
        eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        nBeamVFX = VFX_BEAM_BLACK;
        nReflexSaveType = SAVING_THROW_TYPE_NEGATIVE;
    }
    
    //Get first target in spell area
	if(DEBUG) DoDebug("inv_eldtch_shape: Getting first target");
    oTarget = MyFirstObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	if(DEBUG) DoDebug("inv_eldtch_shape: First target is: " + DebugObject2Str(oTarget));

    while(GetIsObjectValid(oTarget))
    {
        int nDamage = nDam;
        
	    if(DEBUG) DoDebug("inv_eldtch_shape: Checking Target's racial type");
        switch(MyPRCGetRacialType(oTarget))
        {
            case RACIAL_TYPE_OUTSIDER:
                if(nEssence == INVOKE_BANEFUL_BLAST_OUTSIDER || nEssence2 == INVOKE_BANEFUL_BLAST_OUTSIDER)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_UNDEAD:
                if(nEssence == INVOKE_BANEFUL_BLAST_UNDEAD || nEssence2 == INVOKE_BANEFUL_BLAST_UNDEAD)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_ELEMENTAL:
                if(nEssence == INVOKE_BANEFUL_BLAST_ELEMENTAL || nEssence2 == INVOKE_BANEFUL_BLAST_ELEMENTAL)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_CONSTRUCT:
                if(nEssence == INVOKE_BANEFUL_BLAST_CONSTRUCT || nEssence2 == INVOKE_BANEFUL_BLAST_CONSTRUCT)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_PLANT:
                if(nEssence == INVOKE_BANEFUL_BLAST_PLANT || nEssence2 == INVOKE_BANEFUL_BLAST_PLANT)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_ABERRATION:
                if(nEssence == INVOKE_BANEFUL_BLAST_ABBERATION || nEssence2 == INVOKE_BANEFUL_BLAST_ABBERATION)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_DRAGON:
                if(nEssence == INVOKE_BANEFUL_BLAST_DRAGON || nEssence2 == INVOKE_BANEFUL_BLAST_DRAGON)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_SHAPECHANGER:
                if(nEssence == INVOKE_BANEFUL_BLAST_SHAPECHANGER || nEssence2 == INVOKE_BANEFUL_BLAST_SHAPECHANGER)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_GIANT:
                if(nEssence == INVOKE_BANEFUL_BLAST_GIANT || nEssence2 == INVOKE_BANEFUL_BLAST_GIANT)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_FEY:
                if(nEssence == INVOKE_BANEFUL_BLAST_FEY || nEssence2 == INVOKE_BANEFUL_BLAST_FEY)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HUMANOID_MONSTROUS:
                if(nEssence == INVOKE_BANEFUL_BLAST_MONSTEROUS || nEssence2 == INVOKE_BANEFUL_BLAST_MONSTEROUS)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_BEAST:
                if(nEssence == INVOKE_BANEFUL_BLAST_BEAST || nEssence2 == INVOKE_BANEFUL_BLAST_BEAST)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_DWARF:
                if(nEssence == INVOKE_BANEFUL_BLAST_DWARF || nEssence2 == INVOKE_BANEFUL_BLAST_DWARF)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_ELF:
                if(nEssence == INVOKE_BANEFUL_BLAST_ELF || nEssence2 == INVOKE_BANEFUL_BLAST_ELF)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_GNOME:
                if(nEssence == INVOKE_BANEFUL_BLAST_GNOME || nEssence2 == INVOKE_BANEFUL_BLAST_GNOME)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HALFLING:
                if(nEssence == INVOKE_BANEFUL_BLAST_HALFLING || nEssence2 == INVOKE_BANEFUL_BLAST_HALFLING)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HUMANOID_ORC:
                if(nEssence == INVOKE_BANEFUL_BLAST_ORC || nEssence2 == INVOKE_BANEFUL_BLAST_ORC)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HUMAN:
                if(nEssence == INVOKE_BANEFUL_BLAST_HUMAN || nEssence2 == INVOKE_BANEFUL_BLAST_HUMAN)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HUMANOID_GOBLINOID:
                if(nEssence == INVOKE_BANEFUL_BLAST_GOBLINOID || nEssence2 == INVOKE_BANEFUL_BLAST_GOBLINOID)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_HUMANOID_REPTILIAN:
                if(nEssence == INVOKE_BANEFUL_BLAST_REPTILIAN || nEssence2 == INVOKE_BANEFUL_BLAST_REPTILIAN)
                   nDamage += d6(2); break;
            
            case RACIAL_TYPE_VERMIN:
                if(nEssence == INVOKE_BANEFUL_BLAST_VERMIN || nEssence2 == INVOKE_BANEFUL_BLAST_VERMIN)
                   nDamage += d6(2); break;
            
        }
        
        if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && nEssence != INVOKE_HAMMER_BLAST && nEssence2 != INVOKE_HAMMER_BLAST)
            nDamage /= 2;
            
	    if(DEBUG) DoDebug("inv_eldtch_shape: Is target friendly? " + IntToString(GetIsReactionTypeFriendly(oTarget)));
    
        if(!GetIsReactionTypeFriendly(oTarget))
        {
	        if(DEBUG) DoDebug("inv_eldtch_shape: Target is neutral or hostile");
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_ELDRITCH_BLAST));
            float fDelay = GetDistanceBetween(oPC, oTarget)/20;
    
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nReflexSaveType);
            if(nDamage > 0)
            {
                //Make SR Check
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr) && 
                   !(nEssence == INVOKE_VITRIOLIC_BLAST && !nEssence2))
                {
                     // perform ranged touch attack
                     if((nEssence2 == INVOKE_HELLRIME_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST ||
                           nEssence2 == INVOKE_BRIMSTONE_BLAST) &&
                        (nEssence == INVOKE_HELLRIME_BLAST || nEssence == INVOKE_UTTERDARK_BLAST ||
                           nEssence == INVOKE_BRIMSTONE_BLAST))
                     {
                         //Apply the VFX impact and damage effect
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage / 2, nDamageType);
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage / 2, nDamageType2);
                     }
                     else if((nEssence == INVOKE_HELLRIME_BLAST || nEssence == INVOKE_UTTERDARK_BLAST ||
                              nEssence == INVOKE_BRIMSTONE_BLAST) && nEssence2 == INVOKE_VITRIOLIC_BLAST)
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage / 2, nDamageType);
                     else if((nEssence2 == INVOKE_HELLRIME_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST ||
                              nEssence2 == INVOKE_BRIMSTONE_BLAST) && nEssence == INVOKE_VITRIOLIC_BLAST)
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage / 2, nDamageType2);
                     else
                     {
                         //Apply the VFX impact and damage effect
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, nDamageType);
                     }
                     PRCBonusDamage(oTarget);
                     
                     //Apply secondary effects from essence invocations
                     if(nEssence == INVOKE_PENETRATING_BLAST || nEssence2 == INVOKE_PENETRATING_BLAST)
                     {
                         eEssence = EffectSpellResistanceDecrease(5);
                         if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                     }
                     else if((nEssence == INVOKE_HINDERING_BLAST || nEssence2 == INVOKE_HINDERING_BLAST) && PRCGetIsAliveCreature(oTarget))
                     {
                         eEssence = EffectSlow();
                         if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                     }
                     else if(nEssence == INVOKE_BINDING_BLAST || nEssence2 == INVOKE_BINDING_BLAST)
                     {
                         eEssence = EffectStunned();
                         if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                     }
                     else if(nEssence == INVOKE_BEWITCHING_BLAST || nEssence2 == INVOKE_BEWITCHING_BLAST)
                     {
                         eEssence = EffectConfused();
                         if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                     }
                     else if((nEssence == INVOKE_BESHADOWED_BLAST || nEssence2 == INVOKE_BESHADOWED_BLAST) && PRCGetIsAliveCreature(oTarget))
                     {
                         eEssence = EffectBlindness();
                         if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, RoundsToSeconds(1));
                     }
                     else if((nEssence == INVOKE_HELLRIME_BLAST || nEssence2 == INVOKE_HELLRIME_BLAST))
                     {
                         eEssence = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
                         if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(10));
                     }
                     else if(nEssence == INVOKE_UTTERDARK_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST)
                     {
                         eEssence = EffectNegativeLevel(2);
                         if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, HoursToSeconds(1));
                     }
                     else if(nEssence == INVOKE_FRIGHTFUL_BLAST || nEssence2 == INVOKE_FRIGHTFUL_BLAST)
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
                     else if(nEssence == INVOKE_NOXIOUS_BLAST || nEssence2 == INVOKE_NOXIOUS_BLAST)
                     {
                         eEssence = EffectDazed();
                         if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEssence, oTarget, TurnsToSeconds(1));
                     }
                     else if((nEssence == INVOKE_SICKENING_BLAST || nEssence2 == INVOKE_SICKENING_BLAST) && PRCGetIsAliveCreature(oTarget))
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
                     else if((nEssence == INVOKE_BRIMSTONE_BLAST || nEssence2 == INVOKE_BRIMSTONE_BLAST) && !GetLocalInt(oTarget, "BrimstoneFire"))
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
                 if(nEssence == INVOKE_VITRIOLIC_BLAST || nEssence2 == INVOKE_VITRIOLIC_BLAST)
                 {
                     // perform ranged touch attack and apply sneak attack if any exists
                     if(nEssence == INVOKE_HELLRIME_BLAST || nEssence == INVOKE_BRIMSTONE_BLAST ||
                        nEssence == INVOKE_UTTERDARK_BLAST || nEssence2 == INVOKE_HELLRIME_BLAST ||
                        nEssence2 == INVOKE_BRIMSTONE_BLAST || nEssence2 == INVOKE_UTTERDARK_BLAST)
                     {
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage / 2, DAMAGE_TYPE_ACID);
                     }
                     else
                         ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_ACID);
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
	    
            
        //Get next target in spell area
        oTarget = MyNextObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	    if(DEBUG) DoDebug("inv_eldtch_shape: Next target is: " + DebugObject2Str(oTarget));
        
	}
	
	if(nEssence == INVOKE_ELDRITCH_LINE)
    {
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectBeam(nBeamVFX, oPC, BODY_NODE_HAND, FALSE), lTargetArea, 1.0f);
    }
	else if(nEssence == INVOKE_ELDRITCH_LINE)
    {
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDoom, lTargetArea, 1.0f);
    }
	
	if(GetHasFeat(FEAT_ELDRITCH_SCULPTOR) && !GetLocalInt(OBJECT_SELF, "UsingSecondBlast"))
	{
	    SetLocalInt(OBJECT_SELF, "UsingSecondBlast", TRUE);
	    UseInvocation(GetSpellId(), CLASS_TYPE_WARLOCK);
	}
	else if(GetLocalInt(OBJECT_SELF, "UsingSecondBlast"))
	    DeleteLocalInt(OBJECT_SELF, "UsingSecondBlast");
}