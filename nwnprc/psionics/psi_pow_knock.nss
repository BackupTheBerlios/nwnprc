/*
   ----------------
   Psionic Knock	
   
   prc_all_knock
   ----------------

   7//11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you unlock all objects in a large radius. 
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
    
    if (GetCanManifest(oCaster, 0)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);

    	object oTarget;
    	effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	float fDelay;
    	int nResist; 
	
    	while(GetIsObjectValid(oTarget))
    	{
    	    SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
    	    fDelay = GetRandomDelay(0.5, 2.5);
    	    if(!GetPlotFlag(oTarget) && GetLocked(oTarget))
    	    {
    	        nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
    	        if (nResist == 0)
    	        {
    	            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	            AssignCommand(oTarget, ActionUnlockObject(oTarget));
    	        }
    	        else if  (nResist == 1)
    	        {
    	            FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
    	        }
    	    }
    	    oTarget = MyNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}


    }
}