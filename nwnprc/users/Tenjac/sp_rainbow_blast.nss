//::///////////////////////////////////////////////
//:: Name      Rainbow Blast
//:: FileName  sp_rainbow_blast.nss
//:://////////////////////////////////////////////
/**@file Rainbow Blast
Evocation [Light]
Level: Sorcerer/wizard 3
Components: V, S, M
Casting Time: 1 standard action
Range: 120 ft.
Area: 120-ft. line
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell is a wide-spectrum blast of
radiant energy composed of all five
energy types. Rainbow blast deals 1d6
points of damage from each of the five
energy types (acid, cold, electricity,
fire, and sonic), for a total of 5d6 points
of damage. Creatures apply resistance
to energy separately for each type of
damage.
As you gain in levels, the damage
die increases in size. At 7th level the
spell deals 5d8 points of damage, at 9th
level it deals 5d10 points of damage,
and at 11th level it deals 5d12 points of
damage; one die for each of the five
energy types.
Focus: A small clear gem or crystal
prism worth at least 50 gp.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

int GetDieType(int nCasterLevel)

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        location lCaster = GetLocation(oPC);
        location lTarget = PRCGetSpellTargetLocation();
        int nCasterLevel = PRCGetCasterLevel(oPC);
        vector vOrigin = GetPosition(oPC);
        float fLength = FeetToMeters(120);
        float fAngle = GetRelativeAngleBetweenLocations(lCaster, lTarget);
        float fVFXLength = GetVFXLength(lCaster, fLength, fAngle);
        float fDuration = 3.0f;
        int nSwitch = GetDieType(nCasterLevel);
        
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
        
        while(GetIsObjectValid(oTarget))
        {
                if(!MyPRCResistSpell(oPC, oTarget, (nCasterLevel + SPGetPenetr()))
                {
                        //Determine
                        switch(nSwitch
                        
                }                
        }
        
        SPSetSchool();
}

int GetDieType(int nCasterLevel)
{
        int nDice = 5;
        
        if(nCasterLevel < 9)
        {
                nDice--;
        }
        
        if(nCasterLevel < 7)
        {
                nDice--;
        }
        
        if(nCasterLevel < 5)
        {
                nDice--;
        }
        
        return nDice;
}
 