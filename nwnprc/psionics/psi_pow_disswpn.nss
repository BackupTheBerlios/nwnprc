//:://////////////////////////////////////////////
//:: Power: Dissolving Weapon
//:: psi_pow_disswpn
//:://////////////////////////////////////////////
/** @file

    Dissolving Weapon

    Psychometabolism [Acid]
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    Your weapon is corrosive, and sizzling moisture visibly oozes from it.
    You deal 4d6 points of acid damage to any creature or object you touch
    with your successful melee attack. Your weapon is charged with acid until
    you make a successful attack.

    Augment: For every 2 additional power points you spend, this power’s damage
             increases by 1d6 points.


    @author Ornedan
    @date   Created - 2005.01.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

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
                                  METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                                  );

        if(manif.bCanManifest)
        {
            int nNumberOfDice = 4 + manif.nTimesAugOptUsed_1;
            int nDieSize      = 6;
            effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);

            /* Apply the VFX to whatever is wielding the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));

            // Roll the damage here and store it on the weapon
            int nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
            if(manif.bTwin)
                nDamage += MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
            SetLocalInt(oTarget, "PRC_DissolvingWeaponDamage", nDamage);

    	    // Hook to the item's OnHit
    	    AddEventScript(oTarget, EVENT_ITEM_ONHIT, "psi_pow_disswpn", FALSE, FALSE);

            /* Add the onhit spell to the weapon */
    		IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();

        int nDamage = GetLocalInt(oItem, "PRC_DissolvingWeaponDamage");
        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        effect eLink = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_ACID_L));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

        // Clean up the local
        DeleteLocalInt(oItem, "PRC_DissolvingWeaponDamage");
    }// end else - Running OnHit
}
