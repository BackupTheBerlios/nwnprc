/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 */

#include "prc_alterations"

void main()
{
   int nMax = GetMaxHenchmen();
   SetMaxHenchmen(nMax + 10);
  
    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
    while (GetIsObjectValid(oHench))
    {
        if (GetTag(oHench) == "prc_hex_darkcomp")
	{
            FloatingTextStringOnCreature("Unsummoning Dark Companion", OBJECT_SELF, FALSE);
            // Die, die die my darling, don't utter a single word.
            SetPlotFlag(oHench,FALSE);
	    SetImmortal(oHench, FALSE);
	    AssignCommand(oHench, SetIsDestroyable(TRUE, FALSE, FALSE));
            DestroyObject(oHench, 0.2);
            return;
        }
        i += 1;
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
    }   
   
   if (DEBUG) DoDebug("Creating Dark Companion");
    
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
   
   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "prc_hex_darkcomp", GetSpellTargetLocation(), FALSE, "prc_hex_darkcomp");
   if (DEBUG) DoDebug("Adding Dark Companion as Henchman");
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCreature));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(VFX_PER_10_FT_INVIS, "prc_hexbl_comp_a", "prc_hexbl_comp_c", ""), oCreature);
   
   if (DEBUG) DoDebug("Applying Dark Companion Effects");
   // Make the creature act like an illusion
   effect eGhost = EffectCutsceneGhost();
   effect eGhostVs = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
   eGhost = EffectLinkEffects(eGhost, eGhostVs);
   eGhost = SupernaturalEffect(eGhost);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oCreature);
   
   AssignCommand(oCreature, ActionForceFollowObject(OBJECT_SELF, 1.0));
   
   SetMaxHenchmen(nMax);
   if (DEBUG) DoDebug("Ending Dark Companion Script");
}
