//::///////////////////////////////////////////////
//:: Detect_Evil
//:: NW_S2_DetecEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures of Evil Alignment within LOS of
    the Paladin glow for a few seconds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:: Modified by Wyz_sub10 for Pixie
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    object oTarget;
    int nChaos;
    effect eVis = EffectVisualEffect(VFX_COM_SPECIAL_RED_WHITE);
    
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        //Check the current target's alignment
        nChaos = GetAlignmentLawChaos(OBJECT_SELF);
        if(nChaos == ALIGNMENT_CHAOS)
        {
            //Apply the VFX
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0);
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

