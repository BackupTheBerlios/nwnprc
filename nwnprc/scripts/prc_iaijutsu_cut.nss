#include "prc_alterations"
#include "prc_spell_const"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oSkin = GetPCSkin(oPC);

    int nAttacks = 1;
    effect eAttack = SupernaturalEffect(EffectModifyAttacks(nAttacks));


    if(!GetHasSpellEffect(SPELL_ONE_STRIKE_TWO_CUTS,OBJECT_SELF))
     {
        FloatingTextStringOnCreature("One Strike Two Cuts",OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAttack,oPC);
     }
     else
     {
          // The code to cancel the effects
            RemoveSpellEffects(SPELL_ONE_STRIKE_TWO_CUTS, oPC, oPC);
            FloatingTextStringOnCreature("One Strike Two Cuts Removed",OBJECT_SELF);
     }


}
