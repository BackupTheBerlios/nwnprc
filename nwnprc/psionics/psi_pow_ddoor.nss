/*
   ----------------
   Dimension Door
   
   prc_pow_ddoor
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4
   Range: Long
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You instantly transfer yourself from your current location to any other spot within range.
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
    object oTarget = GetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (!GetLocalInt(oTarget, "DimAnchor"))
    {
    
    if (nMetaPsi > 0) 
    {
    	location lTarget = GetSpellTargetLocation();
    	location lCaster = GetLocation(oCaster);
    	int iLevel       =  GetManifesterLevel(oCaster);
    	int iMaxDis      =  iLevel*6;
    	int iDistance    =  FloatToInt(GetDistanceBetweenLocations(lCaster,lTarget));
    	int iLeftUse = 1;
	
    	location lDest;
    	if (GetIsObjectValid(oTarget)) lDest=GetLocation(oTarget);
    	else lDest=GetSpellTargetLocation();
    	effect eVis=EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    	vector vOrigin=GetPositionFromLocation(GetLocation(oCaster));
    	vector vDest=GetPositionFromLocation(lDest);
	
    	vOrigin=Vector(vOrigin.x+2.0, vOrigin.y-0.2, vOrigin.z);
    	vDest=Vector(vDest.x+2.0, vDest.y-0.2, vDest.z);
	
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
    	DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));
    	DelayCommand(0.8, AssignCommand(oCaster, JumpToLocation(lDest)));
    }
    
    }
}