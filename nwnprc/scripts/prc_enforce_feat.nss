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

// Enforces the proper selection of the Vile feats
// and prevents illegal stacking of them
void VileFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Ultimate Ranger feats
// and prevents illegal use of bonus feats.
void UltiRangerFeats(object oPC = OBJECT_SELF);




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


void UltiRangerFeats(object oPC = OBJECT_SELF)
{

	int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);
	int iAbi;
	int iFE;
	int Ability = 0;
	
	if (iURanger > 0)
	{
		iFE     +=	(GetHasFeat(FEAT_UR_FE_DWARF, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_ELF, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_GNOME, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_HALFING, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_HALFELF, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_HALFORC, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_HUMAN, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_ABERRATION, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_ANIMAL, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_BEAST, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_CONSTRUCT, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_DRAGON, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_GOBLINOID, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_MONSTROUS, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_ORC, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_REPTILIAN, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_ELEMENTAL, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_FEY, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_GIANT, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_MAGICAL_BEAST, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_OUSIDER, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_SHAPECHANGER, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_UNDEAD, oPC))
			    +	(GetHasFeat(FEAT_UR_FE_VERMIN, oPC));



	
		iAbi    +=  +	(GetHasFeat(FEAT_UR_SNEAKATK_3D6, oPC))
			    +	(GetHasFeat(FEAT_UR_ARMOREDGRACE, oPC))
			    +	(GetHasFeat(FEAT_UR_DODGE_FE, oPC))
			    +	(GetHasFeat(FEAT_UR_RESIST_FE, oPC))
			    +	(GetHasFeat(FEAT_UR_HAWK_TOTEM, oPC))
			    +	(GetHasFeat(FEAT_UR_OWL_TOTEM, oPC))
			    +	(GetHasFeat(FEAT_UR_VIPER_TOTEM, oPC))
			    +	(GetHasFeat(FEAT_UR_FAST_MOVEMENT, oPC))
			    +	(GetHasFeat(FEAT_UNCANNYX_DODGE_1, oPC))
			    +	(GetHasFeat(FEAT_UR_HIPS, oPC))
			    +	(GetHasFeat(FEAT_UR_CAMOUFLAGE, oPC));

	 
                if (iURanger>=11){
                   if ((iURanger-8)/3 != iAbi) Ability = 1;
                }

		if ( iFE != (iURanger+3)/5 || Ability)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			string sAbi ="1 ability ";
			string sFE =" 1 favorite enemy ";
			string msg=" You must select ";
			int bFeat;
	                if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
	                else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
			if (iURanger>10 &&  (iURanger-8)%3 == 0) msg = msg+sAbi+" ";
			if (iURanger>1 && (iURanger+8)%5 == 0) msg+=sFE;
			if (iURanger == 1 || iURanger == 4 ||bFeat) msg+= " 1 bonus Feat";
                        
			//FloatingTextStringOnCreature(" Please reselect your feats.", oPC, FALSE);
			FloatingTextStringOnCreature(msg, oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}
		else
		{
		    iURanger++;
		    string msg =" In your next Ultimate Ranger level ,you must select ";
		    int bFeat;
	            if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
	            else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
		    if (iURanger == 1 || iURanger == 4 || bFeat) msg+= " 1 bonus Feat ";
                    if (iURanger>10 &&  (iURanger-8)%3 == 0) msg +="1 Ability ";
                    if (iURanger>1 && (iURanger+8)%5 == 0) msg+=" 1 Favorite Enemy ";
                    if ( msg != " In your next Ultimate Ranger level ,you must select ")
                      FloatingTextStringOnCreature(msg, oPC, FALSE);
		}
	}
}

void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;

	RedWizardFeats(oPC);
	VileFeats(oPC);
	UltiRangerFeats(oPC);
}