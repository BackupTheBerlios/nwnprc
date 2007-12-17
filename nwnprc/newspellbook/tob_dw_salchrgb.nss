/*
   ----------------
   Salamander Charge, Heartbeat

   tob_dw_salchrgb.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Salamander Charge

    Desert Wind (Strike) [Fire]
    Level: Swordsage 7
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Full-round action
    Range: Personal
    Target: You
    Duration: Instantaneous, see text

    You spin and tumble about the battlefield, a wall of raging flame marking your steps.
    
    You charge your foe. In the space across which you charge, a wall of fire appears, dealing 6d6 damage to all who enter.
    This wall lasts for 5 rounds.
    This is a supernatural maneuver.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

 ActionDoCommand(SetAllAoEInts(SPELL_WALL_OF_FIRE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    //Capture the first target object in the shape.

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

    int CasterLvl = PRCGetCasterLevel(GetAreaOfEffectCreator());
    
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(),CasterLvl);
    int EleDmg = ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_FIRE);

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
            //Make SR check, and appropriate saving throw(s).
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            {
                //Roll damage.
                nDamage = d6(4);
                //Enter Metamagic conditions
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                   nDamage = 24;//Damage is at max
                }
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                
                nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                
                int nDC = PRCGetSaveDC(oTarget,GetAreaOfEffectCreator());

                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC), SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    eDam = PRCEffectDamage(nDamage, EleDmg);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    PRCBonusDamage(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0,FALSE);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}