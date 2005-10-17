//::///////////////////////////////////////////////
//:: Visage of Terror
//:: prc_rava_visage
//:://////////////////////////////////////////////
/*
Once per day on a successful touch attack you can trigger a spell like ability 
similar to the spell phantasmal killer with a DC equal to 14 + Ravager levels.
*/

#include "prc_alterations"
#include "prc_class_const"
void main()
{
    //Declare major variables
    int nDC =  10 + GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF)+GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF);;
    int nLevel = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF);
    DoSpellMeleeTouch(SPELL_PHANTASMAL_KILLER, nLevel, nDC);

}
