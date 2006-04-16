/*
   ----------------
   Astral Seed

   psi_pow_astseed
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Astral Seed

    Metacreativity
    Level: Shaper 8
    Manifesting Time: 10 minutes
    Range: 0 ft.
    Effect: One storage crystal
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 15
    Metapsionics: None

    This power weaves strands of ectoplasm into a crystal containing the seed of your living mind. You may have only one seed in
    existence at any one time. Until such time as you perish, the astral seed is totally inert. Upon dying, you are transported
    to the location of your astral seed, where you will spend a day regrowing a body. Respawning in this manner will cost a level.
    If your astral seed is destroyed, the power will fail.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
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

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        // Destroy old seed, if any
        object oSeed = GetLocalObject(oManifester, "PRC_AstralSeed_SeedObject");
        if(GetIsObjectValid(oSeed))
            MyDestroyObject(oSeed);

        // Create new seed and do some VFX
        oSeed = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_plc_phylact", PRCGetSpellTargetLocation());
        effect eVis = EffectVisualEffect(PSI_FNF_ASTRAL_SEED);
        DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSeed));

        // Store a reference to the seed on the manifester
        SetLocalObject(oManifester, "PRC_AstralSeed_SeedObject", oSeed);

        // Add a hook to OnDeath event for the manifester
        AddEventScript(oManifester, EVENT_NPC_ONDEATH, "psi_astseed_resp", FALSE, FALSE);
    }
}