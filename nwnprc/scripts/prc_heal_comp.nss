/*
Type of Feat: Class
Prerequisite: Healer 8
Specifics: Gain a companion
Use: Selected.
*/

const int HEALER_COMP_UNICORN = 1845;
const int HEALER_COMP_LAMMASU = 1846;
const int HEALER_COMP_ANDRO   = 1847;

#include "prc_alterations"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellId = PRCGetSpellId();
    string sSummon;
    int nHD;
    int nClass = GetLevelByClass(CLASS_TYPE_HEALER, oCaster);
    if (HEALER_COMP_UNICORN == nSpellId)      
    {
    	sSummon = "prc_sum_unicorn";
    	nHD = 4;
    }
    else if (HEALER_COMP_LAMMASU == nSpellId && nClass >= 12)      
    {
    	sSummon = "prc_sum_lammasu";
    	nClass -= 4;
    	nHD = 7;
    }
    else if (HEALER_COMP_ANDRO == nSpellId && nClass >= 16)      
    {
    	sSummon = "prc_sum_andro";
    	nClass -= 8;
    	nHD = 12;
    }
    
    int nMax = GetMaxHenchmen();
    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, i);
    while (GetIsObjectValid(oHench))
    {
        if (GetTag(oHench) == "prc_heal_comp")
	{
            FloatingTextStringOnCreature("You already have a Companion", oCaster, FALSE);
            return;
        }
        i += 1;
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, i);
    }
    
    if (i >= nMax) SetMaxHenchmen(i+1);
    
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);    
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation(), FALSE, "prc_heal_comp");
    AddHenchman(oCaster, oCreature);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCreature));
    SetLocalObject(oCaster, "HealerCompanion", oCreature);
    
    // Apply the effects from the level in the class
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    // Always gets IEvasion
    int nIPFeat = IP_CONST_FEAT_IMPEVASION;
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIPFeat), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    
    if (nClass >= 12)
    {
    	int nArmour = 2;
    	int nStat = 2;
    	nHD += 2;
    	
    	if (nClass >= 18) 
    	{
    		nArmour += 2;
    		nHD += 2;
    		effect eMove = EffectMovementSpeedIncrease(33);
    		effect eSR = EffectSpellResistanceIncrease(nClass);
    		
    		effect eLink2 = EffectLinkEffects(eSR, eMove);
    		eLink2 = SupernaturalEffect(eLink2);
		    
    		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oCreature);
    	}
	if (nClass >= 15) 
	{
		nArmour += 2;
		nHD += 2;
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
		eSave = SupernaturalEffect(eSave);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oCreature);
	}
	// Epic bonuses
	if (nClass >= 24) { nArmour += 2; nHD += 2; nStat += 1;}
	if (nClass >= 28) { nArmour += 2; nHD += 2; nStat += 1;}
	if (nClass >= 32) { nArmour += 2; nHD += 2; nStat += 1;}
	if (nClass >= 36) { nArmour += 2; nHD += 2; nStat += 1;}
	if (nClass >= 40) { nArmour += 2; nHD += 2; nStat += 1;}
    	
    	effect eAC  = EffectACIncrease(nArmour);
    	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStat);
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nStat);
        effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, nStat);
        effect eLink = EffectLinkEffects(eAC, eStr);
        eLink = EffectLinkEffects(eLink, eDex);
        eLink = EffectLinkEffects(eLink, eInt);
        eLink = SupernaturalEffect(eLink);
    
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);
    }
    
    // Level the creature to its proper HD
    // This is done so the bonus HP can be added later
    int n;
    for(n=1;n<nHD;n++)
    {
    	LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
    }      
    
    SetMaxHenchmen(nMax);
}