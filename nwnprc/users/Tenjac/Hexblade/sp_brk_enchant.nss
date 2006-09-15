//::///////////////////////////////////////////////
//:: Name      Break Enchantment
//:: FileName  sp_brk_enchant.nss
//:://////////////////////////////////////////////
/**@file Break Enchantment
Abjuration
Level: Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5, Hexblade 4
Components: V, S
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Targets: Up to one creature per level, all within 30 ft. of 
each other
Duration: Instantaneous
Saving Throw: See text
Spell Resistance: No

This spell frees victims from enchantments, transmutations, 
and curses. Break enchantment can reverse even an 
instantaneous effect. For each such effect, you make a 
caster level check (1d20 + caster level, maximum +15) 
against a DC of 11 + caster level of the effect. Success 
means that the creature is free of the spell, curse, or 
effect. For a cursed magic item, the DC is 25.

If the spell is one that cannot be dispelled by dispel 
magic, break enchantment works only if that spell is 5th
level or lower. 
If the effect comes from some permanent magic item break 
enchantment does not remove the curse from the item, but 
it does frees the victim from the item’s effects. 

**/

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
}