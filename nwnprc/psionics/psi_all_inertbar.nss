/*
   ----------------
   Inertial Barrier
   
   prc_all_inertbar
   ----------------

   28/10/04 by Stratovarius

   Class: Psion (Kineticist), Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You create a skin-tight psychokinetic barrier around you that resists cuts, slashes, stabs and blows.
   This provides 5/- Damage Resistance to all physical damage.
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
    
    if (GetCanManifest(oCaster,0)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	
    	effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    	effect eSlash = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5);
    	effect ePierce = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5);
    	effect eBludge = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5);
	effect eLink = EffectLinkEffects(eSlash, ePierce);
	eLink = EffectLinkEffects(eLink, eBludge);
	eLink = EffectLinkEffects(eLink, eShadow);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (600.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}