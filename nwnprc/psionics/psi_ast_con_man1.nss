//::///////////////////////////////////////////////
//:: Astral Construct spellscript for slot 1
//:: psi_ast_con_man1
//:://////////////////////////////////////////////
/*
    Creates an astral construct as specified by the
    contents of the astral contstruct local variable
    set 1 on the manifester.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 26.01.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "psi_inc_ac_const"
#include "psi_inc_ac_manif"



const string sSlot = "1";


void main()
{
//SPSetSchool(SPELL_SCHOOL_CONJURATION);
if (!PsiPrePowerCastCode()){ return; }
// End of Spell Cast Hook
	
	object oManifester = OBJECT_SELF;
	
	int nACLevel = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_LEVEL + sSlot);
	
	if(nACLevel < 1 || nACLevel > 9)
	{
		SendMessageToPCByStrRef(oManifester, STRREF_INVALID_CONSTRUCT_IN_SLOT);
		return;
	}
	
	
	// Check if the manifester can. Since AC is sort of a special case in the augmenting
	// scheme, we need to temporarily change the value of augmentation
	int nTempAugment = GetLocalInt(oManifester, "Augment");
	SetLocalInt(oManifester, "Augment", nACLevel - 1);
	int nMetaPsi = GetCanManifest(oManifester, 2, OBJECT_INVALID, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE);
	if(!nMetaPsi)
		return;
	SetLocalInt(oManifester, "Augment", nTempAugment);
	
	
	int nOptionFlags   = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_OPTION_FLAGS       + sSlot);
	int nResElemFlags  = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + sSlot);
	int nETchElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + sSlot);
	int nEBltElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + sSlot);
	
	DoAstralConstructCreation(oManifester, GetSpellTargetLocation(), nMetaPsi, nACLevel,
	                          nOptionFlags, nResElemFlags, nETchElemFlags, nEBltElemFlags);
	
	// Mark the slot manifested out of on the manifester
	SetLocalString(oManifester, MANIFESTED_SLOT, sSlot);
	
//SPSetSchool();
}