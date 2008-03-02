

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    object oTarget;
    //Spell resistance check
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        location lLastLocation = GetLocalLocation(oTarget, "LastMirePos");
        float fDistance = GetDistanceBetweenLocations(lLastLocation, GetLocation(oTarget));
    
        int nDam = FloatToInt(fDistance / FeetToMeters(5.0));
        if(nDam == 0) nDam = 1;
        effect eDam = EffectDamage(DAMAGE_TYPE_ACID, d6(nDam));
        effect eLink = EffectLinkEffects(eDam, EffectVisualEffect(VFX_IMP_ACID_S));
        
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        
        SetLocalLocation(oTarget, "LastMirePos", GetLocation(oTarget));
        
        oTarget = GetNextInPersistentObject();
    }
    
}
