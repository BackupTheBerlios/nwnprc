/* Burst racial ability for Xephs
   Speed Increase for 3 rounds.*/

#include "prc_alterations"


void main()
{

    object oPC = OBJECT_SELF;
    int nSpdIncrease;
    
    switch(GetHitDice(oPC))
    {
    	case 1:
    	case 2:
    	case 3:
    	case 4: nSpdIncrease = 33; break;
    	
    	case 5:
    	case 6:
    	case 7:
    	case 8: nSpdIncrease = 67; break;
    	
    	default: nSpdIncrease = 100; break;
    }
    effect eSpdInc = EffectMovementSpeedIncrease(nSpdIncrease);
    effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eSpdInc, eVis);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(3));
}