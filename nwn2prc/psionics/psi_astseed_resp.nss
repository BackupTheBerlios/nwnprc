//::///////////////////////////////////////////////
//:: Astral Seed: Respawn
//:: psi_inc_augment
//::///////////////////////////////////////////////
/** @file
    The script triggered when a creature that has
    used Astral Seed dies. If the seed still exists,
    the creature is resurrected and transported to
    it's location.
    The creature then spends a day regrowing it's
    body. Since it cannot really be transported
    to the Astral Plane (in NWN), it spends the
    time invulnerable in stasis.


    @author Ornedan
    @date   Created - 2005.12.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

const float JUMP_DELAY = 2.0f;


void main()
{
    object oPC   = OBJECT_SELF;
    object oSeed = GetLocalObject(oPC, "PRC_AstralSeed_SeedObject");

    // If the seed has gotten in the meantime, the PC remains dead
    if(!GetIsObjectValid(oSeed))
        return;

    // Resurrect the PC
    effect eRes = EffectResurrection();
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, oPC);

    // Schedule jump to the seed's location
    location lSeed = GetLocation(oSeed);
    DelayCommand(JUMP_DELAY, AssignCommand(oPC, JumpToLocation(lSeed)));

    // Make a composite effect that turns the creature invulnerable and inactive
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
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(24), FALSE);

    // Do the level loss
    int nHD = GetHitDice(oPC);
    int nCurrentLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    nHD -= 1;
    int nLevelDown = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = (nCurrentLevel + nLevelDown)/2;
    SetXP(oPC,nNewXP);

    // Destroy the seed object
    DeleteLocalObject(oPC, "PRC_AstralSeed_SeedObject");
    MyDestroyObject(oSeed);

    // Persistant World death hooks
    ExecuteScript("prc_pw_astralseed", oPC);
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oPC))
        SetPersistantLocalInt(oPC, "persist_dead", FALSE);
}
