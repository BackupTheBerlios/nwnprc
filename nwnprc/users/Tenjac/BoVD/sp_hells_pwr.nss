//::///////////////////////////////////////////////
//:: Name      Hell's Power
//:: FileName  sp_hells_pwr
//:://////////////////////////////////////////////
/**@file Hell's Power
Conjuration (Creation) [Evil] 
Level: Blk 3, Clr 4, Sor/Wiz 4
Components: V, S, M, Devil 
Casting Time: 1 action
Range: Personal 
Target: Caster 
Duration: 10 minutes/level
 
The caster summons evil energy from the Nine Hells 
and bathes himself in its power. The caster gains a 
+2 deflection bonus to Armor Class, as well as an 
upgrade of his existing damage reduction by /+1 
(DR 10/+1 becomes DR 10/+2, for example).

Material Component: The heart of an elf child.

Author:    Tenjac
Created:   5/16/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (nCasterLvl * 600.0f);
	int nType = MyPRCGetRacialType(oPC);
	int nAlignEvil = GetAlignmentGoodEvil(oPC);
	int nAlignLaw = GetAlignmentLawChaos(oPC);
	
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	//must be devil
	if(nType == RACIAL_TYPE_OUTSIDER &&
	   nAlignEvil == ALIGNMENT_EVIL &&
	   nAlignLaw == ALIGNMENT_LAWFUL)
	{
		effect eArmor = EffectACIncrease(nACBonus, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL);
		effect eTest = GetFirstEffect	
	
	
	