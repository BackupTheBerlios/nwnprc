//::///////////////////////////////////////////////
//:: Name      Life Bolt
//:: FileName  sp_life_bolt.nss
//:://////////////////////////////////////////////
/**@file Life Bolt
Necromancy
Level: Sorcerer/wizard 2
Components: V, S
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Up to five rays
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

You draw forth some of your own life
force to create a beam of positive energy
that harms undead. You must succeed
on a ranged touch attack with the ray to
strike a target. If the ray hits an
undead creature, it deals 1d12 points of
damage. Creating each beam deals you
1 point of nonlethal damage.
For every two caster levels beyond
1st, you can create an additional ray, up
to a maximum of five rays at 9th level.
If you shoot multiple rays, you strike a 
single creature. 

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
        SPSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        if(!X2PreSpellCastCode()) return;
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nType = MyPRCGetRacialType(oTarget);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = GetSpellId();
        int nDice = 1;
        int nDam;
        int nOuch;
        
        //Must be undead
        if(nType != RACIAL_TYPE_UNDEAD)
        {
                SPSetSchool();
                return;
        }
        
        //SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget, (nCasterLevel + SPGetPenetr()))
        {
                //Determine damage to caster
                if(nSpell == LIFE_BOLT_5_BOLTS)
                {
                        nOuch = 5;
                        if(nCasterLvl < 9)
                        {
                                //Tell them they can't cast this yet
                                SendMessageToPC(oPC, "You cannot create this many beams yet!");
                                return;
                        }
                }
                
                else if(nSpell == LIFE_BOLT_4_BOLTS)
                {
                        nOuch = 4;
                        if(nCasterLvl < 7)
                        {
                                //Tell them they can't cast this yet
                                SendMessageToPC(oPC, "You cannot create this many beams yet!");
                                return;
                        }
                }
                
                else if(nSpell == LIFE_BOLT_3_BOLTS)
                {
                        nOuch = 3;
                        if(nCasterLvl < 5)
                        {
                                //Tell them they can't cast this yet
                                SendMessageToPC(oPC, "You cannot create this many beams yet!");
                                return;
                        }
                }
                
                else if(nSpell == LIFE_BOLT_2_BOLTS)
                {
                        nOuch = 2;
                        if(nCasterLvl < 3)
                        {
                                //Tell them they can't cast this yet
                                SendMessageToPC(oPC, "You cannot create this many beams yet!");
                                return;
                        }
                }
                
                else nOuch = 1;
                
                //Apply damage to caster
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nOuch, DAMAGE_TYPE_MAGICAL), oPC);
                
                
                
                
             