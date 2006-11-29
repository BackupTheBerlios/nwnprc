//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/**@file Acid Fog
Conjuration (Creation) [Acid]
Level: 	Sor/Wiz 6, Water 7
Components: 	V, S, M/DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Effect: 	Fog spreads in 20-ft. radius, 20 ft. high
Duration: 	1 round/level
Saving Throw: 	None
Spell Resistance: 	No

Acid fog creates a billowing mass of misty vapors similar 
to that produced by a solid fog spell. In addition to 
slowing creatures down and obscuring sight, this spell's
vapors are highly acidic. Each round on your turn, 
starting when you cast the spell, the fog deals 2d6 points
of acid damage to each creature and object within it.

Material Component: A pinch of dried, powdered peas 
                    combined with powdered animal hoof.

**/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

//:: modified by mr_bumpkin Dec 4, 2003
// rewritten by fluffyamoeba to work like the SRD 29.11.06

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
    
    // End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID);
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Make sure duration does not equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    SPSetSchool();

}
