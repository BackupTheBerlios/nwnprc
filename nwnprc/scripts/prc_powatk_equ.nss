//::///////////////////////////////////////////////
//:: Power Attack OnEquip script
//:: prc_powatk_equ
//::///////////////////////////////////////////////
/*
    To prevent abuse of turning power attack on while
    wielding a melee weapon and then switching in
    a ranged weapon, this eventhooked script
    checks for what they equip while powerattacking.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "inc_eventhook"

void main()
{
    object oPC   = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();
    int nPower   = GetLocalInt(oPC, "PRC_PowerAttackSpellID");


    RemoveSpellEffects(nPower, oPC, oPC);
    RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_powatk_equ", TRUE);

    //                   Power Attack Mode Deactivated
    string sMes = "* " + GetStringByStrRef(58282) +  " *";
    FloatingTextStringOnCreature(sMes, oPC, FALSE);

    if(GetHasFeat(FEAT_FAVORED_POWER_ATTACK, oPC))
    {
        ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
}