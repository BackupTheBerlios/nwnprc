/* 
   ----------------
   prc_enforce_feat
   ----------------
   
   7/25/04 by Stratovarius
   
   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to. Only contains the Red Wizard,
   but more, such as the Mage Killer and Fist of Hextor, will be added later.
*/


#include "prc_class_const"
#include "prc_feat_const"


// Enforces the proper selection of the Red Wizard feats
// that are used to determine restricted and specialist
// spell schools. You must have two restricted and one specialist.
void RedWizardFeats(object oPC = OBJECT_SELF);











// ---------------
// BEGIN FUNCTIONS
// ---------------
void RedWizardFeats(object oPC = OBJECT_SELF)
{

	int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oPC);
	int iRWRes;
	int iRWSpec;
	
	if (iRedWizard > 0)
	{
		iRWSpec     +=	(GetHasFeat(FEAT_RW_SPEC_ABJ, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_CON, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_DIV, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_ENC, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_EVO, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_ILL, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_NEC, oPC))
			    +	(GetHasFeat(FEAT_RW_SPEC_TRS, oPC));
	
		iRWRes      +=	(GetHasFeat(FEAT_RW_RES_ABJ, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_CON, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_DIV, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_ENC, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_EVO, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_ILL, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_NEC, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_TRS, oPC));


		if (iRWSpec != 1 || iRWRes != 2)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You must have 2 Restricted Schools and 1 Specialist School. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}
	}
}



void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;

	RedWizardFeats(oPC);
}