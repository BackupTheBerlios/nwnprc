//::///////////////////////////////////////////////
//:: Name      Dragon Ally
//:: FileName  sp_drgn_ally.nss
//:://////////////////////////////////////////////
/**@file Dragon Ally
Conjuration (Summoning)
Level: Sor/Wiz 7
Components: V, XP
Casting Time: 1 round
Range: Special (see text)
Effect: One dragon ally (see text)
Duration: 1 minute. + 1 turn/level (Original had no specific duration)
Saving Throw: None
Spell Resistance: No

This spell summons a juvenile red dragon to perform a short task for you.  
The dragon will arrive a minute after hearing the summons.

Special: Sorcerers cast this spell at +1 caster level.

XP Cost: 250

Author:    Fox
Created:   11/16/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"


void SummonDragonAlly(location lLoc, float fDur)
{
    MultisummonPreSummon();
    effect sSummon = EffectSummonCreature("prc_drgnally");
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, sSummon, lLoc, fDur);
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oPC);
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0) nCasterLevel += 1;
    object oArea = GetArea(oPC);
    location lLoc = GetSpellTargetLocation();
    int nAbove = GetIsAreaAboveGround(oArea);
    int nInside = GetIsAreaInterior(oArea);
    int nNatural = GetIsAreaNatural(oArea);
    float fDur = TurnsToSeconds(nCasterLevel);
    int nXP = GetXP(oPC);

    if(nAbove == AREA_ABOVEGROUND && nInside == FALSE)
    {
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
        DelayCommand(60.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc));
        DelayCommand(60.0f, SummonDragonAlly(lLoc, fDur));
        //only pay the cost if cast sucessfully
        SetXP(oPC, nXP - 250);
    }

    SPSetSchool();
}


