#include "et_greatreachtouchspells"
#include "et_spellblastaoespells"

const int CLASS_TYPE_ELDRITCHTHEURGE=102;


/*//////////////////////////////////////////////////////////////////////////////////////*/	
//																						//
//									USED FUNCTIONS										//
//																						//
/*//////////////////////////////////////////////////////////////////////////////////////*/

int GetArcaneETCasterLevel(object oChar=OBJECT_SELF)
{
	int nCaster=0;
	if (GetHasFeat(1581)) nCaster=GetLevelByClass(CLASS_TYPE_BARD);
	if (GetHasFeat(1569)) nCaster=GetLevelByClass(CLASS_TYPE_SORCERER);
	if (GetHasFeat(1570)) nCaster=GetLevelByClass(CLASS_TYPE_WIZARD);
	nCaster += GetLevelByClass(CLASS_TYPE_ELDRITCHTHEURGE);
	if (GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT)>0) nCaster += (GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT)-1);
	if (GetLevelByClass(CLASS_TYPE_PALEMASTER)>0) nCaster += (GetLevelByClass(CLASS_TYPE_PALEMASTER)-1);
	if (GetLevelByClass(CLASS_TYPE_HARPER)>0) nCaster += (GetLevelByClass(CLASS_TYPE_HARPER)-1);
	return nCaster;
}
// Gets the Hexadecimal number in the 2da and checks if it is an AOE type (note that some types which are clearly AoE are not marked as such, for example fireburst)
int IsSpellAoEType(int nSpellID) 
{
	switch (nSpellID)
	{
		case 0: return TRUE; break;
		case 10: return TRUE; break;
		case 14: return TRUE; break;
		case 18: return TRUE; break;
		case 23: return TRUE; break;
		case 24: return TRUE; break;
		case 25: return TRUE; break;
		case 26: return TRUE; break;
		case 36: return TRUE; break;
		case 39: return TRUE; break;
		case 41: return TRUE; break;
		case 54: return TRUE; break;
		case 58: return TRUE; break;
		case 66: return TRUE; break;
		case 67: return TRUE; break;
		case 75: return TRUE; break;
		case 89: return TRUE; break;
		case 101: return TRUE; break;
		case 110: return TRUE; break;
		case 111: return TRUE; break;
		case 118: return TRUE; break;
		case 122: return TRUE; break;
		case 135: return TRUE; break;
		case 163: return TRUE; break;
		case 165: return TRUE; break;
		case 167: return TRUE; break;
		case 171: return TRUE; break;
		case 190: return TRUE; break;
		case 191: return TRUE; break;
		case 192: return TRUE; break;
		case 193: return TRUE; break;
		case 367: return TRUE; break;
		case 368: return TRUE; break;
		case 373: return TRUE; break;
		case 375: return TRUE; break;
		case 427: return TRUE; break;
		case 430: return TRUE; break;
		case 436: return TRUE; break;
		case 440: return TRUE; break;
		case 445: return TRUE; break;
		case 447: return TRUE; break;
		case 448: return TRUE; break;
		case 520: return TRUE; break;
		case 523: return TRUE; break;
		case 526: return TRUE; break;
		case 528: return TRUE; break;
		case 569: return TRUE; break;
		case 851: return TRUE; break;
		case 854: return TRUE; break;
		case 855: return TRUE; break;
		case 863: return TRUE; break;
		case 869: return TRUE; break;
		case 873: return TRUE; break;
		case 881: return TRUE; break;
		case 887: return TRUE; break;
		case 900: return TRUE; break;
		case 1016: return TRUE; break;
		case 1017: return TRUE; break;
		case 1033: return TRUE; break;
		case 1034: return TRUE; break;
		case 1036: return TRUE; break;
		case 1037: return TRUE; break;
		case 1038: return TRUE; break;
		case 1039: return TRUE; break;
		case 1045: return TRUE; break;
	}
	return FALSE;
}

