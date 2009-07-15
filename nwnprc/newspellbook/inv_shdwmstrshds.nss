/*
    Warlock epic feat
    Shadowmaster - Shades spells
*/
#include "prc_inc_racial"

#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    int nSpellID = GetSpellId();
    
    if(nSpellID == INVOKE_SHADOWMASTER_SUMMON_SHADOW)
    {
        int nDuration = CasterLvl;
        effect eSummon;
        //Set the summoned undead to the appropriate template based on the caster level
        if (CasterLvl <= 7)
        {
            eSummon = EffectSummonCreature("NW_S_SHADOW",VFX_FNF_SUMMON_UNDEAD);
        }
        else if ((CasterLvl >= 8) && (CasterLvl <= 10))
        {
            eSummon = EffectSummonCreature("NW_S_SHADMASTIF",VFX_FNF_SUMMON_UNDEAD);
        }
        else if ((CasterLvl >= 11) && (CasterLvl <= 14))
        {
            eSummon = EffectSummonCreature("NW_S_SHFIEND",VFX_FNF_SUMMON_UNDEAD); // change later
        }
        else if ((CasterLvl >= 15))
        {
            eSummon = EffectSummonCreature("NW_S_SHADLORD",VFX_FNF_SUMMON_UNDEAD);
        }

        //Apply VFX impact and summon effect
        MultisummonPreSummon();
            float fDuration = HoursToSeconds(nDuration);
            if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
                fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
        //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    }

    if(nSpellID == INVOKE_SHADOWMASTER_CONE_OF_COLD)
    {
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Limit Caster level for the purposes of damage.
    if (CasterLvl > 15)
    {
        CasterLvl = 15;
    }
    
    CasterLvl +=SPGetPenetr();
    
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
     // March 2003. Removed this as part of the reputation pass
     //            if((PRCGetSpellId() == 340 && !GetIsFriend(oTarget)) || PRCGetSpellId() == 25)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay) && (oTarget != OBJECT_SELF))
                {
                    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                    //Detemine damage
                    nDamage = d6(CasterLvl);
                    //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                    //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_COLD);

                    // Apply effects to the currently selected target.
                    effect eCold = PRCEffectDamage(oTarget, nDamage, EleDmg);
                    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                    if(nDamage > 0)
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                        PRCBonusDamage(oTarget);
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    }


    if(nSpellID == INVOKE_SHADOWMASTER_FIREBALL)
    {
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (CasterLvl > 10)
    {
        CasterLvl = 10;
    }
    CasterLvl +=SPGetPenetr();
    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
     {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
                {
                    //Roll damage for each target
                    nDamage = d6(CasterLvl);
                }
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                    {
                //Set the damage effect
                eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        PRCBonusDamage(oTarget);
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    
                 }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     }
    }

    if(nSpellID == INVOKE_SHADOWMASTER_STONESKIN)
    {
        effect eStone;
        effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
        effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink;
        object oTarget = PRCGetSpellTargetObject();
        int nAmount = CasterLvl * 10;
        int nDuration = CasterLvl;
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));
        //Limit the amount protection to 100 points of damage
        if (nAmount > 100)
        {
            nAmount = 100;
        }
        //Define the damage reduction effect
        eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
        //Link the effects
        eLink = EffectLinkEffects(eStone, eVis);
        eLink = EffectLinkEffects(eLink, eDur);

        PRCRemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

        //Apply the linked effects.
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
    }

    if(nSpellID == INVOKE_SHADOWMASTER_WALL_OF_FIRE)
    {
    //Declare Area of Effect object using the appropriate constant
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLFIRE);
    //Get the location where the wall is to be placed.
    location lTarget = GetSpellTargetLocation();
    int nDuration = CasterLvl / 2;
    if(nDuration == 0)
    {
        nDuration = 1;
    }
    //Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    }
}
