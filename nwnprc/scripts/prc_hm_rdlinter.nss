/*********************************************
* Feat: Riddle of Interaction
* Description: Charm Monster 3 per day:
*
* by Jeremiah Teague
*********************************************/
#include "prc_hnshnmystc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = 3 + nCasterLevel/2;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);

    //Metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
        // Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Make Will save vs Mind-Affecting
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
