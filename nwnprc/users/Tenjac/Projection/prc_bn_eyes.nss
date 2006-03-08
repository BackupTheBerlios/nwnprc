#include spinc_common
#include "prc_class_const"


void main ()
{
	//declare variables
	object oPC = OBJECT_SELF;
	effect eBaelnEyes = EffectVisualEffect(VFX_BAELN_EYES);   
	
	//Apply eyes
	if(GetLevelByClass(CLASS_TYPE_BAELNORN, oPC)> 0
	{
		if("APPLY_BAELNORN_EYES")
		{
			if(!GetHasSpellEffect(SPELL_BAELNEYES, oPC))
			{	
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBaelnEyes, oPC);
				DeleteLocalInt(oPC, "APPLY_BAELNORN_EYES");
			}
		}
		else
		RemoveSpellEffects(SPELL_BAELNEYES, oPC)
	}
	else
	
	//Remove
	RemoveSpellEffects(SPELL_BAELNEYES, oPC)
	RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_bn_eyes", TRUE, FALSE);
	RemoveEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM,    "prc_bn_eyes", TRUE, FALSE);
}
	
	
	