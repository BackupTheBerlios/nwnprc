/*
   ----------------
   Tower of Iron Will
   
   prc_pow_twrwll
   ----------------

   23/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: 10 ft
   Area: 10 ft burst centered on caster
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You generate a bastion of thought so strong it offers protection to you and everyone around you, improving the self control of all.
   You and all creatures in the area gain power resistance 19. 
   
   Augment: For every additional power point spent, this power's duration increases by 1 round, 
   and the power resistance it grants is increased by 1
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = OBJECT_SELF;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);      
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	int nPen = GetPsiPenetration(oCaster);
	location lTarget = PRCGetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
	int nSR = 19;
	float fWidth = DoWiden(10.0, nMetaPsi);
	
    	float fDelay;
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nSR += nAugment;
		nDur += nAugment;
	}
	if (nMetaPsi == 2)	nDur *= 2;  
	
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    	effect eSR = EffectSpellResistanceIncrease(nSR);
    	effect eLink = EffectLinkEffects(eSR, eVis);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
	}
    }
}