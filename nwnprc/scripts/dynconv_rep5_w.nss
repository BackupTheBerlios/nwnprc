/*
Checks that there is a valid option for choice 0
*/

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalString(oPC, "TOKEN105")=="")
        return FALSE;
    else
        return TRUE;
}
