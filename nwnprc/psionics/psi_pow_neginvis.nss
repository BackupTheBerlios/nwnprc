/*
   ----------------
   Eradicate Invisibility
   
   prc_all_neginvis
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Area: Colossal burst centered on caster
   Duration: Instantaneous
   Saving Throw: Reflex negates.
   Power Resistance: No
   Power Point Cost: 5
   
   You radiate a psychokinetic burst that disrupts and negates all invisibility in the area.
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
    int nAugCost = 1;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	location lTarget = GetSpellTargetLocation();
    	float fDelay;
		
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
	        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))
	        {
		        
    			if (GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY, oTarget) == TRUE)
    			{
    			    RemoveAnySpellEffects(SPELL_IMPROVED_INVISIBILITY, oTarget);
    			}
    			else
    			if (GetHasSpellEffect(SPELL_INVISIBILITY, oTarget) == TRUE)
    			{
    			    RemoveAnySpellEffects(SPELL_INVISIBILITY, oTarget);
    			}
		
    			effect eInvis = GetFirstEffect(oTarget);

			int bIsImprovedInvis = FALSE;
    			while(GetIsEffectValid(eInvis))
    			{
    			    if (GetEffectType(eInvis) == EFFECT_TYPE_IMPROVEDINVISIBILITY)
    			    {
    		        	bIsImprovedInvis = TRUE;
        		    }
        			//check for invisibility
        			if(GetEffectType(eInvis) == EFFECT_TYPE_INVISIBILITY || bIsImprovedInvis)
        			{
        			    //remove invisibility
        			    RemoveEffect(oTarget, eInvis);
        			    if (bIsImprovedInvis)
        			    {
        			        RemoveSpellEffects(SPELL_IMPROVED_INVISIBILITY, oTarget, oTarget);
        			    }
        			}
        			//Get Next Effect
        			eInvis = GetNextEffect(oTarget);
    			}
               	}		
	}
	//Select the next target within the spell shape.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}