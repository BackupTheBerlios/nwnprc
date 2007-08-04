//::///////////////////////////////////////////////
//:: Name      Sleet Storm
//:: FileName  sp_sleet_storm.nss
//:://////////////////////////////////////////////
/**@file Sleet Storm
Conjuration (Creation) [Cold]
Level: Drd 3, Sor/Wiz 3 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (40-ft. radius, 20 ft. high) 
Duration: 1 round/level 
Saving Throw: None 
Spell Resistance: No

Driving sleet blocks all sight (even darkvision) 
within it and causes the ground in the area to be
icy. A creature can walk within or through the 
area of sleet at half normal speed with a DC 10 
Balance check. Failure means it can�t move in that
round, while failure by 5 or more means it falls 
(see the Balance skill for details).

The sleet extinguishes torches and small fires.

Arcane Material Component: A pinch of dust and a 
few drops of water.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        location lLoc = GetSpellTargetLocation();
        float fDur = RoundsToSeconds(PRCGetCasterLevel(oPC));
        effect eAoE = EffectAreaOfEffect(VFX_PER_SLEET_STORM);
        
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lLoc, fDur);
        
        SPSetSchool();
}
        
        