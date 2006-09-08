//::///////////////////////////////////////////////
//:: Name      Baleful Polymorph
//:: FileName  sp_bale_polym.nss
//:://////////////////////////////////////////////
/**@file Baleful Polymorph
Transmutation
Level: Drd 5, Sor/Wiz 5
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Permanent
Saving Throw: Fortitude negates, Will partial; see text
Spell Resistance: Yes

As polymorph, except that you change the subject into a
Small or smaller animal of no more than 1 HD. If the new 
form would prove fatal to the creature the subject gets 
a +4 bonus on the save.

If the spell succeeds, the subject must also make a Will 
save. If this second save fails, the creature loses its 
extraordinary, supernatural, and spell-like abilities, 
loses its ability to cast spells (if it had the ability),
and gains the alignment, special abilities, and 
Intelligence, Wisdom, and Charisma scores of its new form
in place of its own. It still retains its class and level 
(or HD), as well as all benefits deriving therefrom (such 
as base attack bonus, base save bonuses, and hit points).
It retains any class features (other than spellcasting) 
that aren�t extraordinary, supernatural, or spell-like 
abilities.

Incorporeal or gaseous creatures are immune to being 
polymorphed, and a creature with the shapechanger subtype 
can revert to its natural form as a standard action.
**/

//:///////////////////////////////////////////////////
//: Author:   Tenjac
//: Date  :   9/8/06
//:://////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC)
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	//SR
	if(!MyPRCResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
	{
		//First save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			if(!GetIsIncorporeal)
			{
				//Adjust
				int nHP = GetCurrentHitPoints(oTarget);
				int nDam = (nHP - 10);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_DIVINE, nDam), oTarget);
				
				effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN, TRUE);
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget);
			}
			
		}
	}
	
	SPSetSchool();
}
	
			
				
		
	