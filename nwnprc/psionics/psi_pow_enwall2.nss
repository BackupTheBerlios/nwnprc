/*
   ----------------
   Energy Wall, OnHeartBeat
   
   prc_pow_enwall2
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Medium
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   Upon manifesting this power, you create an immobile sheet of energy of the chosen type. All creatures within 10 feet of the wall
   take 2d6 damage, while those actually in the wall take 2d6 + 1 per manifester level, to a max of +20. This stacks with the extra
   damage provided by certain damage types.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
	int nDC = GetManifesterDC(GetAreaOfEffectCreator());
	int nCaster = GetManifesterLevel(GetAreaOfEffectCreator());
	int nPen = GetPsiPenetration(GetAreaOfEffectCreator());
		
	int nDamage;
	effect eVis;
	effect eRay;
	int nSavingThrow;
	int nSaveType;
	int nDamageType;
	int nElement = GetLocalInt(GetAreaOfEffectCreator(), "PsiEnWall");
	
	if (nElement == 1)
	{
		nDamage = (d6(2) + 2);
		eVis = EffectVisualEffect(VFX_IMP_FROST_S);
		nSavingThrow = SAVING_THROW_FORT;
		nSaveType = SAVING_THROW_TYPE_COLD;
		nDamageType = DAMAGE_TYPE_COLD;
	}
	else if (nElement == 2)
	{
		nDamage = d6(2);
		eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
		nSavingThrow = SAVING_THROW_REFLEX;
		nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
		nDamageType = DAMAGE_TYPE_ELECTRICAL;
		nDC += 2;
		nPen += 2;
	}
	else if (nElement == 3)
	{
		nDamage = (d6(2) + 2);
		eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
		nSavingThrow = SAVING_THROW_REFLEX;
		nSaveType = SAVING_THROW_TYPE_FIRE;
		nDamageType = DAMAGE_TYPE_FIRE;
	}
	else if (nElement == 4)
	{
		nDamage = (d6(2) - 2);
		eVis = EffectVisualEffect(VFX_IMP_SONIC);
		nSavingThrow = SAVING_THROW_REFLEX;
		nSaveType = SAVING_THROW_TYPE_SONIC;
		nDamageType = DAMAGE_TYPE_SONIC;
	}




    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Make SR check, and appropriate saving throw(s).
            if(PRCMyResistPower(GetAreaOfEffectCreator(), oTarget, nPen))
            {
		if(PRCMySavingThrow(nSavingThrow, oTarget, nDC, nSaveType))
		{
			nDamage /= 2;
		}
		effect eDam = EffectDamage(nDamage, nDamageType);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}