#include "prc_alterations"
#include "prc_inc_domain"
int GetIsBlessingHourValid()
{
    if(GetTimeHour()>=12 || GetTimeHour()<MOD_DAWN_START_HOUR)
    {
        return FALSE;
    }
    return TRUE;
}

void CheckBlessingOfDawn(object oPC)
{
    object oArea = GetArea(oPC);
    int bValidHour = GetIsBlessingHourValid();
    if(!bValidHour || GetIsAreaInterior(oArea))
    {
        //SendMessageToPC(GetFirstPC(),"Blessing of Dawn Removed");
        DelayCommand(15.0,CheckBlessingOfDawn(oPC));
        return;
    }
    float fInterval = INTERVAL_BLESSING_OF_DAWN;
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if(!GetIsObjectValid(oHide)){return;}
    AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyBonusSavingThrow
        (IP_CONST_SAVEBASETYPE_WILL,2),oHide,fInterval);
    //SendMessageToPC(GetFirstPC(),"Blessing of Dawn Applied");
    DelayCommand(fInterval,CheckBlessingOfDawn(oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if(!GetIsObjectValid(oHide))
    {
        oHide = CreateItemOnObject("prc_hide",oPC);
        AssignCommand(oPC, ActionEquipItem(oHide,INVENTORY_SLOT_CARMOUR));
    }
    itemproperty ip = GetFirstItemProperty(oHide);
    while(GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oHide,ip);
        ip = GetNextItemProperty(oHide);
    }
    int nMorninglordLevel = GetLevelByClass(CLASS_TYPE_MORNINGLORD,oPC);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_ARMOR,nMorninglordLevel),oHide);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_TRAP,nMorninglordLevel),oHide);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_WEAPON,nMorninglordLevel),oHide);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_PERFORM,nMorninglordLevel),oHide);
    //new craft skills
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_GENERAL,nMorninglordLevel),oHide);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_ALCHEMY,nMorninglordLevel),oHide);
    AddItemProperty(2,ItemPropertySkillBonus(SKILL_CRAFT_POISON,nMorninglordLevel),oHide);
    if(nMorninglordLevel>=6)
    {
        CheckBlessingOfDawn(oPC);
    }
}
