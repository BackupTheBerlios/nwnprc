//::///////////////////////////////////////////////
//:: Creeping Doom: Heartbeat
//:: NW_S0_CrpDoomC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature caught in the swarm take an initial
    damage of 1d20, but there after they take
    1d6 per swarm counter on the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_CREEPING_DOOM ,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    object oTarget = GetEnteringObject();
    string sConstant1 = "NW_SPELL_CONSTANT_CREEPING_DOOM1" + ObjectToString(GetAreaOfEffectCreator());
    string sConstant2 = "NW_SPELL_CONSTANT_CREEPING_DOOM2" + ObjectToString(GetAreaOfEffectCreator());
    int nSwarm = GetLocalInt(OBJECT_SELF, sConstant1);
    int nDamCount = GetLocalInt(OBJECT_SELF, sConstant2);
    float fDelay;
    if(nSwarm < 1)
    {
        nSwarm = 1;
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


    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget) && nDamCount < 1000)
    {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            fDelay = GetRandomDelay(1.0, 2.2);
            //------------------------------------------------------------------
            // According to the book, SR Does not count against creeping doom
            //------------------------------------------------------------------
            //Spell resistance check
//            if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
//            {
                SignalEvent(oTarget,EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_CREEPING_DOOM));
                //Roll Damage
                nDamage = d6(nSwarm);
                nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                //Set Damage Effect with the modified damage
                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_PIERCING);
                //Apply damage and visuals
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                nDamCount = nDamCount + nDamage;
//            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
    if(nDamCount >= 1000)
    {
        DestroyObject(OBJECT_SELF, 1.0);
    }
    else
    {
        nSwarm++;
        SetLocalInt(OBJECT_SELF, sConstant1, nSwarm);
        SetLocalInt(OBJECT_SELF, sConstant2, nDamCount);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
