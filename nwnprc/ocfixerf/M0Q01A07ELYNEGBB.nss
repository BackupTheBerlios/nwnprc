// Added compatibility for PRC base classes

int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0;
}