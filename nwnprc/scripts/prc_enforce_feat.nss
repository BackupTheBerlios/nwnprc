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

// Enforces the proper selection of the Mage Killer
// Bonus Save feats.
void MageKiller(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Vile feats
// and prevents illegal stacking of them
void VileFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Ultimate Ranger feats
// and prevents illegal use of bonus feats.
void UltiRangerFeats(object oPC = OBJECT_SELF);

// Stops non-Orcs from taking the Blood of the Warlord
// Feat, can be expanded later.
void Warlord(object oPC = OBJECT_SELF);

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


void MageKiller(object oPC = OBJECT_SELF)
{

	int iMK = (GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) + 1) / 2;

int bRefx = GetHasFeat(FEAT_MK_REF_1, oPC) ? 1 : 0;
        bRefx = GetHasFeat(FEAT_MK_REF_2, oPC) ? 2 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_3, oPC) ? 3 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_4, oPC) ? 4 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_5, oPC) ? 5 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_6, oPC) ? 6 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_7, oPC) ? 7 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_8, oPC) ? 8 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_9, oPC) ? 9 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_10, oPC) ? 10 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_11, oPC) ? 11 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_12, oPC) ? 12 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_13, oPC) ? 13 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_14, oPC) ? 14 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_15, oPC) ? 15 : bRefx;

    int bFort = GetHasFeat(FEAT_MK_FORT_1, oPC) ? 1 : 0;
        bFort = GetHasFeat(FEAT_MK_FORT_2, oPC) ? 2 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_3, oPC) ? 3 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_4, oPC) ? 4 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_5, oPC) ? 5 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_6, oPC) ? 6 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_7, oPC) ? 7 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_8, oPC) ? 8 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_9, oPC) ? 9 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_10, oPC) ? 10 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_11, oPC) ? 11 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_12, oPC) ? 12 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_13, oPC) ? 13 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_14, oPC) ? 14 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_15, oPC) ? 15 : bFort;
        	
		int iMKSave = bRefx + bFort;
		
		FloatingTextStringOnCreature("Mage Killer Level: " + IntToString(iMK), oPC, FALSE);
		FloatingTextStringOnCreature("Reflex Save Level: " + IntToString(bRefx), oPC, FALSE);
		FloatingTextStringOnCreature("Fortitude Save Level: " + IntToString(bFort), oPC, FALSE);

		if (iMK != iMKSave)
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You must select an Improved Save Feat. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
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

void Warlord(object oPC = OBJECT_SELF)
{
		if (GetHasFeat(FEAT_BLOOD_OF_THE_WARLORD, oPC) && (GetRacialType(oPC) != RACIAL_TYPE_HALFORC))
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You must be an Orc or Half-Orc to take this feat. Please reselect your feats.", oPC, FALSE);
			DelayCommand(1.0, SetXP(oPC,nOldXP));
		}
}

void Ethran(object oPC = OBJECT_SELF)
{
		if (GetHasFeat(FEAT_ETHRAN, oPC) && (GetGender(oPC) != GENDER_FEMALE))
		{
			int nHD = GetHitDice(oPC);
			int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
			int nOldXP = GetXP(oPC);
			int nNewXP = nMinXPForLevel - 1000;
			SetXP(oPC,nNewXP);
			FloatingTextStringOnCreature("You must be Female to take this feat. Please reselect your feats.", oPC, FALSE);
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
			    +	(GetHasFeat(FEAT_UR_FE_OUTSIDER, oPC))
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
	Warlord(oPC);
	UltiRangerFeats(oPC);
	MageKiller(oPC);
}