#include "inc_item_props"
#include "nw_i0_plot"
#include "prc_inc_function"
#include "soul_inc"
#include "inc_epicspells"

void RestMeUp(object oPC)
{
    FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
    ForceRest(oPC);
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
    {
        ReplenishSlots(oPC);
    }
}


 
void main()
{
    object oPC=GetLastPCRested();

    if (!GetLocalInt(oPC,"ForceRest"))
    {

      AssignCommand(oPC, ClearAllActions(FALSE));
      // Start the special conversation with oPC.
      AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "_rest_button", TRUE, FALSE));
    }
    DeleteLocalInt(oPC,"ForceRest");


   switch(GetLastRestEventType()){
      case REST_EVENTTYPE_REST_CANCELLED:{
         break;
      }
      case REST_EVENTTYPE_REST_STARTED:{

         if (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC)){
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0);
         }
         break;
      }
      case REST_EVENTTYPE_REST_FINISHED:{

 
         if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC)){
            int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
            if (iLips<2)iLips=1;
               SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
            SendMessageToPC(oPC," Lips of Rapture : use " +IntToString(iLips-1));
         }
      
         if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC)){
            object oFam =  GetLocalObject(oPC, "BONDED");
    
            // Remove negative effects
            RemoveEffects(oFam);
            int nHeal =  GetMaxHitPoints(oFam);
            effect eHeal = EffectHeal(nHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oFam);
         }
         
           if (GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,oPC))
              ChangeSpellSol(oPC);
         
         FeatSpecialUsePerDay(oPC);
         
         AssignCommand(oPC, ClearAllActions(FALSE));
         AssignCommand(oPC, RestMeUp(oPC));



         break;
      }
      case REST_EVENTTYPE_REST_INVALID:{
         break;
      }
   }

 
}
