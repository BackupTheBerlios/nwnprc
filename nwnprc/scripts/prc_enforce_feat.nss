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


		iRWSpec     +=	(GetHasFeat(FEAT_RW_TF_ABJ, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_CON, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_DIV, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_ENC, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_EVO, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_ILL, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_NEC, oPC))
			    +	(GetHasFeat(FEAT_RW_TF_TRS, oPC));

		if (iRWSpec > 1)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You may only have one Tattoo Focus. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}

	
	if (iRedWizard > 0)
	{
		iRWRes      +=	(GetHasFeat(FEAT_RW_RES_ABJ, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_CON, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_DIV, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_ENC, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_EVO, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_ILL, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_NEC, oPC))
			    +	(GetHasFeat(FEAT_RW_RES_TRS, oPC));


		if (iRWRes != 2)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You must have 2 Restricted Schools. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}
	}
}


void VileFeats(object oPC = OBJECT_SELF)
{

	int iDeform = GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC) + GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC);
	int iThrall = GetHasFeat(FEAT_THRALL_TO_DEMON, oPC) + GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oPC);


		if (iDeform > 1)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You may only have one Deformity. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}

	
		if (iThrall > 1)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You may only worship Demons or Devils, not both. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}
}



void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;

	RedWizardFeats(oPC);
	VileFeats(oPC);
}