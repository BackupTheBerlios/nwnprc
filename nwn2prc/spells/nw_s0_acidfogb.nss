   //::///////////////////////////////////////////////
//:: Acid Fog: On Exit
//:: NW_S0_AcidFogB.nss
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
// rewritten by fluffyamoeba to work like the SRD 29.11.2006
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{

    ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_ACID_FOG, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_ACID_FOG)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

}

