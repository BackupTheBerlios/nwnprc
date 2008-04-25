

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(), CasterLvl);
    object oTarget;
    //Spell resistance check
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        location lLastLocation = GetLocalLocation(oTarget, "LastMirePos");
        float fDistance = GetDistanceBetweenLocations(lLastLocation, GetLocation(oTarget));
    
        int nDam = FloatToInt(fDistance / FeetToMeters(5.0));
        if(nDam == 0) nDam = 1;
        effect eDam = EffectDamage(d6(nDam), DAMAGE_TYPE_ACID);
        effect eLink = EffectLinkEffects(eDam, EffectVisualEffect(VFX_IMP_ACID_S));
        
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        
        SetLocalLocation(oTarget, "LastMirePos", GetLocation(oTarget));
        
        oTarget = GetNextInPersistentObject();
    }
    
}
