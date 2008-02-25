/*
    nw_s0_abilbuff.nss

    Ability buffs, ultravision and
        mass versions thereof

    By: Flaming_Sword
    Created: Jul 1, 2006
    Modified: Jul 2, 2006
*/

#include "prc_sp_func"

void StripBuff(object oTarget, int nBuffSpellID, int nMassBuffSpellID)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        int nSpellID = GetEffectSpellId(eEffect);
        if (nBuffSpellID == nSpellID || nMassBuffSpellID == nSpellID)
            RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int bVision = (nSpellID == SPELL_DARKVISION) || (nSpellID == SPELL_MASS_ULTRAVISION);
    int bMass = (nSpellID >= SPELL_MASS_BULLS_STRENGTH) && (nSpellID <= SPELL_MASS_ULTRAVISION);
    effect eVis, eDur;
    int nAbility, nAltSpellID;
    if(bVision)
    {
        eDur = EffectVisualEffect(VFX_DUR_ULTRAVISION);
        eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
    }
    else
    {
        eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        if((nSpellID == SPELL_BULLS_STRENGTH) || (nSpellID == SPELL_MASS_BULLS_STRENGTH))
        {
            nAbility = ABILITY_STRENGTH;
            if(nSpellID == SPELL_BULLS_STRENGTH)
                nAltSpellID = SPELL_MASS_BULLS_STRENGTH;
            else
                nAltSpellID = SPELL_BULLS_STRENGTH;
        }
        else if((nSpellID == SPELL_CATS_GRACE) || (nSpellID == SPELL_MASS_CATS_GRACE))
        {
            nAbility = ABILITY_DEXTERITY;
            if(nSpellID == SPELL_CATS_GRACE)
                nAltSpellID = SPELL_MASS_CATS_GRACE;
            else
                nAltSpellID = SPELL_CATS_GRACE;
        }
        else if((nSpellID == SPELL_BEARS_ENDURANCE) || (nSpellID == SPELL_MASS_ENDURANCE))
        {
            nAbility = ABILITY_CONSTITUTION;
            if(nSpellID == SPELL_BEARS_ENDURANCE)
                nAltSpellID = SPELL_MASS_ENDURANCE;
            else
                nAltSpellID = SPELL_BEARS_ENDURANCE;
        }
        else if((nSpellID == SPELL_EAGLES_SPLENDOR) || (nSpellID == SPELL_MASS_EAGLES_SPLENDOR))
        {
            nAbility = ABILITY_CHARISMA;
            if(nSpellID == SPELL_EAGLES_SPLENDOR)
                nAltSpellID = SPELL_MASS_EAGLES_SPLENDOR;
            else
                nAltSpellID = SPELL_EAGLES_SPLENDOR;
        }
        else if((nSpellID == SPELL_OWLS_WISDOM) || (nSpellID == SPELL_MASS_OWLS_WISDOM))
        {
            nAbility = ABILITY_WISDOM;
            if(nSpellID == SPELL_OWLS_WISDOM)
                nAltSpellID = SPELL_MASS_OWLS_WISDOM;
            else
                nAltSpellID = SPELL_OWLS_WISDOM;
        }
        else if((nSpellID == SPELL_FOXS_CUNNING) || (nSpellID == SPELL_MASS_FOXS_CUNNING))
        {
            nAbility = ABILITY_INTELLIGENCE;
            if(nSpellID == SPELL_FOXS_CUNNING)
                nAltSpellID = SPELL_MASS_FOXS_CUNNING;
            else
                nAltSpellID = SPELL_FOXS_CUNNING;
        }
    }
    float fDuration = HoursToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
    location lTarget;
    if(bMass)
    {
        lTarget = PRCGetSpellTargetLocation();
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    while(GetIsObjectValid(oTarget))
    {
        if((!bMass) || (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)))
        {
            SPRaiseSpellCastAt(oTarget, FALSE);
            //if(bMass) fDelay = GetSpellEffectDelay(lTarget, oTarget);
            int nStatMod = d4() + 1;
            if(nMetaMagic & METAMAGIC_MAXIMIZE) nStatMod = 5;
            if(nMetaMagic & METAMAGIC_EMPOWER) nStatMod += (nStatMod / 2);
            effect eBuff;
            if(bVision)
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectUltravision(), eDur), oTarget, fDuration,TRUE,-1,nCasterLevel);
            else
            {
                StripBuff(oTarget, nSpellID, nAltSpellID);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectAbilityIncrease(nAbility, nStatMod), eDur), oTarget, fDuration,TRUE,-1,nCasterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        if(!bMass) break;
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget && IsTouchSpell(PRCGetSpellId()))
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}