/*
   ----------------
   Ectoplasmic Shambler, Heartbeat
   
   prc_pow_eshamc
   ----------------

   23/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Long
   Area: Colossal
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You fashion an ephemeral mass of psedu-living ectoplasm called an ectoplasmic shambler. Anything caught within the shambler
   is blinded, and takes 1 point of damage for every 2 manifester levels of the caster.
*/   

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
 ActionDoCommand(SetAllAoEInts(GetSpellId(),OBJECT_SELF, GetManifesterDC(GetAreaOfEffectCreator())));

    //Declare major variables
    int nDam = (GetManifesterLevel(GetAreaOfEffectCreator())/2);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
    effect eBlind = EffectBlindness();
    effect eLink = EffectLinkEffects(eVis, eDam);
    
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {

	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    //Select the next target within the spell shape.
    oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }    
    
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

