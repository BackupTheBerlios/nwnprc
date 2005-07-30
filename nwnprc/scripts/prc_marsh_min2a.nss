#include "x0_i0_spells"

void main()
{
    object oPC = GetSpellTargetObject();
    object oTarget = GetEnteringObject();
    object PCMarshal = GetAreaOfEffectCreator();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    
    {
        int MarshCha = GetAbilityModifier(ABILITY_CHARISMA, PCMarshal);

            if (oTarget == GetAreaOfEffectCreator())
	    {
	          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_WILL, MarshCha, SAVING_THROW_TYPE_ALL), oTarget);
	    }
	    else
	    {
	          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_WILL, MarshCha, SAVING_THROW_TYPE_ALL), oTarget);
            }


     }
}
