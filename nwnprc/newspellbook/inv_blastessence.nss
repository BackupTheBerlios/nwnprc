//::///////////////////////////////////////////////
//:: Warlock Eldritch Blast Essences
//:: inv_blastessence.nss
//::///////////////////////////////////////////////
/*
    Handles the Essence invocations for Warlocks
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 29, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
	object oPC = OBJECT_SELF;
	
	if(GetLocalInt(oPC, "BlastEssence") == GetSpellId())
	{
	    DeleteLocalInt(oPC, "BlastEssence");
		DeleteLocalInt(oPC, "EssenceLevel");
		FloatingTextStringOnCreature("*Blast Essence Removed*", oPC, FALSE);
		return;
	}
	
	SetLocalInt(oPC, "BlastEssence", GetSpellId());
	
	switch(GetSpellId())
	{
		case INVOKE_FRIGHTFUL_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 2);
		     FloatingTextStringOnCreature("*Frightful Blast Essence Applied*", oPC, FALSE);
		     break;
		     
		case INVOKE_HAMMER_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 2);
		     FloatingTextStringOnCreature("*Hammer Blast Essence Applied*", oPC, FALSE);
		     break;		     
		     
		case INVOKE_SICKENING_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 2);
		     FloatingTextStringOnCreature("*Sickening Blast Essence Applied*", oPC, FALSE);
		     break;		     
		     
		case INVOKE_BANEFUL_BLAST_ABBERATION:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Abberation Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_BANEFUL_BLAST_BEAST:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Beast Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_CONSTRUCT:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Construct Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_DRAGON:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Dragon Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_DWARF:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Dwarf Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_ELEMENTAL:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Elemental Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_ELF:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Elf Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_FEY:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Fey Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_GIANT:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Giant Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_GOBLINOID:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Goblinoid Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_GNOME:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Gnome Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_HALFLING:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Halfling Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_HUMAN:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Human Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_MONSTEROUS:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Monstrous Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_ORC:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Orc Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_OUTSIDER:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Outsider Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_PLANT:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Plant Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_REPTILIAN:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Reptilian Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_SHAPECHANGER:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Shapechanger Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_UNDEAD:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Undead Blast Essence Applied*", oPC, FALSE);
		     break;	     	     
		     
		case INVOKE_BANEFUL_BLAST_VERMIN:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Vermin Blast Essence Applied*", oPC, FALSE);
		     break;	          
		     
		case INVOKE_BESHADOWED_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 4);
		     FloatingTextStringOnCreature("*Beshadowed Blast Essence Applied*", oPC, FALSE);
		     break;	          
		     
		case INVOKE_BRIMSTONE_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 3);
		     FloatingTextStringOnCreature("*Brimstone Blast Essence Applied*", oPC, FALSE);
		     break;	          
		     
		case INVOKE_HELLRIME_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 4);
		     FloatingTextStringOnCreature("*Hellrime Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_BEWITCHING_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 4);
		     FloatingTextStringOnCreature("*Bewitching Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_HINDERING_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 4);
		     FloatingTextStringOnCreature("*Hindering Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_NOXIOUS_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 6);
		     FloatingTextStringOnCreature("*Noxious Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_PENETRATING_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 6);
		     FloatingTextStringOnCreature("*Penetrating Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_VITRIOLIC_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 6);
		     FloatingTextStringOnCreature("*Vitriolic Blast Essence Applied*", oPC, FALSE);
		     break;	         
		     
		case INVOKE_BINDING_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 7);
		     FloatingTextStringOnCreature("*Binding Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
		case INVOKE_UTTERDARK_BLAST:
		     SetLocalInt(oPC, "EssenceLevel", 8);
		     FloatingTextStringOnCreature("*Utterdark Blast Essence Applied*", oPC, FALSE);
		     break;	     
		     
	}
}