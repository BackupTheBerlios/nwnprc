
const int  TYPE_ARCANE   = 1;
const int  TYPE_SORCERER = 2;
const int  TYPE_WIZARD   = 3;
const int  TYPE_BARD     = 4;
const int  TYPE_DIVINE   = 10;
const int  TYPE_CLERIC   = 11;
const int  TYPE_DRUID    = 12;
const int  TYPE_RANGER   = 13;
const int  TYPE_PALADIN  = 14;


int GetCasterLvl(int iTypeSpell,object oCaster = OBJECT_SELF)
{
    SetLocalInt(oCaster,"X2_L_FIRST_RETVAR",iTypeSpell); 
    return ( ExecuteScriptAndReturnInt("getcast_lvl", oCaster));
}