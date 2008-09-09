/////////////////////////////////////////////
// Antitoxin
// sp_antitoxin.nss
////////////////////////////////////////////
// +5 to Fortitude vs poison for 1 hour

void main()
{
        object oTarget = GetSpellTargetObject();
        effect eBoost = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5, SAVING_THROW_TYPE_POISON);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoost, oTarget, HoursToSeconds(1));
}