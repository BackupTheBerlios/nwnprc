//::///////////////////////////////////////////////
//:: Scrying
//:: sp_scrying.nss
//:://////////////////////////////////////////////
/*
    A spell that allows the caster to scry either
    on any creature in the area they're in, or to 
    scry on any PC. 
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 30, 2007
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
        object oPC = OBJECT_SELF;
        
DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

        //Declare major variables
        object oTarget;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = PRCGetSpellId();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        float fDur = 60.0 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
    	//Make Metamagic check for extend
    	if ((nMetaMagic & METAMAGIC_EXTEND))
    	{
        	fDur = fDur * 2;
    	}                
        
        SetLocalInt(oPC, "ScryCasterLevel", nCasterLvl);
        SetLocalInt(oPC, "ScrySpellId", nSpell);
        SetLocalInt(oPC, "ScrySpellDC", nDC);
        SetLocalFloat(oPC, "ScryDuration", fDur);
        
	DelayCommand(6.0, DeleteLocalInt(oPC, "ScryCasterLevel"));
	DelayCommand(6.0, DeleteLocalInt(oPC, "ScrySpellId"));
	DelayCommand(6.0, DeleteLocalInt(oPC, "ScrySpellDC"));
	DelayCommand(6.0, DeleteLocalFloat(oPC, "ScryDuration"));        
        
        StartDynamicConversation("prc_scry_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
