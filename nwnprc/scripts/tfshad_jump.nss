#include "spinc_common"
#include "inc_item_props"
#include "inc_combat2"
#include "prc_inc_sneak"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int iLevel       =  GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);
    int iMaxDis      =  iLevel*6;
    int iDistance    =  FloatToInt(GetDistanceBetweenLocations(lCaster,lTarget));
    int iLeftUse = 1;

    int iFeat=FEAT_SHADOWJUMP-1+GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);

    object oTarget=GetSpellTargetObject();
    location lDest;
    if (GetIsObjectValid(oTarget)) lDest=GetLocation(oTarget);
    else lDest=GetSpellTargetLocation();
    effect eVis=EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    vector vOrigin=GetPositionFromLocation(GetLocation(oCaster));
    vector vDest=GetPositionFromLocation(lDest);

    while (GetHasFeat(iFeat,OBJECT_SELF))
    {
      DecrementRemainingFeatUses(OBJECT_SELF,iFeat);
      iLeftUse++;
    }

    int nCount=iLeftUse-1;
    while (nCount)
    {
      IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
      nCount--;
    }

    if ( iMaxDis>iLeftUse*3) iMaxDis=iLeftUse*3;

    if  (iDistance>iMaxDis)
    {
        FloatingTextStringOnCreature("Distance too Far", OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
        return;
    }

    iDistance=(iDistance-3)/3;
    while (iDistance)
    {
      DecrementRemainingFeatUses(OBJECT_SELF,iFeat);
      iDistance--;
    }



    vOrigin=Vector(vOrigin.x+2.0, vOrigin.y-0.2, vOrigin.z);
    vDest=Vector(vDest.x+2.0, vDest.y-0.2, vDest.z);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
    DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));
    DelayCommand(0.8, AssignCommand(oCaster, JumpToLocation(lDest)));

        if (iLevel<4)
        {
           // Caster cannot move for 1 turn now.
           SendMessageToPC(oCaster, "Shadow Jump complete");
           //DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration));
        }
        else
        {
           object oTarget = GetSpellTargetObject();
           object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
           int iEnhancement = GetWeaponEnhancement(oWeap);
           int iDamageType = GetWeaponDamageType(oWeap);
           if  ( GetObjectType(oTarget)!= OBJECT_TYPE_CREATURE) return;

           int iAttacks=NbAtk(OBJECT_SELF);
           int iSneakAttack,iDeathAttack ;
           int iBonus = 0;
           int iNextAttackPenalty = 0;
           int iDamage = 0;

           effect eDamage;

           if (!GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT))
           {
            iSneakAttack = GetTotalSneakAttackDice(OBJECT_SELF);
            iDeathAttack = GetAssassinSneak(OBJECT_SELF);
            iBonus=d6(iSneakAttack);
            
           }


            float fDelay = 1.5f;

           //Perform a full round of attacks
           for(iAttacks; iAttacks > 0; iAttacks--)
           {

             //Roll to hit
             int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget, iBonus + iNextAttackPenalty, TRUE, fDelay);

             if(iHit > 0)
             {
                //Check to see if we rolled a critical and determine damage accordingly
                if(iHit == 2 && !GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT))
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, TRUE) + iBonus;
                else
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, FALSE) + iBonus;

                //Apply the damage
                eDamage = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, iEnhancement);
                DelayCommand(fDelay + 0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

                if (iDeathAttack && iBonus)
                {
                    if (!FortitudeSave(oTarget,10+iDeathAttack+GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF),SAVING_THROW_TYPE_DEATH))
                    {
                       DeathlessFrenzyCheck(oTarget);
                       DelayCommand(fDelay + 0.2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oTarget));
                    }
                }

                iNextAttackPenalty -= 5;
                fDelay += 0.5;
             }
             iBonus=0;
          }
        }
}

