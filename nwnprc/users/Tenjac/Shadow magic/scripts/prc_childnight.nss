/////////////////////////////////////////////////////////
// Child of Night passive feat script
// prc_childnight.nss
/////////////////////////////////////////////////////////

#include "prc_alterations"


void main()
{
	//define vars    
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nLevel = GetLevelByClass(CLASS_TYPE_CHILD_OF_NIGHT, oPC);
	int nColdResist = IP_CONST_DAMAGERESIST_15;
	
	//Cold Resistance
	if(nLevel < 9)
	{
		if(nLevel > 4)
		{
			nColdResist = IP_CONST_DAMAGERESIST_10;
		}
		
		else
		{
			nColdResist = IP_CONST_DAMAGERESIST_5;
		}
	}
	
	IPSafeAddItemProperty= ItemPropertyDamageResistance(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, nColdResist), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	
	//Cloak of Shadows
	if(nLevel > 7)
	{
		SPAppplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(20)), oPC);
	}
}
    