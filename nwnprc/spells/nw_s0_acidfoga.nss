//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://///////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eSlow = EffectMovementSpeedDecrease(50);
    object oTarget = GetEnteringObject();
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
        //Spell resistance check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
        {
            //Roll Damage
            //Enter Metamagic conditions
            nDamage = d6(2);
            if ((nMetaMagic & METAMAGIC_MAXIMIZE))
            {
                nDamage = 12;//Damage is at max
            }
            else if ((nMetaMagic & METAMAGIC_EMPOWER))
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }
            nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                //slowing effect
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget,0.0f,FALSE);
                // * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
            }

            //Set Damage Effect with the modified damage
            eDam = PRCEffectDamage(oTarget, nDamage, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_ACID));
            //Apply damage and visuals
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            PRCBonusDamage(oTarget);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
