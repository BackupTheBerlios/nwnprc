/////////////////////////////////////////////
// Alchemist's Frost
// sp_alcfrost.nss
/////////////////////////////////////////////
/*
Alchemist’s Frost: A thin liquid that grows extremely cold when exposed to air, alchemist’s frost
functions like alchemists fire except that it deals 1d8 points of cold damage on a direct hit (and
1 point of cold damage on a splash), rather than fire damage. It deals no additional damage after 
the initial damage.
*/   

#include "prc_inc_spells"

void AddFrostEffectToWeapon(object oTarget, float fDuration)
{        
        // If the spell is cast again, any previous itemproperties matching are removed.
        IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d8), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_COLD), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        
        return;
}

void main()

{
        effect eVis = EffectVisualEffect(VFX_IMP_PULSE_COLD);        
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);        
        object oTarget = GetSpellTargetObject();                           
        object oMyWeapon;                                                  
        int nTarget = GetObjectType(oTarget);                              
        int nDuration = 4;                                                 
        int nCasterLvl = 1;                                                
        
        if(nTarget == OBJECT_TYPE_ITEM)                                    
        {                                                                          
                oMyWeapon = oTarget;                                               
                int nItem = IPGetIsMeleeWeapon(oMyWeapon);                         
                if(nItem == TRUE)                
                {                        
                        if(GetIsObjectValid(oMyWeapon))                       
                        {                                                                          
                                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));          
                                                                                                                                             
                                if (nDuration > 0)                                                                                           
                                {                                                                            
                                        // haaaack: store caster level on item for the on hit spell to work properly
                                        
                                        SetLocalInt(oMyWeapon,"X2_SPELL_CLEVEL_FLAMING_WEAPON",nCasterLvl);                                        
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));         
                                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
                                        AddFrostEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
                                }
                                return;
                        }
                }
                else
                
                {                              
                        FloatingTextStrRefOnCreature(100944,OBJECT_SELF);
                }
                
        }
        else if(nTarget == OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE)        
        {                                                                                    
                DoGrenade(d8(1),1, VFX_IMP_FROST_S, VFX_IMP_FROST_L, DAMAGE_TYPE_COLD ,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }

} 