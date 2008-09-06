/////////////////////////////////////////////////////////
// Bile Droppings
// sp_biledrop.nss
/////////////////////////////////////////////////////////
/*
Bile Droppings: Distilled from the venomous excreta of
certain breeds of monstrous spiders, this substance is a thick,
viscous fluid. You can throw a flask of bile droppings as a
ranged touch attack with a range increment of 10 feet. Upon
hitting a target, this sticky fluid deals 1d6 points of acid damage
in the first round and 1d6 points of acid damage in the second
round. If the target takes a full-round action to scrape it off,
he takes no damage in the second round.

In addition to causing acid damage, a flask of bile droppings
releases a powerful stench when broken open, forcing anyone
within 5 feet to make a successful DC 13 Fortitude save or be
sickened for 1 round. Anyone actually struck by the vile stuff
takes a -4 penalty on the save.*/

#include "prc_inc_spells"

void main()
{
        object oTarget = GetSpellTargetObject();
        location lTarget = GetSpellTargetLocation();
        int nTouch; 
        int nDam;
        effect eAtt = EffectAttackDecrease(2);
        effect eDam = EffectDamageDecrease(2);
        effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
        effect eSick = EffectLinkEffects(eAtt, eDam);
        eSick = EffectLinkEffects(eSick, eSkill);
        eSick = EffectLinkEffects(eSick, eSave);
        
        if (GetIsObjectValid(oTarget) == TRUE)
        {
                nTouch = PRCDoRangedTouchAttack(oTarget);
        }
        
        else
        {
                nTouch = -1; // * this means that target was the ground, so the user
                // * intended to splash
        }
        
        //direct hit
        if (nTouch >= 1)
        {
                //Roll damage
                nDam = d6(1);
                
                if(nTouch == 2)
                {
                        nDam *= 2;
                }
                
                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_ACID);
                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                
                //Apply second round
                DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_ACID))
                {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(1));
                }          
        }
        
        //Splash VFX              
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISEASE_S), lTarget);
        
        object oSplashTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        
        //Cycle through the targets within the spell shape until an invalid object is captured.                
        while (GetIsObjectValid(oSplashTarget))
        {
                if(oSplashTarget != oTarget)
                {      
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_ACID))
                        {
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oSplashTarget, RoundsToSeconds(1));
                        }
                }
                oSplashTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
}       