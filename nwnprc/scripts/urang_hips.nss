#include "NW_I0_SPELLS"
#include "inc_item_props"

void main()
{
	
   object oTarget = GetSpellTargetObject();
   
   object oSkin = GetPCSkin(oTarget);

   DelayCommand(0.2, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
   DelayCommand(0.21, UseStealthMode());
   DelayCommand(0.2, ActionUseSkill(SKILL_HIDE, OBJECT_SELF));
   DelayCommand(0.2, ActionUseSkill(SKILL_MOVE_SILENTLY, OBJECT_SELF));
   
   AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyBonusFeat(31),oSkin,3.0f);
   SetActionMode(oTarget,ACTION_MODE_STEALTH,TRUE);
 
}