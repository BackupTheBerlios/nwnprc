//
// Lichloved By Zedium
//

#include "inc_item_props"

///Lich Loved +1 on saves vs. Mind Affecting, Poison, and Disease /////////
void Lich_Loved(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "LichLovedD") == iLevel) return;

    SetCompositeBonus(oSkin, "LichLovedM", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_MINDAFFECTING);
    SetCompositeBonus(oSkin, "LichLovedP", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_POISON);
    SetCompositeBonus(oSkin, "LichLovedD", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_DISEASE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
  //  int bLichLove;

    int bLichLove = GetHasFeat(FEAT_LICHLOVED, oPC) ? 1 : 0;

   if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
    if(bLichLove > 0) Lich_Loved(oPC, oSkin, bLichLove);
    }
     else
      {
      Lich_Loved(oPC, oSkin,0);
      }

}