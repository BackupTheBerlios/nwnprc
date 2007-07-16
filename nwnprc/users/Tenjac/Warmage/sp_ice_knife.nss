//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Ice Knife
Conjuration (Creation) [Cold]
Level: Assassin 2, wu jen 2 (water),warmage 2
Components: S, M
Casting Time: 1 standard action
Range: Long (400 ft. + 40 ft./level)
Effect: One icy missile
Duration: Instantaneous
Saving Throw: See text
Spell Resistance: Yes

A magical shard of ice blasts from your
hand and speeds to its target. You must
succeed on a normal ranged attack to
hit (with a +2 bonus on the attack roll
for every two caster levels). If it hits, 
an ice knife deals 2d8 points of cold 
damage plus 2 points of Dexterity damage
(no Dexterity damage on a successful
Fortitude save). Creatures that have
immunity to cold damage also take no
Dexterity damage automatically.

A knife that misses creates a shower
of ice crystals in a 10-foot-radius burst.
The icy burst deals 1d8 points of cold
damage to all creatures within the area
of the effect (Reflex half).

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
        object oTarget = PRCGetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nTouch = PRCDoRangedTouchAttack(oTarget);
        int nDam;
        
        if(nTouch)
        {
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
                {
                        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD);
                                          
                        //if failed, ability damage
                        if(nSave == 0) ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);                                                                
                        
                        nDam = d8(2);
                        
                        if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 16;
                        
                        if (nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
                        
                }
        }
        
        GenerateNewLocationFromLocation