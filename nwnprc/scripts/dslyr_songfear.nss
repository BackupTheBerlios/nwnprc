//::///////////////////////////////////////////////
//:: Bard Song
//:: NW_S2_BardSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for a set duration of
    10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller Oct 1, 2003
/*
bugfix by Kovi 2002.07.30
- loosing temporary hp resulted in loosing the other bonuses
*/

#include "x0_i0_spells"
#include "spinc_common"
#include "prc_class_const"
#include "prc_inc_clsfunc"

void main()
{
   if (!GetHasFeat(FEAT_DRAGONSONG_STRENGTH, OBJECT_SELF))
   {
        FloatingTextStringOnCreature("This ability is tied to your dragons song ability, which has no more uses for today.",OBJECT_SELF); // no more bardsong uses left
        return;
   }

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    
    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);


    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF,0.0,FALSE);  

    //Set and apply AOE object
    effect eAOE = SupernaturalEffect(EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR,"dslyr_songfeara","dslyr_songfearb"));
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF,0.0,FALSE);
    StoreSongRecipient(OBJECT_SELF, OBJECT_SELF, GetSpellId(), 0);
    
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGONSONG_STRENGTH);
    SetLocalInt(OBJECT_SELF, "SpellConc", 1);   
}
