
#include "spinc_common"
#include "NW_I0_SPELLS"
#include "minstrelsong"

void main()
{


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
   
   RemoveSongEffects(SPELL_DSL_SONG_STRENGTH,GetAreaOfEffectCreator(),oTarget);

}
