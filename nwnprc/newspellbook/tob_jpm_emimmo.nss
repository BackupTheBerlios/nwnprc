#include "tob_inc_tobfunc"

void DoDeath(object oPC)
{
    effect ePara = EffectCutsceneParalyze();
    effect eGhost = EffectCutsceneGhost();
    effect eInvis = EffectEthereal();
    effect eSpell = EffectSpellImmunity(SPELL_ALL_SPELLS);
    effect eDam1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
    effect eDam2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eDam3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
    effect eDam4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100);
    effect eDam5 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
    effect eDam6 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    effect eDam7 = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100);
    effect eDam8 = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eDam9 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eDam10 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100);
    effect eDam11 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eDam12 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eSpell, eDam1);
    eLink = EffectLinkEffects(eLink, eDam2);
    eLink = EffectLinkEffects(eLink, eDam3);
    eLink = EffectLinkEffects(eLink, eDam4);
    eLink = EffectLinkEffects(eLink, eDam5);
    eLink = EffectLinkEffects(eLink, eDam6);
    eLink = EffectLinkEffects(eLink, eDam7);
    eLink = EffectLinkEffects(eLink, eDam8);
    eLink = EffectLinkEffects(eLink, eDam9);
    eLink = EffectLinkEffects(eLink, eDam10);
    eLink = EffectLinkEffects(eLink, eDam11);
    eLink = EffectLinkEffects(eLink, eDam12);
    eLink = EffectLinkEffects(eLink, ePara);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eInvis);

    eLink = SupernaturalEffect(eLink);

	// Apply the effect
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(d6(1)), FALSE);
}

void main()
{
    object oPC     	 = OBJECT_SELF;
    object oTarget 	 = PRCGetSpellTargetObject();
    int nDamage;
    int nClass     	 = GetFirstArcaneClass(oPC);
    int nShape 		 = SHAPE_SPHERE;
    location lTargetArea = PRCGetSpellTargetLocation();
    float fRange 	 = FeetToMeters(20.0);
    
    if(DEBUG) DoDebug("tob_jpm_emimmo: Calculating DC");
    int nDC = 19 + GetAbilityScoreForClass(nClass, oPC);
                  
    int nPenetr = PRCGetCasterLevel(oPC) + SPGetPenetr();
    
    //Get first target in spell area
    oTarget = MyFirstObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
    if(DEBUG) DoDebug("tob_jpm_emimmo: First target is: " + DebugObject2Str(oTarget));

    while(GetIsObjectValid(oTarget))
    {
        if(DEBUG) DoDebug("tob_jpm_emimmo: Is target friendly? " + IntToString(GetIsReactionTypeFriendly(oTarget)));

        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
        {
            if(DEBUG) DoDebug("tob_jpm_emimmo: Target is neutral or hostile");
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, FEAT_JPM_EMERALD_IMMOLATION));

            nDamage = PRCGetReflexAdjustedDamage(d6(20), oTarget, nDC, SAVING_THROW_TYPE_NONE);
            
            if(nDamage > 0)
            {
                //Make SR Check
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))
                {
                    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER) // Are outsiders the only extraplanar?
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        }
                    }
                    float fDelay = GetDistanceBetween(oPC, oTarget)/20;
                    effect eLink = EffectDamage(nDamage/2, DAMAGE_TYPE_FIRE);
                           eLink = EffectLinkEffects(eLink, EffectDamage(nDamage/2, DAMAGE_TYPE_MAGICAL));
                    effect eVis  = EffectVisualEffect(VFX_IMP_FLAME_M);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in spell area
        oTarget = MyNextObjectInShape(nShape, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
        if(DEBUG) DoDebug("tob_jpm_emimmo: Next target is: " + DebugObject2Str(oTarget));
    }
	DoDeath(oPC);
	
       	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), oPC);
}