#include "x2_inc_switches"

void main()
{
effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(eVis),OBJECT_SELF);
FloatingTextStringOnCreature("Channeling Activated",OBJECT_SELF);
SetLocalString(GetModule(),"ovscript",GetModuleOverrideSpellscript());
SetModuleOverrideSpellscript("prc_spell_chanel");
}
