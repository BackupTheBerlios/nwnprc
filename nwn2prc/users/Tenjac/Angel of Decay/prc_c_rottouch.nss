////////////////////////////////////////////////
// Angel of Decay: Rotting Touch onhit
// prc_c_rottouch.nss
////////////////////////////////////////////////
/* Rotting Touch(Su)
   
   An Angel of Decay that hits a single foe with
   more than one attack in a round rots its 
   opponent's flesh. This effect automatically
   deals an extra 1d6+6 points of damage and heals
   the angel of decay of 5 points of damage.   
   
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/5/07
////////////////////////////////////////////////

void main()
{
        object oAngel = OBJECT_SELF;
        object oTarget = GetSpellTagetObject();
                        
        //if has spell effect from previous hit
        if(GetHasSpellEffect(SPELL_AOD_ROT_TOUCH, oTarget))
        {                
                //deal extra damage
                effect eDam = EffectDamage(6 + d6(1), DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                
                //heal
                effect eHeal = EffectHeal(5);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oAngel);
        }
        
        //Apply spell effect
        AssignCommand(oAngel, ActionCastSpellAtObject(SPELL_AOD_ROT_TOUCH, oTarget, METAMAGIC_NONE, TRUE));
}