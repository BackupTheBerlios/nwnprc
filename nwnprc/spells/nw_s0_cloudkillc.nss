//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_CLOUDKILL,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d10();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    object oTarget;
    float fDelay;

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDamage = 10;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    }

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

	object aoeCreator = GetAreaOfEffectCreator();
    int CasterLvl = PRCGetCasterLevel(aoeCreator);
    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);


    //Set damage effect
    eDam = EffectDamage(nDamage, ChangedElementalDamage(aoeCreator, DAMAGE_TYPE_ACID));
    //Get the first object in the persistant AOE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , aoeCreator) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
            if(!MyPRCResistSpell(aoeCreator, oTarget,nPenetr, fDelay))
            {
                //Apply VFX impact and damage
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                PRCBonusDamage(oTarget);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
