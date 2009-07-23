#include "prc_inc_spells"
#include "prc_inc_function"

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
    int nDifficultyCondition = (GetIsPC(oTarget) && (GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES));
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
    int nHeal = 0;
    int nExtraDamage = min(15, CasterLvl);
    if(iBlastFaith || nDifficultyCondition)
    {
    nHeal = 24 + nExtraDamage;
    if(nDifficultyCondition && iBlastFaith)
        nHeal += nExtraDamage;      //extra damage on lower difficulties
    }
    else
        nHeal = d8(3) + nExtraDamage;
    if(GetHasFeat(FEAT_AUGMENT_HEALING, OBJECT_SELF))
        nHeal += (6);
    if (GetLevelByClass(CLASS_TYPE_HEALER, OBJECT_SELF))
        nHeal += GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    //Warforged are only healed for half, none if they have Improved Fortification
    if(GetRacialType(oTarget) == RACIAL_TYPE_WARFORGED) nHeal /= 2;
    if(GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget)) nHeal = 0;

    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 35, FALSE));
            effect eHeal = EffectHeal(nHeal);
            eHeal = ExtraordinaryEffect(eHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        }
        if(GetIsReactionTypeHostile(oTarget) && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 35));
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl + SPGetPenetr()))
            {
            // Save for half
                    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget,
                                        13 + GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF),
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

