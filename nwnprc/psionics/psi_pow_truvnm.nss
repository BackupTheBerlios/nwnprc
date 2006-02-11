/*
   ----------------
   Truevenom
   
   psi_pow_truvnm
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Truevenom

    Psychometabolism (Creation)
    Level: Psychic warrior 4
    Manifesting Time: 1 Swift action
    Range: Personal
    Target: You
    Duration: Instantaneous
    Saving Throw: None and Fortitude negates; see text
    Power Points: 7
    Metapsionics: Empower, Maximize, Twin

    If you have a claw attack (either from an actual natural weapon or from an
    effect such as claws of the beast), you can use this power to coat your claws in a horrible poison.
    On your next successful melee attack, the poison deals 1d8 points of Constitution damage.
    The poison deals 1d8 points of Constitution damage 1 minute later.
    A target struck by the poison can make a Fortitude save to negate each instance of the damage.
*/

// Used for the DelayCommanded second iteration of poison
void DoPoison(object oTarget, object oCaster, int nDC, int nDam);

#include "spinc_common"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

void main()
{
    // Are we running the manifestation part or the onhit part?
    if(GetRunningEvent() != EVENT_ITEM_ONHIT)
    {
        if (!PsiPrePowerCastCode()){ return; }
        object oManifester = OBJECT_SELF;
        object oTarget     = PRCGetSpellTargetObject();

        struct manifestation manif =
            EvaluateManifestation(oManifester, OBJECT_INVALID,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           2, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                                  );

        if(manif.bCanManifest)
        {
            int nNumberOfDice = 1;
            int nDieSize      = 8;
            int nDamage;
            effect eVis       = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
            
            object oLClaw       = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
            object oRClaw       = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
            object oBite        = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
        
            // Must have claws check
            if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw) || GetIsObjectValid(oBite)))
            {
                // "Target does not posses a claw attack!"
                FloatingTextStrRefOnCreature(16826653, oManifester, FALSE);
                return;
            }

            /* Apply the VFX to the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Create the damages array if it doesn't already exist
            if(!array_exists(oTarget, "PRC_Power_Truevenom_Damages"))
                array_create(oTarget, "PRC_Power_Truevenom_Damages");

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Calculate the damage here and store it on the weapon
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                array_set_int(oTarget, "PRC_Power_Truevenom_Damages",
                              array_get_size(oTarget, "PRC_Power_Truevenom_Damages"),
                              nDamage
                              );
            }

    	    // Hook to the item's OnHit
    	    AddEventScript(oTarget, EVENT_ITEM_ONHIT, "psi_pow_truvnm", TRUE, FALSE);
    	    
    	    // Store the DC for use later
    	    SetLocalInt(oManifester, "PRC_Power_Truevenom_DC", GetManifesterDC(oManifester));

            /* Add the onhit spell to the weapon */
            IPSafeAddItemProperty(oLClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oRClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oBite, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();
        int nDC = GetLocalInt(oManifester, "PRC_Power_Truevenom_DC");

        int nDamage = array_get_int(oManifester, "PRC_Power_Truevenom_Damages",
                                    array_get_size(oManifester, "PRC_Power_Truevenom_Damages")
                                    );

        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

	// Apply poison, then apply again 1 minute later
	DoPoison(oTarget, oManifester, nDC, nDamage);
	DelayCommand(60.0, DoPoison(oTarget, oManifester, nDC, nDamage));

        // Remove the damage value from the array
        int nNewSize = array_get_size(oManifester, "PRC_Power_Truevenom_Damages") - 1;
        if(nNewSize > 0)
            array_shrink(oManifester, "PRC_Power_Truevenom_Damages", nNewSize);
        else
        {
            array_delete(oManifester, "PRC_Power_Truevenom_Damages");
            DeleteLocalInt(oManifester, "PRC_Power_Truevenom_DC");
        }
    }// end else - Running OnHit
}

void DoPoison(object oTarget, object oCaster, int nDC, int nDam)
{
	//Declare major variables
	//effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
	//effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_S), eDamage);

	// First check for poison immunity, if not, make a fort save versus spells.
	if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
	   !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oCaster))
	{
		//Apply the poison effect and VFX impact
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, TRUE);
	}
}