#include "inc_epicspellai"

void main()
{
    if(DoEpicSpells())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }
}