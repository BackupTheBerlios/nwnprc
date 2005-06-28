/*
   ----------------
   Temporal Acceleration
   
   prc_pow_tempacc
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Personal
   Target: Caster
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
   You enter another time frame, speeding up so greatly that all other creatures seem frozen, though they are still actually 
   moving at normal speed. You are free to act for 1 round of apparent time. This is an instant power.
   
   Augment: For every 4 additional power points spent, the duration increases by 1 round.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"
#include "prc_inc_switch"
#include "inc_timestop"

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
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nAugCost = 4;
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
        
    if (nSurge > 0)
    {
        
        PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    int nCaster = GetManifesterLevel(oCaster);
    int nDC = GetManifesterDC(oCaster);
    int nDur = 1;
    
    if (nSurge > 0) nAugment += nSurge;
    
    //Augmentation effects to Duration
    if (nAugment > 0) nDur += nAugment;
    
    if (nMetaPsi == 2)  nDur *= 2;
    
    location lTarget = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eTime = EffectTimeStop();
    if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
    {
        eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
        eTime = EffectLinkEffects(eTime, EffectEthereal());
        if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster),RoundsToSeconds(nDur));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCaster),RoundsToSeconds(nDur));            
                /*
                DelayCommand(RoundsToSeconds(nDur), RemoveTimestopEquip());
                string sSpellscript = PRCGetUserSpecificSpellScript();
                DelayCommand(RoundsToSeconds(nDur), PRCSetUserSpecificSpellScript(sSpellscript));
                PRCSetUserSpecificSpellScript("tsspellscript");
                    now in main spellhook */
            }
    }
    
    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
        
    //Apply the VFX impact and effects
    DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, RoundsToSeconds(nDur),TRUE,-1,nCaster));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    
    }
}