/*
	Pixie Dispel
*/
#include "spinc_common"
#include "x0_i0_spells"
void main()
{
    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
    object    oTarget      = GetSpellTargetObject();
    location  lLocal       = GetSpellTargetLocation();
    int       nCasterLevel = 8;
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");

    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------
    if(nCasterLevel > 10)
    {
        nCasterLevel = 10;
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

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
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

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}



