#include "prc_alterations"
#include "prc_inc_smite"


void main()
{   
    
    DoSmite(OBJECT_SELF, GetSpellTargetObject(), SMITE_TYPE_CORRUPT);
    
    effect eVis = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetObject(), HoursToSeconds(24));
    SetLocalInt(GetSpellTargetObject(), "DeemedCorrupt", TRUE);
}
