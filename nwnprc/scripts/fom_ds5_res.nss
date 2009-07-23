#include "prc_inc_spells"

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    effect eRaiseDead = EffectResurrection();
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
      {
        if (GetIsDead(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 142, FALSE));
            eRaiseDead = ExtraordinaryEffect(eRaiseDead);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRaiseDead, oTarget);
            ExecuteScript("prc_pw_raisedead", OBJECT_SELF);
            if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

