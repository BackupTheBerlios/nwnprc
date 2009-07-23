#include "prc_inc_spells"
#include "prc_inc_function"

int GetIsSupernaturalCurse(effect eEff)
{
    return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    object oTarget;
    int CasterLvl = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE,OBJECT_SELF,1);
    int nExtraDamage = min(20, CasterLvl);
    int nHeal = d8(1) + nExtraDamage;

    //Warforged are only healed for half, none if they have Improved Fortification
    if(GetRacialType(oTarget) == RACIAL_TYPE_WARFORGED) nHeal /= 2;
    if(GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget)) nHeal = 0;

    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 3162, FALSE));
            effect eBad = GetFirstEffect(oTarget);
            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
            if (GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
                GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                GetEffectType(eBad) == EFFECT_TYPE_POISON ||
                GetEffectType(eBad) == EFFECT_TYPE_SLEEP ||
                GetEffectType(eBad) == EFFECT_TYPE_STUNNED)
                {
                //Remove effect if it is negative.
                if(!GetIsSupernaturalCurse(eBad))
                    RemoveEffect(oTarget, eBad);
                }
            eBad = GetNextEffect(oTarget);
            }
            effect eHeal = EffectHeal(nHeal);
            eHeal = ExtraordinaryEffect(eHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        }
        if(GetIsReactionTypeHostile(oTarget) && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 3162));
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl + SPGetPenetr()))
            {
            // Save for half
                    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget,
                                        14 + GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF),
                                        SAVING_THROW_TYPE_POSITIVE
                                        )
                       )
                    {
                        nHeal /= 2;
                        // Mettle for total avoidance instead
                        if(GetHasMettle(oTarget, SAVING_THROW_WILL))
                            nHeal = 0;
                    }
                effect eDam = PRCEffectDamage(oTarget, nHeal, DAMAGE_TYPE_POSITIVE);
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

