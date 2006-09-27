//::///////////////////////////////////////////////
//:: Name      Bibgy's Tripping Hand
//:: FileName  sp_bigby_trip.nss
//:://////////////////////////////////////////////
/**@file Bigby's Tripping Hand
Evocation[Force]
Level: Duskblade 1, sorcerer/wizard 1
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Intantaneous
Saving Throw: Reflex negates
Spell Resistance: Yes

The large hand sweeps at the target creature's legs in
a tripping maneuver.  This trip attempt does not provoke
attacks of opportunity.  Its attack bonus equals your
caster level + your key ability modifier + 2 for the 
hand's Strength score (14).  The hand has a bonus of +1
on the trip attempt for every three caster levels, to a
maximum of +5 at 15th level.

Material component: Three glass beads
**/

int BigbyTripPRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);	
	int nSorcLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
	int nDuskLevel = GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC);
	
	if((nSorcLevel + nDuskLevel) < 1)
	{
		return;
	}
	
	if(nSorcLevel > nDuskLevel)
	{
		nClassType = CLASS_TYPE_SORCERER;
	}
	else
	{
		nClassType = CLASS_TYPE_DUSKBLADE;
	}	
	
	int nAttackBonus = (2 + nCasterLvl +  GetAbilityModifier(GetAbilityForClass(nClassType, oPC)), oPC);
	int nTripBonus = min(5,(nCasterLvl/3));
	
	 int iAttackRoll = BigbyTripDoMeleeTouchAttack(oTarget);
	 if (iAttackRoll > 0)
	 {
		 
	 }
	 
 }	
	
int BigbyTripPRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    string sCacheName = "AttackHasHit_"+ObjectToString(oTarget);
    if(GetLocalInt(oCaster, sCacheName))
        return GetLocalInt(oCaster, sCacheName);
    int nResult = GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, nAttackBonus,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_MELEE_SPELL);
    SetLocalInt(oCaster, sCacheName, nResult);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sCacheName));
    return nResult;
}
