#include "inc_utility"
#include "x2_inc_spellhook"
void main()
{
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    if(!GetIsObjectValid(oTarget) 
        || oTarget != OBJECT_SELF
        || Get2DACache("spells", "HostileSetting", nSpell) == "1")
    {
        PRCSetUserSpecificSpellScriptFinished();
        return;
    }
}