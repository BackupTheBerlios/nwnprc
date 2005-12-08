//::///////////////////////////////////////////////
//:: Ghost Step (Invisibility)
//:: prc_gfkill_gstep.nss
//:://////////////////////////////////////////////
/*
    Target creature becomes invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Stefan Johnson
//:: Created On: December 1, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "x2_inc_spellhook"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_inc_clsfunc"


void main()
{
   object oCaster = OBJECT_SELF;
   int iClassLevel = GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER, oCaster);
   effect eEffect;
   if ( iClassLevel > 5 ) {
      eEffect = EffectEthereal();
   } else {
      eEffect = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oCaster, RoundsToSeconds(1));
}

