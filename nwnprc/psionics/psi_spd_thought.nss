//::///////////////////////////////////////////////
//:: Speed of Thought bonus applying script
//:: psi_spd_thought
//:://////////////////////////////////////////////
/*
	Adds +25% move speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 28.02.2005
//:://////////////////////////////////////////////


void main(){
    object oTarget = GetSpellTargetObject();
    
    if(!GetHasSpellEffect(GetSpellId(), oTarget))
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(25)), oTarget);
}
    