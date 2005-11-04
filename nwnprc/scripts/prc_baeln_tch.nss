//::///////////////////////////////////////////////
//:: Baelnorn Touch
//:: prc_baeln_tch
//:://////////////////////////////////////////////
/**
    Touch attack for Baelnorn.
    1d8 +5 negative damage, will save for half.
    Permanent paralysis, fort save negates.

    DC for both is 10 + 1/2 HD + Charisma modifier


    @author Mike Adams
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    if(DEBUG) DoDebug("prc_baeln_tch running");
    //define vars
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;
    int nDamage;
    int nHD = GetHitDice(oPC);
    int nDC = 10 + nHD/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_BAELNORN, oPC);
    float fDuration;

    // Ignore non-living targets
    int nType = MyPRCGetRacialType(oTarget);
    if(nType == RACIAL_TYPE_CONSTRUCT ||
       nType == RACIAL_TYPE_UNDEAD    ||
       nType == RACIAL_TYPE_ELEMENTAL
       )
    {
        if(DEBUG) DoDebug("prc_baeln_tch: Target was non-living, aborting");
        return;
    }

    // Do the touch attack
    int nTouch = PRCDoMeleeTouchAttack(oTarget, TRUE, oPC);
    if(DEBUG) DoDebug("prc_baeln_tch: Touch attack result: " + IntToString(nTouch));
    if(nTouch)
    {
        // Effect depends on Baelnorn level.
        switch(nLevel)
        {
            case 1:
                nDamage = (5 + d6(1));
                fDuration = RoundsToSeconds(d4());
                break;

            case 2:
                nDamage = (5 + d8(1));
                fDuration = IntToFloat(d4() * 60);
                break;

            case 3:
                nDamage = (5 + d8(1));
                fDuration = IntToFloat(d4() * 60 * 60);
                break;

            case 4:
                nDamage = (5 + d8(1));
                fDuration = 0.0f;
                break;

            default:
                if(DEBUG) DoDebug("prc_baeln_tch: ERROR: Unknown number of class levels: " + IntToString(nLevel));
                return;
        }

        // Save for half damage
        if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            nDamage /= 2;

        if(DEBUG) DoDebug("prc_baeln_tch: Base damage: " + IntToString(nDamage));

        // Apply the damage
        ApplyTouchAttackDamage(oPC, oTarget, nTouch, nDamage, DAMAGE_TYPE_NEGATIVE, TRUE);

        // Some VFX
        effect eVis = EffectVisualEffect(VFX_IMP_HARM);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,oTarget);

        //Save versus paralysis
        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            return;

        if(DEBUG) DoDebug("prc_baeln_tch: Target failed save vs paralysis");

        eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
        effect ePar = EffectParalyze();
        ePar = EffectLinkEffects(eVis, ePar);
        ePar = SupernaturalEffect(ePar);
        if(fDuration <= 0.0f)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePar, oTarget);
        }
        else
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, fDuration);

        eVis = EffectVisualEffect(VFX_IMP_STUN);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
