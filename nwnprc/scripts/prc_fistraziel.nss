#include "ft_martialstrike"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bMartialS = GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE, oPC) ?  1: 0;

    if (bMartialS>0) MartialStrike();



}

