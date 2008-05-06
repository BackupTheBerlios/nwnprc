//::///////////////////////////////////////////////
//:: Name           Necropolitan template script
//:: FileName       tmp_m_necropol
//:: 
//:://////////////////////////////////////////////
/* CREATING A NECROPOLITAN
Necropolitan is an acquired template that can be added to
any humanoid or monstrous humanoid (referred to here after as the base creature).
A necropolitan speaks any languages it knew in life, and it
has all the base creature�s statistics and special abilities except
as noted here.

Size and Type: The creature�s type changes to undead, and
it gains the augmented subtype. Do not recalculate base attack
bonus, saves, or skill points. Size is unchanged.

Hit Dice: Increase to d12.

Special Qualities: A necropolitan retains all the special
qualities of the base creature and gains those described below.

Resist Control (Ex): Necropolitans have a +2 profane bonus on their
Will saving throws to resist the effect of a control undead spell.

Turn Resistance (Ex): A necropolitan has +2 turn resistance.

Unnatural Resilience (Ex): Necropolitans automatically heal
hit point damage and ability damage at the same rate as a living
creature. The Heal skill has no effect on necropolitans; however,
negative energy (such as an infl ict spell) heals them.

Abilities: Same as the base creature, except that as undead
creatures, necropolitans have no Constitution score.

Advancement: By character class.

Level Adjustment: Same as the base creature. (Becoming a
necropolitan involves losing a level so the advantages of the undead type
cancel out what would other wise be a larger adjustment.)
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 5/6/08
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;
    
    //NOTE: this maintains the Necropolitan template
    int nIsDemi = GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC);
            
    int nTurnResist = 2;        
    SetCompositeBonus(oSkin, "Template_necropol_turnresist", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);
    
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNDEAD_HD);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_ABILITY_DECREASE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_CRITICAL);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DEATH);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DISEASE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_MIND_SPELLS);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_PARALYSIS);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_POISON);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_SNEAKATTACK);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
     
    SendMessageToPC(oPC, "You have feat Undead HD = "+IntToString(GetHasFeat(FEAT_UNDEAD_HD, oPC)));
    }     

}