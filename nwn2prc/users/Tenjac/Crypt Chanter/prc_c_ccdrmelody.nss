////////////////////////////////////////////////
//  Crypt Chanter: Draining Melody
//  prc_c_ccdrmelody.nss
////////////////////////////////////////////////
/*  A crypt chanter constantly sings, creating a 
magically charged allure. All creatures within 60
feet of a crypt chanter must make a DC 18 Will save 
or stand dazed as long as the music continues. This
is a sonic, mind-affecting, compulsion effect.
    Beginning on the round after becoming dazed, 
creatures that failed the first saving throw must
make a second saving throw (same DC) to avoid being
affected as if by the enthrall spell. Enthralled
victims also begin to gain 1d2 negative levels per 
round while the song continues, as long as they
remain within range. If a creature gains a number
of negative levels at least equal to its Hit Dice,
it dies and becomes a spawn.
    When a crypt chanter bestows negative levels on
a victim, it gains 5 temporary hit points for each 
negative level bestowed. These temporary hit points
last for up to 1 hour.
    Creatures that successfully save upon hearing 
a crypt chanter's music cannot be affected by that
crypt chanter's music again unless the chanter ceases
singing for 1 full round (releasing all those it
previously held in thrall) and beings a new song.
The save DC is Charisma-based.
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/15/07
////////////////////////////////////////////////

#include "spinc_common"

void main()
{