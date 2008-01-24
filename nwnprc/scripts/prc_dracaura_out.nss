//::///////////////////////////////////////////////
//:: Draconic Aura  - Primary Auras
//:: prc_dracaura_out.nss
//::///////////////////////////////////////////////
/*
    Handles PCs leaving the Aura AoE for primary
    draconic auras.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 27, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_dragsham"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object PCShaman = GetAreaOfEffectCreator();
    
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_TOUGHNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_TOUGHNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_VIGOR, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_VIGOR)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_PRESENCE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_PRESENCE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_SENSES, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_SENSES)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_ENERGY_SHIELD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_ENERGY_SHIELD)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_RESISTANCE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_RESISTANCE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_POWER, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_POWER)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_INSIGHT, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_INSIGHT)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_RESOLVE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_RESOLVE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_STAMINA, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_STAMINA)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_SWIFTNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DRACONIC_AURA_SWIFTNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    
    ////////////END SHAMAN, BEGIN MARSHAL///////////////////
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_TOUGHNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_TOUGHNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTACID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_RESISTACID)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_PRESENCE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_PRESENCE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_SENSES, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_SENSES)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTCOLD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_RESISTCOLD)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTELEC, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_RESISTELEC)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESISTFIRE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_RESISTFIRE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_INSIGHT, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_INSIGHT)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_RESOLVE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_RESOLVE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_STAMINA, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_STAMINA)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_MARSHAL_AURA_SWIFTNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MARSHAL_AURA_SWIFTNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    
    ////////////END MARSHAL, BEGIN EXTRA///////////////////
    if(GetHasSpellEffect(SPELL_BONUS_AURA_TOUGHNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_TOUGHNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTACID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_RESISTACID)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_PRESENCE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_PRESENCE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_SENSES, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_SENSES)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTCOLD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_RESISTCOLD)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTELEC, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_RESISTELEC)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_RESISTFIRE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_RESISTFIRE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_INSIGHT, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_INSIGHT)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_RESOLVE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_RESOLVE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_STAMINA, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_STAMINA)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if(GetHasSpellEffect(SPELL_BONUS_AURA_SWIFTNESS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_BONUS_AURA_SWIFTNESS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    if((GetHasSpellEffect(SPELL_DRACONIC_AURA_MAGICPOWER, PCShaman)
        || GetHasSpellEffect(SPELL_MARSHAL_AURA_MAGICPOWER, PCShaman)
        ||GetHasSpellEffect(SPELL_BONUS_AURA_MAGICPOWER, PCShaman))
      && (GetLocalInt(oTarget,"MagicPowerAura") == GetLocalInt(PCShaman,"MagicPowerAura")))
    {
    	DeleteLocalInt(oTarget,"MagicPowerAura");
    }
    
    if(GetHasSpellEffect(SPELL_DRACONIC_AURA_ENERGY, PCShaman))
    {
    	if((GetLocalInt(oTarget,"AcidEnergyAura") == GetLocalInt(PCShaman,"AcidEnergyAura"))
    	   && GetDragonDamageType(PCShaman) == DAMAGE_TYPE_ACID)
    	    DeleteLocalInt(oTarget,"AcidEnergyAura");
    	if((GetLocalInt(oTarget,"ColdEnergyAura") == GetLocalInt(PCShaman,"ColdEnergyAura"))
    	   && GetDragonDamageType(PCShaman) == DAMAGE_TYPE_COLD)
    	    DeleteLocalInt(oTarget,"ColdEnergyAura");
    	if((GetLocalInt(oTarget,"ElecEnergyAura") == GetLocalInt(PCShaman,"ElecEnergyAura"))
    	   && GetDragonDamageType(PCShaman) == DAMAGE_TYPE_ELECTRICAL)
    	    DeleteLocalInt(oTarget,"ElecEnergyAura");
    	if((GetLocalInt(oTarget,"FireEnergyAura") == GetLocalInt(PCShaman,"FireEnergyAura"))
    	   && GetDragonDamageType(PCShaman) == DAMAGE_TYPE_FIRE)
    	    DeleteLocalInt(oTarget,"FireEnergyAura");
    }
    
    if((GetHasSpellEffect(SPELL_MARSHAL_AURA_ENERGYACID, PCShaman)
        ||GetHasSpellEffect(SPELL_BONUS_AURA_ENERGYACID, PCShaman))
      && (GetLocalInt(oTarget,"AcidEnergyAura") == GetLocalInt(PCShaman,"AcidEnergyAura")))
    {
    	DeleteLocalInt(oTarget,"AcidEnergyAura");
    }    
    if((GetHasSpellEffect(SPELL_MARSHAL_AURA_ENERGYCOLD, PCShaman)
        ||GetHasSpellEffect(SPELL_BONUS_AURA_ENERGYCOLD, PCShaman))
      && (GetLocalInt(oTarget,"ColdEnergyAura") == GetLocalInt(PCShaman,"ColdEnergyAura")))
    {
    	DeleteLocalInt(oTarget,"ColdEnergyAura");
    }    
    if((GetHasSpellEffect(SPELL_MARSHAL_AURA_ENERGYELEC, PCShaman)
        ||GetHasSpellEffect(SPELL_BONUS_AURA_ENERGYELEC, PCShaman))
      && (GetLocalInt(oTarget,"ElecEnergyAura") == GetLocalInt(PCShaman,"ElecEnergyAura")))
    {
    	DeleteLocalInt(oTarget,"ElecEnergyAura");
    }    
    if((GetHasSpellEffect(SPELL_MARSHAL_AURA_ENERGYFIRE, PCShaman)
        ||GetHasSpellEffect(SPELL_BONUS_AURA_ENERGYFIRE, PCShaman))
      && (GetLocalInt(oTarget,"FireEnergyAura") == GetLocalInt(PCShaman,"FireEnergyAura")))
    {
    	DeleteLocalInt(oTarget,"FireEnergyAura");
    }

}
