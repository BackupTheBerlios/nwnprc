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
	/*
	
	[10:42] <Tenjac> I'm not sure how to go about doing the magical weapon part... in essence, when a character with Starmantle on them gets hit by a +1 or better weapon, they get a save at DC15 to take only half damage
	[10:43] <Tenjac> I'm compeletely clueless as to how I'm going to pull that off.
	[10:43] <Primogenitor> this is a spell, right?
	[10:43] <Tenjac> yep
	[10:43] <Tenjac> has an event script already
	[10:44] <Tenjac> Some ideas were to add back half damage, or to give 50% resistance to all and deal damage again if they fail the save
	[10:44] <Primogenitor> Well, the only way to do it is an Onhit event on the defenders armor/hide, get the attackers weapon, if its +1 or more make the save and heal half the damage back
	[10:45] <Primogenitor> Dealing damage again gets fugly with other resistances and DR
	[10:45] <Tenjac> ok, but how do I get the damage?
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
	[10:55] <Primogenitor> Run some tests first to make sure those functions can be used.
	[10:55] <Primogenitor> I vaguely remember something fruity about them
	[10:57] <Tenjac> At work, so I'll have to test later :P
	[11:00] <Primogenitor> Amen to that ;)
	[11:01] <Tenjac> hehe
	[11:01] <Primogenitor> But there is nothing worse than assuming someting workes one way, then finding out it works a completely different way
	[11:10] <Tenjac> oh yeah... not good :P
        [11:11] <Tenjac> hopefully that will do it
*/
}

	
	
	
	
	
	
	
		