// Below code works perfectly, were it not for the fact that many AoE spells are not marked in the spells.2da
// as having an area/ground target type, even though they DO effect an erea. So I chose the manual switch statement.
/*	string sTarget = Get2DAString("spells", "TargetType", nSpellID);
	int nLeft=0;
	int nRight=0;
	string LastTwoDigits=GetStringRight(sTarget, 2);   
	string n2=GetStringLeft(LastTwoDigits, 1);		//0-15 times 16
	string n1=GetStringRight(LastTwoDigits, 1);		//0-15 times 1
		
	if (n1=="A") nRight=10;
	else if (n1=="B") nRight=11;
	else if (n1=="C") nRight=12;
	else if (n1=="D") nRight=13;
	else if (n1=="E") nRight=14;
	else if (n1=="F") nRight=15;
	else nRight=StringToInt(n1);
	
	if (n2=="A") nLeft=160;
	else if (n2=="B") nLeft=176;
	else if (n2=="C") nLeft=192;
	else if (n2=="D") nLeft=208;
	else if (n2=="E") nLeft=224;
	else if (n2=="F") nLeft=240;
	else nLeft=(StringToInt(n2)*16);
	
	int nInt = nLeft+nRight;
	
	if (nInt & 4) return TRUE;
	else return FALSE; 
}*/

// Determines if a spell is a touch attack spell
int IsSpellTouchAttack(int nSpellID)
{
	switch (nSpellID)
	{	//Touch attacks for Greatreach Blast
		case 4: return TRUE; break;
		case 22: return TRUE; break;
		case 64: return TRUE; break;
		case 188: return TRUE; break;
		case 518: return TRUE; break;
		case 847: return TRUE; break;
		case 1051: return TRUE; break;
	}
	return FALSE;
	
	/* Same as above, code works, but above is just as easy and probably faster
	
	string sTouch = Get2DAString("spells", "Range", nSpellID);
	if (sTouch=="T") return TRUE;
	else return FALSE;*/
}

// Checks to see if the character has a certain class and returns classposition if it does.
int HasClass(int nClassID, object oChar=OBJECT_SELF)
{
	int nClassPos=0;
	if (GetClassByPosition(1)==nClassID) nClassPos=1; 
	else if (GetClassByPosition(2)==nClassID) nClassPos=2; 
	else if (GetClassByPosition(3)==nClassID) nClassPos=3; 
	else if (GetClassByPosition(4)==nClassID) nClassPos=4; 
	return nClassPos;
		
}

/*//////////////////////////////////////////////////////////////////////////////////////*/	
//																						//
//								ELDRITCH THEURGE ESSENCES								//
//							   (moved to invocation script)								//
/*//////////////////////////////////////////////////////////////////////////////////////*/

