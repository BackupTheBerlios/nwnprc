

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))// && bValid == FALSE)
    {
        //If the effect was created by the Web then remove it
        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
        {
            if(GetEffectSpellId(eAOE) == SPELL_WEB)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }

    location lLastLocation = GetLocalLocation(oTarget, "LastMirePos");
    float fDistance = GetDistanceBetweenLocations(lLastLocation, GetLocation(oTarget));
    
    int nDam = FloatToInt(fDistance / FeetToMeters(5.0));
    effect eDam = EffectDamage(DAMAGE_TYPE_ACID, d6(nDam));
    effect eLink = EffectLinkEffects(eDam, EffectVisualEffect(VFX_IMP_ACID_S));
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    
    if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        
    DeleteLocalLocation(oTarget, "LastMirePos");
}

