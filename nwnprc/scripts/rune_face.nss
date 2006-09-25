#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nLoc = 1;
    string sVar;
    switch(nLoc)
    {
        case 1: sVar = "Runescar_Face";        break;
        case 2: sVar = "Runescar_Arm_Left";    break;
        case 3: sVar = "Runescar_Chest_Left";  break;
        case 4: sVar = "Runescar_Hand_Left";   break;
        case 5: sVar = "Runescar_Arm_Right";   break;
        case 6: sVar = "Runescar_Chest_Right"; break;
        case 7: sVar = "Runescar_Hand_Right";  break;
    }
    int nSpellID    = GetPersistantLocalInt(oPC, sVar)-1;
    int nLevel      = GetPersistantLocalInt(oPC, sVar+"_level");
    DeletePersistantLocalInt(oPC, sVar);
    DeletePersistantLocalInt(oPC, sVar+"_level");
    int nSpellLevel = GetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID));
    int nDC         = 10+nSpellLevel+GetAbilityModifier(ABILITY_WISDOM, oPC);
    if(nSpellID >=0)
        ActionCastSpell(nSpellID, nLevel, nDC);
    else
        FloatingTextStringOnCreature("You dont have a Runescar there", oPC);
}
