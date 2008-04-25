
#include "prc_inc_spells"
#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    // End of Spell Cast Hook

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS,"sp_blacklighta","","sp_blacklightb");
    location lTarget = PRCGetSpellTargetLocation();
    object oTarget = PRCGetSpellTargetObject();

    float  nDuration = PRCGetMetaMagicDuration(RoundsToSeconds(PRCGetCasterLevel()));

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
      //Make SR Check
      if (!PRCDoResistSpell(OBJECT_SELF, oTarget,SPGetPenetrAOE(GetAreaOfEffectCreator())))
      {
      	if (GetIsObjectValid(oTarget))
          //Create an instance of the AOE Object using the Apply Effect function
          SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, nDuration);
        else
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, nDuration);

      }
    }
    else
    {
      	if (GetIsObjectValid(oTarget))
          //Create an instance of the AOE Object using the Apply Effect function
          SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, nDuration);
        else
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, nDuration);
    }

    PRCSetSchool();

}
