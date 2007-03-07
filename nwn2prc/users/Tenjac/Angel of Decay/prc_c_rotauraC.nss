////////////////////////////////////////////////
// Angel of Decay: Rotting Aura Heartbeat
// prc_c_rotauraC.nss
////////////////////////////////////////////////
/* Rotting Aura - When the creature is not flying,
rivulets of vile corruption stream from an angel
of decay's body, constantly regenerating and 
renewing a pool of odiferous rot all around the 
creature.
   An angel of decay's pool of rot os a 15 foot
radius spread. Any corporeal creature standing on
the ground whithin that area must make a DC 24 
reflex saving throw each round or take 5d6 points
of damage (half that on a successful save) as its
flesh begins to succumb to decay. The creature must
also succeed on a subsequent DC24 Will saving throw
(regardless of whether it succeeds on the first save)
or be nauseated for 1 round.
   In each round that a creature takes damage from
an angel of decay's rotting aura, the angel of decay's
rotting aura, the angel of decay heals 5 points of 
damage per victim.   
   
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/5/07
////////////////////////////////////////////////
#include "spinc_common"

void main()
{
        object oAngel = GetAreaOfEffectCreator();
        object oTarget = GetFirstInPersistentObject();
        effect eNaus = EffectDazed();
        effect eHeal = EffectHeal(5);
        int nDam;
        
        while(GetIsObjectValid(oTarget))
        {
                //DC 24 reflex saving throw or take 5d6 (half that on a successful save)
                nDam = d6(5);
                
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 24))
                {
                        nDam = (nDam/2);
                }
                
                //Apply damage regardless
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
                
                //DC24 Will saving throw or be nauseated for 1 round
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 24))
                {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNaus, oTarget, 6.0f);
                }
                
                //Heal angel of decay by 5 HP
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oAngel);
                
                oTarget = GetNextInPersistentObject();
        }
}
       
}

