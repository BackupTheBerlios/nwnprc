////////////////////////////////////////////////
// Angel of Decay: Rotting Touch
// prc_c_rottouch.nss
////////////////////////////////////////////////
/* Rotting Touch(Su)
   
   An Angel of Decay that his a single foe with
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
        
        //check for previous hit
        int nTouch = GetLocalInt(oTarget, "PRC_C_ROTTOUCH");
        
        //if has marker
        if(nTouch)
        {
                //deal extra damage
                effect eDam = EffectDamage(6 + d6(1), DAMAGE_TYPE_MAGICAL);
                
        }
        
        //Schedule deletion
}