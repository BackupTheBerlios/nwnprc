//* 
// *
//* Created July 17 2005
// * Author: GaiaWerewolf
// */
#include "prc_getbest_inc"
#include "prc_inc_spells"
#include "prc_inc_clsfunc"

int GetSpontaneousHealBurnableSpell(object oCaster)
{
    //This function will cycle through the caster's spell levels 9-6 and remember
    //the lowest-level spell of the bunch it finds, for burning off later.
    int nBurnableSpell = -1;

    nBurnableSpell = GetBestL7Spell(oCaster, nBurnableSpell);
    
    return nBurnableSpell;
}

void main()
{
    //Declare our standard variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nBurnableSpell = GetSpontaneousHealBurnableSpell(oCaster); //Get spell to burn

    if (nBurnableSpell == -1) //No spell left to burn? Can't heal! Tell the player that.
    {
        FloatingTextStringOnCreature("You have no level 7 spells left to trade for sacred stealth.", oCaster, FALSE);
        return;
    }

    //We got a spell to burn. So we burn it off, then do the spontaneous heal!
    DecrementRemainingSpellUses(oCaster, nBurnableSpell);
    SacredStealthLvl7(oCaster);

}