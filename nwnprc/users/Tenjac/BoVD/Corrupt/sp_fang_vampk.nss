//::///////////////////////////////////////////////
//:: Name:      Fangs of the Vampire King
//:: Filename:  sp_fang_vampk.nss
//::///////////////////////////////////////////////
/**@file Fangs of the Vampire King
Transmutation [Evil]
Level: Corrupt 2
Components: S, Corrupt 
Casting Time: 1 action 
Range: Personal
Target: Caster
Duration: 1 minute/level

The caster grows vampirelike fangs that allow him
to make bite attacks with an attack bonus of +10 
plus the caster's Strength modifier. The caster's
bite attack deals 1d6 points of damage and 1 point
of Constitution damage. 

Corruption Cost: 1d6 points of Strength damage. 

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void GetBiteWeapon(object oPC, string sResRef, int nInventorySlot, float fDuration);

#include "spinc_common"

void main()
{
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	
	//Set School
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	//var
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nBonus = (10 + GetAbilityModifier(ABILITY_STRENGTH, oPC));
	float fDuration = 60.0f + nCasterLvl;
	
	//Get or create weapon
	object oChompers = GetBiteWeapon(oPC, "PRC_UNARMED_S", INVENTORY_SLOT_CWEAPON_B, fDuration);
	
	//Corruption cost
	DoCorruptionCost(oPC, ABILITY_STRENGTH, d6(1), 0);
	
	//Alignment shift
	SPEvilShift(oPC);	
	SPSetSchool();
}

object GetBiteWeapon(object oPC, string sResRef, int nInventorySlot, float fDuration))

int bCreatedWeapon = FALSE;
    object oCWeapon = GetItemInSlot(nInventorySlot, oCreature);

    RemoveUnarmedAttackEffects(oCreature);
    // Make sure they can actually equip them
    UnarmedFeats(oCreature);

    // Determine if a creature weapon of the proper type already exists in the slot
    if(!GetIsObjectValid(oCWeapon)                                       ||
       GetStringUpperCase(GetTag(oCWeapon)) != GetStringUpperCase(sResRef) // Hack: The resref's and tags of the PRC creature weapons are the same
       )
    {
        if (GetHasItem(oCreature, sResRef))
        {
            oCWeapon = GetItemPossessedBy(oCreature, sResRef);
            SetIdentified(oCWeapon, TRUE);
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
        }
        else
        {
            oCWeapon = CreateItemOnObject(sResRef, oCreature);
            SetIdentified(oCWeapon, TRUE);
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
            bCreatedWeapon = TRUE;
        }
    }


    // Clean up the mess of extra fists made on taking first level.
    DelayCommand(6.0f, LocalCleanExtraFists(oCreature));

    // Weapon finesse or intuitive attack?
    SetLocalInt(oCreature, "UsingCreature", TRUE);
    ExecuteScript("prc_intuiatk", oCreature);
    DelayCommand(1.0f, DeleteLocalInt(oCreature, "UsingCreature"));

    // Add OnHitCast: Unique if necessary
    if(GetHasFeat(FEAT_REND, oCreature))
        IPSafeAddItemProperty(oCWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    // This adds creature weapon finesse
    ApplyUnarmedAttackEffects(oCreature);

    // Destroy the weapon if it was created by this function
    if(bCreatedWeapon)
        DestroyObject(oCWeapon, (fDuration + 6.0));

    return oCWeapon;
}
