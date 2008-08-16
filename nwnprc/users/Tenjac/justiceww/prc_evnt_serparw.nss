/////////////////////////////////////////////////
// Serpent Arrow Onhit script
// prc_evnt_serparw.nss
////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
        object oItem = PRCGetSpellCastItem(oSpellOrigin);
        
        //Save for poison
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 11, SAVING_THROW_TYPE_POISON))
        {
                //DC 11, 1d6 CON, 1d6 CON
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPosion(105) 
        }
        
        //Make snake and make it friendly to
        object oSnake = CreateObject(OBJECT_TYPE_CREATURE, "spitcobra002", GetLocation(oTarget), TRUE);
        SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, STANDARD_FACTION_DEFENDER, oSnake);
                
}
        
