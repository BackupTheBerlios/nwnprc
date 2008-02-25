//::///////////////////////////////////////////////
//:: [Charm Person]
//:: [NW_S0_CharmPer.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
/** @file Charm Person
Enchantment (Charm) [Mind-Affecting]
Level: 	        Brd 1, Sor/Wiz 1
Components: 	V, S
Casting Time: 	1 standard action
Range: 	        Close (25 ft. + 5 ft./2 levels)
Target: 	    One humanoid creature
Duration: 	    1 hour/level
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This charm makes a humanoid creature regard you as its trusted
friend and ally (treat the target's attitude as friendly). If 
the creature is currently being threatened or attacked by you 
or your allies, however, it receives a +5 bonus on its saving throw.

The spell does not enable you to control the charmed person as 
if it were an automaton, but it perceives your words and actions 
in the most favorable way. You can try to give the subject 
orders, but you must win an opposed Charisma check to convince it 
to do anything it wouldn’t ordinarily do. (Retries are not 
allowed.) An affected creature never obeys suicidal or obviously 
harmful orders, but it might be convinced that something very 
dangerous is worth doing. Any act by you or your apparent allies 
that threatens the charmed person breaks the spell. You must speak 
the person's language to communicate your commands, or else be good 
at pantomiming. 
*/

//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_PERSON);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    //Link persistant effects
    effect eLink = EffectLinkEffects(eVis, eCharm);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl;
    int nPenetr = nCasterLvl + SPGetPenetr();
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    //Make Metamagic check for extend
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
        //Make SR Check
        if (!PRCMyResistSpell(OBJECT_SELF, oTarget, nPenetr))
        {
            //Verify that the Racial Type is humanoid
            if  ((nRacial == RACIAL_TYPE_DWARF) ||
                (nRacial == RACIAL_TYPE_ELF) ||
                (nRacial == RACIAL_TYPE_GNOME) ||
                (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                (nRacial == RACIAL_TYPE_HALFLING) ||
                (nRacial == RACIAL_TYPE_HUMAN) ||
                (nRacial == RACIAL_TYPE_HALFELF) ||
                (nRacial == RACIAL_TYPE_HALFORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
            {
                //Make a Will Save check
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact and linked effects
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,PRCGetSpellId(),nCasterLvl);
                }
            }
         }
     }
     SPSetSchool();

}
