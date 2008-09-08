//////////////////////////////////////////////////
// Throw energized potion
// sp_throw_ep.nss
//////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oGrenade = PRCGetSpellCastItem();
        int nDamType = GetLocalInt(oGrenade, "PRC_GrenadeDamageType");
        int nStrength = GetLocalInt(oGrenade, "PRC_GrenadeLevel");
        int nSaveType = GetLocalInt(oGrenade, "PRC_EnergizedPotionSave");
        int nDC = 10 + nStrength;
        int nDam;
        location lLoc = GetSpellTargetLocation();
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        while(GetIsObjectValid(oTarget))
        {
                nDam = d6(nStrength);
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, nDC, oTarget, nSaveType))
                {
                        nDam = nDam/2;
                }
                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nDamType), oTarget);
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
}