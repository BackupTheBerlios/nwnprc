////////////////////////////////////////////////
//  Tomb Mote: Onhit
//  prc_c_tmonhit.nss
////////////////////////////////////////////////
/*  A creature struck by a tomb mote's bite attack
must make a DC13 fortitude save or be infected with
a disease known as corpse bloat(incubation period
1d3 days, damage 1d6 Str). The skin of the diseased
victim turns a hue of breen, bloats, and is warm to
the touch. The save DC is Charisma-based.
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/13/07
////////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oSpellTarget = PRCGetSpellTargetObject(); // On a weapon: The one being hit.
        object oSpellOrigin  = OBJECT_SELF; // On a weapon: The one wielding the weapon. 
        
        //Save DC13 Fort
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oSpellTarget, 13, SAVING_THROW_TYPE_DISEASE))
        {
                effect eDisease = EffectDisease(DISEASE_CORPSE_BLOAT);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oSpellTarget);
        }
}