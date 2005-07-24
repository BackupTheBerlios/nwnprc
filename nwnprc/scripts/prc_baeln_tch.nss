//::///////////////////////////////////////////////
//:: Name    Baelnorn Touch
//:: FileName   prc_baeln_tch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  Touch attack for Baelnorn.  Thanks to Shane
    Hennesey for allowing me to check out his Lich
    touch script.
*/
//:://////////////////////////////////////////////
//:: Created By: Mike Adams
//:: Created On:
//:://////////////////////////////////////////////

//edited prc_class_const to include Baelnorn
#include "prc_alterations"
#include "prc_class_const"

void main()
{
    //define vars
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;
    int nDamage;
    int nSaveResult;
    int nHD = GetHitDice(oPC);
    int nDC = 10 + nHD/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nType = MyPRCGetRacialType(oTarget);
    int nLevel = GetLevelByClass(CLASS_TYPE_BAELNORN, oPC);
    int nTouch = TouchAttackMelee (oTarget);
    float fDuration;

    //Get touch
    {
        if (nTouch = 1)
            {
            //check for type
            if(nType == RACIAL_TYPE_CONSTRUCT)
                {
                return;
                }
            if(nType == RACIAL_TYPE_UNDEAD)
                {
                return;
                }
            if(nType == RACIAL_TYPE_ELEMENTAL)
                {
                return;
                }
            //Apply effects

            switch(nLevel)
                {
                case 1:
                    nDamage = (5 + d6(1));
                    fDuration = RoundsToSeconds(d4());
                    break;

                case 2:
                    nDamage = (5 +d8(1));
                    fDuration = IntToFloat(d4() * 60);
                    break;

                case 3:
                    nDamage = (5 + d8(1));
                    fDuration = IntToFloat(d4() * 60 * 60);
                    break;

                case 4:
                    nDamage = (5 + d8(1));
                    fDuration =0.0;
                    break;
                }


            effect eVis = EffectVisualEffect(VFX_IMP_HARM);
            if(WillSave(oTarget,nDC,SAVING_THROW_TYPE_NEGATIVE))
                {
                nDamage= nDamage/2;
                }
            effect eDamage = EffectDamage(nDamage);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);

            //Save
            if(FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_MIND_SPELLS))
                {
                return;
                }
            eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
            effect ePar = EffectParalyze();
            ePar = EffectLinkEffects(eVis,ePar);
            ePar = SupernaturalEffect(ePar);
            if (fDuration < 1.0)
                {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePar,oTarget);
                }
            else
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePar,oTarget,fDuration);

            eVis = EffectVisualEffect(VFX_IMP_STUN);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);

            return;
        }
    }
}

