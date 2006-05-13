//::///////////////////////////////////////////////
//:: Name      Grim Revenge
//:: FileName  sp_grim_revng.nss
//:://////////////////////////////////////////////
/**@file Grim Revenge 
Necromancy [Evil] 
Level: Sor/Wiz 4 
Components: V, S, Undead 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Target: One living humanoid 
Duration: Instantaneous 
Saving Throw: Fortitude negates 
Spell Resistance: Yes

The hand of the subject tears itself away from one
of his arms, leaving a bloody stump. This trauma 
deals 6d6 points of damage. Then the hand, animated
and floating in the air, begins to attack the 
subject. The hand attacks as if it were a wight
(see the Monster Manual) in terms of its statistics,
special attacks, and special qualities, except that
it is considered Tiny and gains a +4 bonus to AC
and a +4 bonus on attack rolls. The hand can be 
turned or rebuked as a wight. If the hand is 
defeated, only a regenerate spell can restore the 
victim to normal.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nType = MyPRCGetRacialType(oPC);
	int nModelNumber = 0;
	int bLeftHandMissing;
	int bRightHandMissing;
	int bLeftAnimated = FALSE;
	int bRightAnimated = FALSE;
	
	if(GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oTarget) == nModelNumber))
	{
		nLeftHandMissing = TRUE;
	}
	
	if(GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oTarget) == nModelNumber))	
	{
		nRightHandMissing = TRUE;
	}
	
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_GRIM_REVENGE, oPC);
	
	//Check for undead
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		//Check Spell Resistance
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Will save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				int nDam = d6(6);
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 36;
				}
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
				
				//Remove hand from oTarget - left hand first?
				//http://nwn.bioware.com/players/167/scripts_commandslist.html
				
				if(!bLeftHandMissing)
				{
					//deal damage
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
					
					SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oTarget);
					SetPersistantLocalInt(oTarget, "LEFT_HAND_USELESS", 1);
					
					//Force unequip
					ForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget), INVENTORY_SLOT_LEFTHAND, TRUE);
					
					bLeftAnimated = TRUE;
				}
				
				else if(!bRightHandMissing)
				{
					//deal damage
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
					
					SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oTarget);
					SetPersistantLocalInt(oTarget, "RIGHT_HAND_USELESS", 1);
					
					//Force unequip
					ForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget), INVENTORY_SLOT_RIGHTHAND, TRUE);
					
					bRightAnimated = TRUE;
				}
				
				else
				{
					SendMessageToPC(oPC, "Your target has no hands!");
				}
				
				//Create copy of target, set all body parts null
								
				object oHand = CopyObject(oTarget, GetLocation(oTarget), OBJECT_INVALID);
												
				SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_PELVIS, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_TORSO, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_BELT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_NECK, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_HEAD, nModelNumber, oHand);
				
				if(!bLeftAnimated)
				{
					SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oHand);
				}
				
				if(!bRightAnimated)
				{
					SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oHand);
				}
				
				//Make hand hostile to target
				
				