// Sannish overdose
void main()
{
    effect eff = EffectConfused();
    float fDur = HoursToSeconds(d4(2));
    SetLocalInt(OBJECT_SELF,"PARTIAL_CONFUSION",TRUE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    DelayCommand(fDur,SetLocalInt(OBJECT_SELF,"PARTIAL_CONFUSION",FALSE));
}
