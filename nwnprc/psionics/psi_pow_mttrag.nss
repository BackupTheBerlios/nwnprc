/*
   ----------------
   Matter Agitation
   
   prc_all_mttrag
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You excite the structure of an object, heating it to the point of combustion over time.
   First Round: 1 point of fire damage.
   Second Round: 1d4 points of fire damage.
   All following rounds: 1d6 points of fire damage.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"
#include "x2_i0_spells"



void RunImpact1(object oTarget, object oCaster, int nSpell)
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
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        effect eDam = EffectDamage(d4(), DAMAGE_TYPE_FIRE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S); 
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
    }
}

void RunImpact2(object oTarget, object oCaster, int nSpell)
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
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        effect eDam = EffectDamage(d6(), DAMAGE_TYPE_FIRE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S); 
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact2(oTarget, oCaster, nSpell));
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
    int nAugCost = 0;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	int nSpell = GetSpellId();
		
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	if(PRCMyResistPower(oCaster, oTarget, nCaster))
	{
		SPApplyEffectToObject (DURATION_TYPE_INSTANT,EffectDamage(1, DAMAGE_TYPE_FIRE),oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nCaster),FALSE);
		object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
		// d4 damage
		DelayCommand(6.0f,RunImpact1(oTarget, oSelf, nSpell));
		// d6 and so on.
		DelayCommand(12.0f,RunImpact2(oTarget, oSelf, nSpell));
	}
	else
	{
		effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget);
	}	
    }
}