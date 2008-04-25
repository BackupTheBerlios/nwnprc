/////////////////////////////////////////////////////////////
// Splint Bolt
// sp_splinterbolt.nss
////////////////////////////////////////////////////////////
/** @file Splinterbolt
Conjuration (Creation)
Level: Druid 2
Components: V, S, M
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: One or more streams of splinters
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You extend your hand toward your foe,
flicking a single sliver of wood into the air,
and a splinter larger than a titan’s javelin
whistles through the air.

You must make a ranged attack to hit
the target. If you hit, the splinterbolt
deals 4d6 points of piercing damage.
A splinterbolt threatens a critical hit on
a roll of 18-20.

You can fire one additional splinterbolt
for every four levels beyond
3rd (to a maximum of three at 11th
level). You can fire these splinterbolts
at the same or different targets, but all
splinterbolts must be aimed at targets
within 30 feet of each other and fired
simultaneously.

A creature’s damage reduction, if any,
applies to the damage from this spell.
The damage from splinterbolt is treated
as magic and piercing for the purpose
of overcoming damage reduction.
*/
//////////////////////////////////////////////
// Tenjac   10/2/07
//////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_CONJURATION)
        
        object oPC = OBJECT_SELF;
        location lLoc = GetSpellTargetLocation();
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nTargets = 1;
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDam;
        
        if(nCasterLvl > 6) nTargets++;
        if(nCasterLvl > 10) nTargets++;
        
        while(nTargets > 0)
        {
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                        nDam = d6(4);
                        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 24;
                        
                
                
        