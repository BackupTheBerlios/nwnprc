//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into a Red Dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 20, 2003
#include "heartward_inc"
#include "prc_inc_function"
#include "inc_item_props"
#include "soul_inc"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;

    int Level = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,OBJECT_SELF)- 10 ;

    int nDuration = 1+ (Level/5);

    int nSpell = GetSpellId();

    if(nSpell == SPELL_SHAPEDRAGONGOLD)
    {
       ePoly = EffectPolymorph(POLY_SHAPEDRAGONGOLD);
    }
    else if (nSpell == SPELL_SHAPEDRAGONRED)
    {
        ePoly = EffectPolymorph(POLY_SHAPEDRAGONRED);
    }
    else if (nSpell == SPELL_SHAPEDRAGONPRYS)
    {
        ePoly = EffectPolymorph(POLY_SHAPEDRAGONPRYS);
    }


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
//    DelayCommand(1.5,AddIniDmg(OBJECT_SELF));
    DelayCommand(1.5,ActionCastSpellAtObject(SPELL_SHAPE_INCREASE_DAMAGE,OBJECT_SELF,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
   
 
}