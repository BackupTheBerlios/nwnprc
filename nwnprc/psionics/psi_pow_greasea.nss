/*
   ----------------
   Ectoplasmic Sheen
   
   prc_all_greasea
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Area: 10' square
   Duration: 1 Round/level
   Saving Throw: Reflex negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a pool of ectoplasm across the floor that inhibits motion and can cause people to slow down.
   This functions as the spell grease.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"


void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
 ActionDoCommand(SetAllAoEInts(SPELL_GREASE,OBJECT_SELF, GetManifesterDC(GetAreaOfEffectCreator())));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eLink = EffectLinkEffects(eVis, eSlow);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
    
    int nCaster = GetManifesterLevel(GetAreaOfEffectCreator());
    int nPen = GetPsiPenetration(GetAreaOfEffectCreator());


    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_GREASE));
               //Spell resistance check
            if(PRCMyResistPower(GetAreaOfEffectCreator(), oTarget, nPen))
            {
                //Apply reduced movement effect and VFX_Impact
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
