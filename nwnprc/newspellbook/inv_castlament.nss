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
#include "prc_inc_spells"
#include "prc_alterations"
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
    // Break Enchantment is capped at caster level 15
    //--------------------------------------------------------------------------
    if(nCasterLevel > 15 )
    {
        nCasterLevel = 15;
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
    
}
