//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: prc_psi_splhook
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the psionic spellscripts

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 20-10-2004
//:://////////////////////////////////////////////

//#include "x2_inc_itemprop" - Inherited from x2_inc_craft
#include "x2_inc_craft"
#include "prc_inc_spells"
#include "x2_inc_spellhook"
//#include "prc_class_const"


// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int PsiPrePowerCastCode();


//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int PsiPrePowerCastCode()
{
   object oTarget = GetSpellTargetObject();
   int nContinue;
   
   DeleteLocalInt(OBJECT_SELF, "SpellConc");
    nContinue = !ExecuteScriptAndReturnInt("prespellcode",OBJECT_SELF);

   //---------------------------------------------------------------------------
   // This stuff is only interesting for player characters we assume that use
   // magic device always works and NPCs don't use the crafting feats or
   // sequencers anyway. Thus, any NON PC spellcaster always exits this script
   // with TRUE (unless they are DM possessed or in the Wild Magic Area in
   // Chapter 2 of Hordes of the Underdark.
   //---------------------------------------------------------------------------
   if (!GetIsPC(OBJECT_SELF))
   {
       if( !GetIsDMPossessed(OBJECT_SELF) && !GetLocalInt(GetArea(OBJECT_SELF), "X2_L_WILD_MAGIC"))
       {
            return TRUE;
       }
   }

   if (nContinue)
   {
	//---------------------------------------------------------------------------
	// Run use magic device skill check
	//---------------------------------------------------------------------------
	nContinue = X2UseMagicDeviceCheck();
   }

   if (nContinue)
   {
       //-----------------------------------------------------------------------
       // run any user defined spellscript here
       //-----------------------------------------------------------------------
       nContinue = X2RunUserDefinedSpellScript();
   }

   //---------------------------------------------------------------------------
   // The following code is only of interest if an item was targeted
   //---------------------------------------------------------------------------
   if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
   {

       //-----------------------------------------------------------------------
       // Check if spell was used to trigger item creation feat
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft",OBJECT_SELF);
       }

       //-----------------------------------------------------------------------
       // * Execute item OnSpellCast At routing script if activated
       //-----------------------------------------------------------------------
       if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
       {
             SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
             int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget),OBJECT_SELF);
             if (nRet == X2_EXECUTE_SCRIPT_END)
             {
                return FALSE;
             }
       }

       //-----------------------------------------------------------------------
       // Prevent any spell that has no special coding to handle targetting of items
       // from being cast on items. We do this because we can not predict how
       // all the hundreds spells in NWN will react when cast on items
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = X2CastOnItemWasAllowed(oTarget);
       }
   }

   return nContinue;
}

