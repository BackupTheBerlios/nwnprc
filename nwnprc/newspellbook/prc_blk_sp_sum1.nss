#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    //get the level
    int nLevel = GetNewSpellbookCasterLevel(CLASS_TYPE_BLACKGUARD);
    //set metamagic
    SetLocalInt(OBJECT_SELF, "NewSpellMetamagic", 0);
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "NewSpellMetamagic"));
    //pass in the spell
    ActionCastSpell(SPELL_SUMMON_CREATURE_I, nLevel);
    //remove it from the spellbook
    RemoveSpellUse(OBJECT_SELF, GetSpellId(), CLASS_TYPE_BLACKGUARD);
}

