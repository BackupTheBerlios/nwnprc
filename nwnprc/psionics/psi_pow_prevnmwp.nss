/*
   ----------------
   Prevenom Weapon
   
   psi_pow_prevnmwp
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Prevenom Weapon

    Psychometabolism (Creation)
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Instantaneous
    Saving Throw: None and Fortitude negates; see text
    Power Points: 1
    Metapsionics: Twin

    Your weapon is coated in a mild venom.
    On your next successful melee attack, the venom deals 2 points of Constitution damage.
    A target struck by the poison can make a Fortitude save (DC 10 + 1/2 Manifester level +
    key ability modifier) to negate the damage.

    Augment: For every 6 additional power points you spend, this power’s Constitution damage
             increases by 2 points.
*/


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
        object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();

        // Validity check
        if(!GetIsObjectValid(oTarget))
        {
            FloatingTextStrRefOnCreature(83615, oManifester); // Item must be weapon or creature holding a weapon
    		return;
    	}

        struct manifestation manif =
            EvaluateManifestation(oManifester, OBJECT_INVALID,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           2, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                                           METAPSIONIC_TWIN);

        if(manif.bCanManifest)
        {
            effect eVis       = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
            object oPossessor = GetItemPossessor(oTarget);

            /* Apply the VFX to whatever is wielding the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPossessor);

            // Create the damages array if it doesn't already exist
            if(!array_exists(oPossessor, "PRC_Power_PrevenomWeapon_Damages"))
                array_create(oPossessor, "PRC_Power_PrevenomWeapon_Damages");

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Roll the damage here and store it on the weapon
                int nDamage = 2 + (2 * manif.nTimesAugOptUsed_1);
                array_set_int(oPossessor, "PRC_Power_PrevenomWeapon_Damages",
                              array_get_size(oPossessor, "PRC_Power_PrevenomWeapon_Damages"),
                              nDamage
                              );
            }

    	    // Hook to the item's OnHit
    	    AddEventScript(oTarget, EVENT_ITEM_ONHIT, "psi_pow_prevnmwp", TRUE, FALSE);
    	    
    	    // Store the Manifester level for use later
    	    SetLocalInt(oManifester, "PRC_Power_PrevenomWeapon_ManifLevel", manif.nManifesterLevel);    	    

            /* Add the onhit spell to the weapon */
            IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();
        int nDC = 10 
	        + GetLocalInt(oManifester, "PRC_Power_PrevenomWeapon_ManifLevel") / 2
                + GetAbilityModifier(GetAbilityOfClass(GetManifestingClass(oManifester)), oManifester);        

        int nDamage = array_get_int(oManifester, "PRC_Power_PrevenomWeapon_Damages",
                                    array_get_size(oManifester, "PRC_Power_PrevenomWeapon_Damages")
                                    );

        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

	// First check for poison immunity, if not, make a fort save versus spells.
	if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
	   !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oManifester))
	{
	        //Apply the poison effect and VFX impact
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_PERMANENT, TRUE);
	}

        // Remove the damage value from the array
        int nNewSize = array_get_size(oManifester, "PRC_Power_PrevenomWeapon_Damages") - 1;
        if(nNewSize > 0)
            array_shrink(oManifester, "PRC_Power_PrevenomWeapon_Damages", nNewSize);
        else
        {
            array_delete(oManifester, "PRC_Power_PrevenomWeapon_Damages");
            DeleteLocalInt(oManifester, "PRC_Power_PrevenomWeapon_ManifLevel");
        }
    }// end else - Running OnHit
}