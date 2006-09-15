//::///////////////////////////////////////////////
//:: Name      Starmantle Onhit: Destroy Non-magical weapons
//:: FileName  prc_evnt_strmtl.nss
//:://////////////////////////////////////////////
/*
The starmantle renders the wearer impervious to 
non-magical weapon attacks and transforms any 
non-magical weapon or missile that strikes it 
into harmless light, destroying it forever. 
Contact with the starmantle does not destroy 
magic weapons or missiles, but the starmantle's 
wearer is entitled to a Reflex saving throw 
(DC 15) each time he is struck by such a weapon;
success indicates that the wearer takes only 
half damage from the weapon (rounded down).

Author:    Tenjac
Created:   7/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//Get attacker that hit
	object oSpellOrigin = OBJECT_SELF;
	object oSpellTarget = PRCGetSpellTargetObject();
	object oItem        = GetSpellCastItem();
	object oWeaponR     = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
	object oWeaponL     = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
	object oTarget;
	
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
		
	//If non-magical weapon in right hand
	if(GetIsObjectValid(oWeaponR) && !GetIsMagical(oWeaponR))
	{
		DestroyObject(oWeaponR);
		return;
	}
	
	//if non-magical weapon in left hand
	else if(GetIsObjectValid(oWeaponL) && !GetIsMagical(oWeaponL))
	{
		DestroyObject(oWeaponL);
		return;
	}
		
	//else we have a magical weapon
	else
	{
		if(PRCMySavingThrow(SAVING_THROW_REFLEX, GetLastDamager(), 15, SAVING_THROW_TYPE_NONE))
		{
			nDam = GetTotalDamageDealt() / 2;
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDam), oSpellOrigin);
		}
	}
	
	/*
		
	[10:45] <Primogenitor> GetLastDamager() will get the attacker
	[10:46] <Primogenitor> GetTotalDamageDealt() compared to a local int from the previous hit (and also put in the original spellscript too)
	[10:46] <Primogenitor> Or GetDamageDealtByType() in a loop would be better, but check on its behaviour with multiple hits etc.
	[10:47] <Tenjac> aren't those only usable within the ondamage event or something like that
	[10:47] <Tenjac> ?
	[10:48] <Primogenitor> Kind of, hence why you should check its behavior
	[10:48] <Primogenitor> I think they are only updated during OnDamaged, but you can get the values at other times. They just might not make as much sense
	[10:49] <Primogenitor> In effect, an OnHit event is much the same as an OnDamaged event
	[10:53] <Tenjac> right
	[10:53] <Tenjac> well, hopefully that will work.  THanks :P
	        
        Georg Zoeller: It depends on whether OnDamage or OnHit fires first. If OnDamage fires first, you could set the damage in a variable and retrieve
        it from OnHit.  
        
        If OnHit fires first, you might have a problem, not sure if there is a good solution to this.
*/
}

	
	
	
	
	
	
	
		