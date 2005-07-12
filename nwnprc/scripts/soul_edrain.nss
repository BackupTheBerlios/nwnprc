#include "x0_i0_spells"
#include "inc_soul_shift"
#include "prc_inc_combat"

void DoEnergyDrain(object oTarget,int nDamage)
{
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
	{
		SendMessageToPC(OBJECT_SELF, "Cannot drain " + GetName(oTarget) +" is immune.");
	}
	else
	{
		int nLevelMod = GetLocalInt(oTarget, "TargetLevel");
		nLevelMod = nLevelMod - nDamage;
		effect eDrain = EffectNegativeLevel(nDamage);
		eDrain = ExtraordinaryEffect(eDrain);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDrain,oTarget);
		SetLocalInt(oTarget, "TargetLevel", nLevelMod);

		SendMessageToPC(OBJECT_SELF,"You have drained "+ IntToString(nDamage) + 
			" from " + GetName(oTarget) + ", It has " +
			 IntToString(GetLocalInt(oTarget, "TargetLevel")) + " levels left.");
	

		// Soul Strength

		if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 2)
	        {
	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
	        	EffectAbilityIncrease(ABILITY_STRENGTH, 4), OBJECT_SELF,
	        	HoursToSeconds(24));
	        }

		// Soul Endurance

		if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 5)
	        {
	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
	        	EffectAbilityIncrease(ABILITY_CONSTITUTION, 4), OBJECT_SELF,
	        	HoursToSeconds(24));
	        }

		// Soul Agililty

		if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 8)
	        {
	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
	        	EffectAbilityIncrease(ABILITY_DEXTERITY, 4), OBJECT_SELF,
	        	HoursToSeconds(24));
	        }

		// Soul Enchancement

		if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 4)
        	{
        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
        		EffectSavingThrowIncrease(SAVING_THROW_TYPE_ALL, 2), OBJECT_SELF,
	        	HoursToSeconds(24));

        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
        		EffectSkillIncrease(SKILL_ALL_SKILLS, 2), OBJECT_SELF,
        		HoursToSeconds(24));
	        }

	}
}

void main()
{


	object oTarget = GetSpellTargetObject();
	string sTarget = GetResRef(oTarget);
	string sName = GetName(oTarget);
	int nDamage = 1;
	int nBaseLevel = GetLevelByPosition(1, oTarget) + GetLevelByPosition(2, oTarget)
					    + GetLevelByPosition(3, oTarget);

	effect eBlood = EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE);

	

	if (!GetLocalInt(oTarget, "TargetLevel"))
	{
		SetLocalInt(oTarget, "TargetLevel", nBaseLevel);
	}

	int nLevel = GetLocalInt(oTarget, "TargetLevel");



	if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) < 7)
	{
		nDamage = 1;
	}
	else
	{
		nDamage = 2;
	}

	ApplyEffectToObject(DURATION_TYPE_INSTANT,eBlood, oTarget);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

	
	// Do a melee touch attack.
	int bHit = (TouchAttackMelee(oTarget,TRUE)>0) ;
	if (!bHit)
	{
		return;
	}


	// Soul Slave Feat

	if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) > 8)
	{
		if (nLevel < 3)
		{
			string sSummon = "soul_wight_test";
			 
			RecognizeCreature(OBJECT_SELF, sTarget, sName);

			if (GetMaxHenchmen() < 3)
			{
			SetMaxHenchmen(3);
			}

			object oCreature = CreateObject(OBJECT_TYPE_CREATURE,
							sSummon,GetSpellTargetLocation());

			AddHenchman(OBJECT_SELF, oCreature);
			object oMaster = GetMaster(oCreature);
			int nTargetLevelUp = GetLevelByPosition(1, OBJECT_SELF) 
				+ GetLevelByPosition(2, OBJECT_SELF) +
				 GetLevelByPosition(3, OBJECT_SELF) - 1;
			int nWightLevel = GetLevelByPosition(1, oCreature);


			if (nWightLevel < nTargetLevelUp)
			{
				LevelUpHenchman(oCreature, CLASS_TYPE_UNDEAD, FALSE, PACKAGE_UNDEAD);
			}

		}
		DoEnergyDrain(oTarget, nDamage);
	}

	else if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 7)
	{
		if(nLevel < 3)
		{
			RecognizeCreature(OBJECT_SELF, sTarget, sName);
		}
		DoEnergyDrain(oTarget, nDamage);
	}


	else if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 6)
	{

		if (nLevel < 2)
		{
			//SendMessageToPC(OBJECT_SELF, "Preforming Inner Conditional Level 6"); 
			RecognizeCreature(OBJECT_SELF, sTarget, sName);
		}
		DoEnergyDrain(oTarget, nDamage);
	}
 
        else
        {
		//SendMessageToPC(OBJECT_SELF, "Preforming ELSE");
	    
		DoEnergyDrain(oTarget, nDamage);

        }


    
    
}