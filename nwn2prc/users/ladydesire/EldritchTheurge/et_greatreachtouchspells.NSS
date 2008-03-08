#include "nw_i0_spells"
#include "nwn2_inc_spells"
#include "x2_inc_toollib"
#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

/*//////////////////////////////////////////////////////////////////////////////////////*/	
//																						//
//						TOUCH ATTACKS FOR GREATREACH BLAST								//
//																						//
/*//////////////////////////////////////////////////////////////////////////////////////*/

void DoETBestowCurse(object oTarget)
{
	int nDC = GetSpellSaveDC();
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );	
    effect eCurse = EffectCurse(3, 3, 3, 3, 3, 3);
	eCurse = SupernaturalEffect(eCurse);
    effect eLink = EffectLinkEffects( eCurse, eVis );
	if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}
	
void DoETContagion(object oTarget)
{
	int nRand = Random(7)+1;
 	int nDisease;
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
		case 1: nDisease = DISEASE_BLINDING_SICKNESS; break;
		case 2: nDisease = DISEASE_CACKLE_FEVER; break;
		case 3: nDisease = DISEASE_FILTH_FEVER; break;
        case 4: nDisease = DISEASE_MINDFIRE; break;
        case 5: nDisease = DISEASE_RED_ACHE; break;
        case 6: nDisease = DISEASE_SHAKES; break;
        case 7: nDisease = DISEASE_SLIMY_DOOM; break;
    } 
    effect eDisease = EffectDisease(nDisease);
    //Make SR check
    if (!MyResistSpell(OBJECT_SELF, oTarget))
    {
    	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_CONTAGION );	
		eDisease = EffectLinkEffects( eDisease, eHit );
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
		SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
	}
}

void DoETGhoulTouch(object oTarget, int nMetaMagic)
{
	//Declare major variables including Area of Effect Object
	int nSaveDC = GetSpellSaveDC();
	effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL);
	effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
					   
    int nDuration = d6()+2;
	//Metamagic buffs
	if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDuration = 8;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    else if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

	if(!MyResistSpell(OBJECT_SELF, oTarget) && !/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NEGATIVE))
    { 
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));
    }
}

void DoETVampiricTouch(object oTarget, int nMetaMagic, int nCasterLevel)
{
	int nDDice = nCasterLevel /2;
	if ((nDDice) == 0) nDDice = 1;
	else if (nDDice>10) nDDice = 10;
	int nDamage = d6(nDDice);  // JLR - OEI 07/19/05
    //Enter Metamagic conditions
    nDamage = MaximizeOrEmpower(8,nDDice,nMetaMagic);  // JLR - OEI 07/19/05
    int nDuration = nCasterLevel/2;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    //max hp+10 maximum
	int nMax = GetCurrentHitPoints(oTarget) + 10;
	if(nMax < nDamage) nDamage = nMax;

	effect eHeal = EffectTemporaryHitpoints(nDamage);
	effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_S);
	if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) &&
		GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
		GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
		!GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));
            // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
            if(MyResistSpell(OBJECT_SELF, oTarget) == 0)
            {
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
                RemoveTempHitPoints();
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, HoursToSeconds(nDuration));
         	}
         }
	}
}
// Reeron's combust script
void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic)
{
    if (GZGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster)) return;
	if (GetIsDead(oTarget) == FALSE)
    {
        int nDC = 15;

        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            int nDamage = d6(); 
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6;
            else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2);

            effect eDmg = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
            effect eVFX = EffectVisualEffect(VFX_HIT_SPELL_FIRE);

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

            DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, nLevel,nMetaMagic));
        }
        else GZRemoveSpellEffects(SPELL_COMBUST, oTarget);
   }
}
// Reeron's combust script
void DoETCombust(object oTarget, object oCaster, int nLevel, int nMetaMagic)
{
	int nDamage;
	if (nLevel > 10) nLevel = 10;
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 8 * nLevel; //max
		else nDamage  = d8(nLevel);
	if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
    int nDuration = 10 + nLevel;
    if (nDuration < 1) nDuration = 10;

	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eVis2 = EffectVisualEffect(VFX_DUR_FIRE);
	effect eHit = EffectLinkEffects(eDam, eVis);

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    if(!MyResistSpell(OBJECT_SELF, oTarget))
    {
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, RoundsToSeconds(nDuration));
		TLVFXPillar(VFX_HIT_SPELL_EVOCATION, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);
		// This spell no longer stacks. If there is one of that type, that's enough
        if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
        {
			FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE); return;
        }
            DelayCommand(6.0, RunCombustImpact(oTarget,oCaster,nLevel, nMetaMagic));
	}
}

void DoETShockingGrasp(object oTarget, int nCasterLvl, int nMetaMagic)
{
	int nDamage;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);	//VFX_IMP_HARM
	effect eDam;
    
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

	if (!MyResistSpell(OBJECT_SELF, oTarget))
	{
		int nMaxLvl = nCasterLvl;
		if ( nMaxLvl > 5 ) nMaxLvl = 5;
		nDamage = d6(nMaxLvl);
		nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl*6);
		eDam = EffectDamage(nDamage,DAMAGE_TYPE_ELECTRICAL);
		DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
}

void DoETTouchOfIdiocy(object oTarget, int nCasterLvl, int nMetaMagic)
{
   //Declare major variables
    float fDuration = TurnsToSeconds(10 * nCasterLvl);
	fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

           if (!MyResistSpell(OBJECT_SELF, oTarget))
            {				
                //Check for metamagic
				int nWisDmg = d6();
				int nIntDmg = d6();
				int nChaDmg = d6();
                nWisDmg = ApplyMetamagicVariableMods(nWisDmg, 6);
                nIntDmg = ApplyMetamagicVariableMods(nIntDmg, 6);
                nChaDmg = ApplyMetamagicVariableMods(nChaDmg, 6);

                //Set ability damage effect
				effect eWis, eInt, eCha;				
				
				int nCurWis = GetAbilityScore(oTarget, ABILITY_WISDOM);
				if ( (nCurWis - nWisDmg) <= 1) {
					eWis = EffectAbilityDecrease(ABILITY_WISDOM, (nCurWis -1));
				}
				else {					
					eWis = EffectAbilityDecrease(ABILITY_WISDOM, nWisDmg);
				}
				
				int nCurInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
				if ( (nCurInt - nIntDmg) <= 1) {
					eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, (nCurInt - 1));
				}
				else {
					eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nIntDmg);
				}
				
				int nCurCha = GetAbilityScore(oTarget, ABILITY_CHARISMA);
				if ( (nCurCha - nChaDmg) <= 1) {
					eCha = EffectAbilityDecrease(ABILITY_CHARISMA, (nCurCha - 1));
				}
				else {
					eCha = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDmg);
				}
				
  			    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_TOUCH_OF_IDIOCY );
				effect eLink = EffectLinkEffects(eWis, eInt);
				eLink = EffectLinkEffects(eLink, eCha);
				eLink = EffectLinkEffects(eLink, eDur);
				
                //Apply the VFX impact and effects
    			RemoveEffectsFromSpell(oTarget, GetSpellId());
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
           }
        
    
	effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, OBJECT_SELF, BODY_NODE_HAND);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}