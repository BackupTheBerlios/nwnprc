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
#include "spinc_bolt"

int GetDieType(int nCasterLevel)

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        int nCasterLevel = PRCGetCasterLevel(oPC);
        int nDieSides = GetDieType(nCasterLevel);
       
        //Dish out the damage
        DoBolt(nCasterLevel, nDieSides, 0, 1, VFX_BEAM_FIRE, VFX_IMP_FLAME_S, DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE);
        DoBolt(nCasterLevel, nDieSides, 0, 1, VFX_BEAM_DISINTEGRATE, VFX_IMP_ACID_S, DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID);
        DoBolt(nCasterLevel, nDieSides, 0, 1, VFX_BEAM_COLD, VFX_IMP_FROST_S, DAMAGE_TYPE_COLD, SAVING_THROW_TYPE_COLD);
        DoBolt(nCasterLevel, nDieSides, 0, 1, VFX_BEAM_LIGHTNING, VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, SAVING_THROW_TYPE_ELECTRICITY);
        DoBolt(nCasterLevel, nDieSides, 0, 1, VFX_BEAM_SPELLFIRE, VFX_IMP_SONIC, DAMAGE_TYPE_SONIC, SAVING_THROW_TYPE_SONIC);
                
        SPSetSchool();
}

int GetDieType(int nCasterLevel)
{
        int nDice = 12;
        
        if(nCasterLevel < 11) nDice = 10;
        
        if(nCasterLevel < 9) nDice = 8;
        
        if(nCasterLevel < 7) nDice = 6;  
        
        return nDice;
}