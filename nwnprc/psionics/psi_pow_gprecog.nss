/*
   ----------------
   Greater Precognition
   
   prc_pow_gprecog
   ----------------

   15/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 6
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
Precognition allows your mind to glimpse fragments of potential future events - what you see will probably happen if no one takes 
action to change it. However, your vision is incomplete, and it makes no real sense until the actual events you glimpsed begin to 
unfold. That’s when everything begins to come together, and you can act, if you act swiftly, on the information you previously 
received when you manifested this power.

In practice, manifesting this power grants you a precognitive edge. Normally, you can have only a single precognitive edge at one 
time. You must use your edge within a period of no more than 10 minutes per level, at which time your preknowledge fades and you 
lose your edge.

You can use your precognitive edge in a variety of ways. Essentially, the edge translates into a +4 insight bonus that you can 
apply at any time to either an attack roll, a damage roll, a saving throw, or a skill check. To apply this bonus for one round, 
press either the Attack, Save, Skill, or Damage option on the radial menu.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);         
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;     	
	
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	
	SetLocalInt(oTarget, "GreaterPrecognition", TRUE);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
	DelayCommand(HoursToSeconds(nDur), DeleteLocalInt(oTarget, "GreaterPrecognition"));
    }
}