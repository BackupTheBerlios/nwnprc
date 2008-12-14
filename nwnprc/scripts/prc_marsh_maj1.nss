
#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;

     if(!GetHasSpellEffect(GetSpellId()))
     {
        //Declare major variables including Area of Effect Object
        object oTarget = PRCGetSpellTargetObject();

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(156), oTarget);
        sMes = "*Major Aura Activated*";
     }
     else
     {
        // Removes effects
        PRCRemoveSpellEffects(GetSpellId(), oPC, oPC);
        sMes = "*Major Aura Deactivated*";
        DeleteLocalInt(oPC,"MarshalMajor");
        // Removes effects a second time to make sure it works
        PRCRemoveSpellEffects(GetSpellId(), oPC, oPC);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}