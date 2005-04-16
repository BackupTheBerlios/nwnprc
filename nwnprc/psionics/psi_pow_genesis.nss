/*
   ----------------
   Genesis
   
   prc_pow_genesis
   ----------------

   12/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 9
   Range: Close
   Target: Ground
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   You create a finite plane with limited access: a Demiplane. Demiplanes created by this power are very small, very minor planes,
   but they are private. Upon manifesting this power, a portal will appear infront of you that the manifester and all party members
   may use to enter the plane. Once anyone exits the plane, the plane is shut until the next manifesting of this power. Exiting the
   plane will return you to where you cast the portal.
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
	object oFirstTarget = GetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

	if (nMetaPsi > 0)
	{
		// Get the spell target location as opposed to the spell target.
		location lTarget = GetSpellTargetLocation();

		// Note that you cannot cast a mansion inside a mansion so check the area's
		// tag to make sure the caster isn't trying to recurse mansions.
		object aCaster = GetArea(OBJECT_SELF);
		if ("Genesis" != GetTag(GetArea(aCaster)))
		{
			// Apply the ice explosion at the location captured above.
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
	
			// Create the mansion doorway and save the caster on the door so we know who to let in.
			// Only people in the caster's party get to go into the mansion.		
			object oMansion = CreateObject(OBJECT_TYPE_PLACEABLE, "genesisportal", lTarget, TRUE,
				"genesisportal");
			if (GetIsObjectValid(oMansion))
			{
				SetLocalObject(oMansion, "GENESIS_CASTER", OBJECT_SELF);
			}
		}		
	}
}