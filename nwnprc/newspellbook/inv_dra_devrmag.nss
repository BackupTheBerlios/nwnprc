//::///////////////////////////////////////////////
//:: Greater Dispelling
//:: NW_S0_GrDispel.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "inc_dispel"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    effect   eVis         = EffectVisualEffect( VFX_IMP_BREACH );
    effect   eImpact      = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );
    int      nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object   oTarget      = PRCGetSpellTargetObject();
    location lLocal   =     PRCGetSpellTargetLocation();
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");

    //--------------------------------------------------------------------------
    // Greater Dispel Magic is capped at caster level 20
    //--------------------------------------------------------------------------
    if(nCasterLevel >20 )
    {
        nCasterLevel = 20;
    }
    
    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
          if (iTypeDispel)
             spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
           else
             spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                if (iTypeDispel)
                   spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);
                else
                   spellsDispelAoEMod(oTarget, OBJECT_SELF,nCasterLevel);
 
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                  if (iTypeDispel)
                     spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                  else
                     spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
    
}