/*
void DoGreatreachEssence(object oCaster, object oTarget)
{
	int nCasterLevel = GetArcaneETCasterLevel(oCaster);
	int nSpellID=GetLocalInt(OBJECT_SELF, "GreatreachSpell");
	int nMetaMagic=GetLocalInt(OBJECT_SELF, "GreatreachMeta");
	
	if (GetHasSpell(nSpellID)!= FALSE) 
	{	
		DecrementRemainingSpellUses(OBJECT_SELF, nSpellID);
		switch (nSpellID)
		{	//Touch attacks for Greatreach Blast
			case 4: DoETBestowCurse(oTarget); break;
			case 22: DoETContagion(oTarget); break;
			case 64: DoETGhoulTouch(oTarget, nMetaMagic); break;
			case 188: DoETVampiricTouch(oTarget, nMetaMagic, nCasterLevel);  break;
			case 518: DoETCombust(oTarget, oCaster, nCasterLevel, nMetaMagic); break;
			case 847: DoETShockingGrasp(oTarget, nCasterLevel, nMetaMagic); break;
		}
	}
}

void DoSpellBlastEssence(object oCaster, object oTarget)
{
	int nCasterLevel = GetArcaneETCasterLevel(oCaster);
	location lTarget = GetLocation(oTarget);
	int nSpellID=GetLocalInt(OBJECT_SELF, "SpellblastSpell");
	int nMetaMagic=GetLocalInt(OBJECT_SELF, "SpellblastMeta");
	
	if (GetHasSpell(nSpellID)!= FALSE) 
		{	
			DecrementRemainingSpellUses(OBJECT_SELF, nSpellID);
			switch (nSpellID)
			{
				case 0: DoETAoEAcidFog(nCasterLevel, nMetaMagic, lTarget); break;
				case 10: DoETAoEBurningHands(nCasterLevel, nMetaMagic, lTarget); break;
				case 18: DoETAoECircleOfDeath(nCasterLevel, nMetaMagic, lTarget); break;
				case 23: DoETAoECloudkill(nCasterLevel, nMetaMagic, lTarget); break;
				case 24: DoETAoEColorSpray(nCasterLevel, nMetaMagic, lTarget); break;
				case 25: DoETAoEConeOfCold(nCasterLevel, nMetaMagic, lTarget); break;
				case 26: DoETAoEConfusion(nCasterLevel, nMetaMagic, lTarget); break;
				case 36: DoETAoEDarkness(nCasterLevel, nMetaMagic, lTarget, oTarget); break;
				case 39: DoETAoEDelayedBlastFireball(nCasterLevel, nMetaMagic, lTarget); break;
				case 41: DoETAoEDispelMagic(nCasterLevel, nMetaMagic, lTarget); break;
				case 54: DoETAoEFear(nCasterLevel, nMetaMagic, lTarget); break;
				case 58: DoETAoEFireball(oCaster, nCasterLevel, nMetaMagic, lTarget); break;
				case 66: DoETAoEGrease(nCasterLevel, nMetaMagic, lTarget); break;
				case 67: DoETAoEGreaterDispelMagic(nCasterLevel, nMetaMagic, lTarget); break;
				case 75: DoETAoEGustOfWind(nCasterLevel, nMetaMagic, lTarget); break;
				case 89: DoETAoEIncendiaryCloud(nCasterLevel, nMetaMagic, lTarget); break;
				case 110: DoETAoEMassBlindnessDeafness(nCasterLevel, nMetaMagic, lTarget); break;
				case 111: DoETAoEMassCharmMonster(nCasterLevel, nMetaMagic, lTarget); break;
				case 118: DoETAoEMindFog(nCasterLevel, nMetaMagic, lTarget); break;
				case 122: DoETAoEMordenkainensDisjunction(nCasterLevel, nMetaMagic, lTarget); break;
				case 135: DoETAoEPrismaticSpray(nCasterLevel, nMetaMagic, lTarget); break;
				case 165: DoETAoESleep(nCasterLevel, nMetaMagic, lTarget); break;
				case 171: DoETAoEStinkingCloud(nCasterLevel, nMetaMagic, lTarget); break;
				case 190: DoETAoEWailOfTheBanshee(nCasterLevel, nMetaMagic, lTarget); break;
				case 191: DoETAoEWallOfFire(nCasterLevel, nMetaMagic, lTarget); break;
				case 192: DoETAoEWeb(nCasterLevel, nMetaMagic, lTarget); break;
				case 193: DoETAoEWeird(nCasterLevel, nMetaMagic, lTarget); break;
				case 367: DoETAoEHorridWilting(nCasterLevel, nMetaMagic, lTarget); break;
				case 368: DoETAoEIceStorm(nCasterLevel, nMetaMagic, lTarget); break;
				case 375: DoETAoEEvardsBlackTentacles(nCasterLevel, nMetaMagic, lTarget); break;
				case 427: DoETAoESunburst(nCasterLevel, nMetaMagic, lTarget); break;
				case 430: DoETAoEBanishment(nCasterLevel, nMetaMagic, lTarget); break;
				case 436: DoETAoEBalagarsIronHorn(nCasterLevel, nMetaMagic, lTarget); break;
				case 440: DoETAoEFirebrand(nCasterLevel, nMetaMagic, lTarget, oTarget); break;
				case 447: DoETAoEIsaacsLesserMissileStorm(nCasterLevel, nMetaMagic, lTarget, oTarget); break;
				case 448: DoETAoEIsaacsGreaterMissileStorm(nCasterLevel, nMetaMagic, lTarget, oTarget); break;
				case 520: DoETAoEGedleesElectricLoop(nCasterLevel, nMetaMagic, lTarget); break;
				case 523: DoETAoEMestilsAcidBreath(nCasterLevel, nMetaMagic, lTarget); break;
				case 526: DoETAoEScintillatingSphere(nCasterLevel, nMetaMagic, lTarget); break;
				case 528: DoETAoEUndeathToDeath(nCasterLevel, nMetaMagic, lTarget); break;
				case 569: DoETAoECloudOfBewilderment(nCasterLevel, nMetaMagic, lTarget); break;
				case 851: DoETAoEFireburst(nCasterLevel, nMetaMagic, lTarget); break;
				case 854: DoETAoEScare(nCasterLevel, nMetaMagic, lTarget, oTarget); break;
				case 855: DoETAoEDeepSlumber(nCasterLevel, nMetaMagic, lTarget); break;
				case 869: DoETAoEGreaterFireburst(nCasterLevel, nMetaMagic, lTarget); break;
				case 873: DoETAoEVitriolicSphere(nCasterLevel, nMetaMagic, lTarget); break;
				case 881: DoETAoEMassHoldPerson(nCasterLevel, nMetaMagic, lTarget); break;
				case 887: DoETAoEMassHoldMonster(nCasterLevel, nMetaMagic, lTarget); break;
			}
		}
} */