#include "inc_item_props"
#include "nw_i0_plot"
#include "prc_inc_function"
#include "prc_ipfeat_const"
#include "inc_epicspells"
#include "prc_inc_clsfunc"

void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONREST",1);
     DeletePRCLocalIntsT(oPC);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONREST");
     FeatSpecialUsePerDay(oPC);
}

void main()
{
    object oPC=GetLastPCRested();
    
   switch(GetLastRestEventType()){
      case REST_EVENTTYPE_REST_CANCELLED:{
         DelayCommand(1.0,PrcFeats(oPC));
         break;
      }
      case REST_EVENTTYPE_REST_STARTED:{

         if (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC)){
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0);
         }
        if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
        {
            //Destroy imbued arrows.
            AADestroyAllImbuedArrows(oPC);
        }
         break;
      }
      case REST_EVENTTYPE_REST_FINISHED:{
      
         // To heal up enslaved creatures...
         object oSlave = GetLocalObject(oPC, "EnslavedCreature");
         if (GetIsObjectValid(oSlave) && !GetIsDead(oSlave) && !GetIsInCombat(oSlave)) ForceRest(oSlave);
 
         if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC)){
            int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
            if (iLips<2)iLips=1;
               SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
            SendMessageToPC(oPC," Lips of Rapture : use "+IntToString(iLips-1));
         }
      
         if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC)){
            object oFam =  GetLocalObject(oPC, "BONDED");
    
            // Remove negative effects
            RemoveEffects(oFam);
            int nHeal =  GetMaxHitPoints(oFam);
            effect eHeal = EffectHeal(nHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oFam);
         }

		if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
				GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC)) {
			FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
			ReplenishSlots(oPC);
		}
 
          if (GetHasFeat(FEAT_SF_CODE,oPC))
            RemoveSpecificProperty(GetPCSkin(oPC),ITEM_PROPERTY_BONUS_FEAT,IP_CONST_FEAT_SF_CODE);

          DelayCommand(1.0,PrcFeats(oPC));

         break;
      }
      case REST_EVENTTYPE_REST_INVALID:{
         break;
      }
   }

 
}
