#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "nw_i0_plot"

void main()
{
  if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
  {
     object oPC=GetLastPCRested();

     if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC))
     {
      int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
      if (iLips<2)iLips=1;
        SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
        SendMessageToPC(oPC," Lips of Rapture : use " +IntToString(iLips-1));

     }
     
     if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC))
     {
       object oFam =  GetLocalObject(oPC, "BONDED");

       // Remove negative effects
       RemoveEffects(oFam);
       int nHeal =  GetMaxHitPoints(oFam);
       effect eHeal = EffectHeal(nHeal);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oFam);

    }
  }
}

