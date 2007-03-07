////////////////////////////////////////////////
// Angel of Decay: Rotting Aura 
// prc_c_rotaura.nss
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

void main()
{
        object oAngel = OBJECT_SELF;
        effect eAOE = EffectAreaOfEffect(VFX_AOD_ROT_AURA);
        
        //Apply AoE
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oAngel);        
}