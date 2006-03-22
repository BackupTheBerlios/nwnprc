//:://////////////////////////////////////////////
//:: Agony - Initial effect
//:: drug_agony1.nss
//:://////////////////////////////////////////////
/** @file
    This handles the initial effect of the drug Agony.
    
    User is stunned for 1d4 rounds, and can only take
    partial actions for 1d6 minutes after that.

    @author Tenjac
    @date   Created  - 18.3.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "spinc_common"

void main()
{
	//define vars
	
	object oPC = OBJECT_SELF
	float fDur = RoundsToSeconds(d4(1));
	float fDaze = (d6(1) * 60.0f);
	effect eStun = EffectStunned();
	effect eDave = EffectDazed();
	
	//Temporary might cause problems because of duration, but delay command 
	//might cause it to be unremovalable if permanent.  Test to see.
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oPC, fDur);
	
	//Partial actions - effect daze ought to work ok.  Same problem as above possible
	DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, fDaze));
}
	
	
	
	

