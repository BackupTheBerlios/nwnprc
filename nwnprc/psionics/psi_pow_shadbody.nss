/*
   ----------------
   Shadow Body
   
   prc_pow_shadbody
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   Your body and all equipment become a living shadow. You cannot harm anyone physically, but can manifest powers as normal.
   You gain 10/+3 DR, Immunity to Critical Hits, Ability Damage, Disease, and Poison. You take half damage from Fire, Electricity
   and Acid. You also gain Darkvision. You drift in and out of the shadow plane, giving you 50% concealment and causing you 
   to disappear, although this is negated should you attack anyone. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void GoInvis(object oTarget, object oCaster, int nCaster, int nSpell)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpell,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
       	effect eCover = EffectConcealment(50);
       	effect eLink1 = EffectLinkEffects(eInvis, eCover);
       	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 6.0,TRUE,-1,nCaster);
        DelayCommand(6.0f,GoInvis(oTarget, oCaster, nCaster, nSpell));
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);      
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
	float fDur = 60.0 * nCaster;
	int nSpell = GetSpellId();
	if (nMetaPsi == 2)	fDur *= 2;
	
	//Massive effect linkage, go me
    	effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50);
    	effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50);
    	effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
    	effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
    	effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    	effect eDis = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    	effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
    	effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
    	effect eDark = EffectUltravision();
    	
    	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    	effect eDur = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    	effect eLink = EffectLinkEffects(eAcid, eElec);
    	eLink = EffectLinkEffects(eLink, eFire);
    	eLink = EffectLinkEffects(eLink, eAbil);
    	eLink = EffectLinkEffects(eLink, eCrit);
    	eLink = EffectLinkEffects(eLink, eDis);
    	eLink = EffectLinkEffects(eLink, ePoison);
    	eLink = EffectLinkEffects(eLink, eDur);
    	eLink = EffectLinkEffects(eLink, eDR);
    	eLink = EffectLinkEffects(eLink, eDark);


	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	GoInvis(oTarget, oCaster, nCaster, nSpell);
    }
}