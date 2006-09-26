
//::///////////////////////////////////////////////
//:: Name       Spell-like-ability script
//:: FileName   sla_script
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Used for Archmage and Heirophant SLA ability
    
    Spell-Like Ability
    
    An archmage who selects this type of high arcana can use 
    one of her arcane spell slots (other than a slot expended 
    to learn this or any other type of high arcana) to 
    permanently prepare one of her arcane spells as a spell-like 
    ability that can be used twice per day. The archmage does 
    not use any components when casting the spell, although a 
    spell that costs XP to cast still does so and a spell with 
    a costly material component instead costs her 10 times that 
    amount in XP. This ability costs one 5th-level spell slot.
    
    
    The spell-like ability normally uses a spell slot of the 
    spell’s level, although the archmage can choose to make a 
    spell modified by a metamagic feat into a spell-like ability 
    at the appropriate spell level.
    
    The archmage may use an available higher-level spell slot 
    in order to use the spell-like ability more often. Using a 
    slot three levels higher than the chosen spell allows her 
    to use the spell-like ability four times per day, and a 
    slot six levels higher lets her use it six times per day.
    
    If spell-like ability is selected more than one time as a 
    high arcana choice, this ability can apply to the same spell 
    chosen the first time (increasing the number of times per day 
    it can be used) or to a different spell. 


    Implementation notes:
    
    These abilities are implmented as loosing spellslot levels rather 
    than loosing specific slots.
    
    To keep this viable for different level spells, the uses/day
    depends on the spelllevel.
    
    0 5
    1 5
    2 4
    3 4
    4 3
    5 3
    6 2 
    7 2
    8 1
    9 1

    When this ability it used, it first checks if not stored already.
    If not stored, it uses spellhooking to catch the next spell cast
    and store that
    If stored, it uses ActionCastSpell to cast that spell at the
    appropriate level & DC.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 4/9/06
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    
    int nSLAFeatID = 0; //feat  ID of the SLA in use
    int nSLASpellID = 0;//spell ID of the SLA in use NOT THE SPELL BEING CAST
    
    //get the spellID of the spell your trying to cast    
    //+1 offset for unassigned
    int nSpellID    = GetPersistantLocalInt(oPC, "PRC_SLA_SpellID_4")-1;
    //test if already stored
    if(nSpellID == -1)
    {
        //not stored
        FloatingTextStringOnCreature("This SLA has not been stored yet\nThe next spell you cast will be assigned to this SLA", oPC);
        SetLocalInt(oPC, "PRC_SLA_Store", 1);
        DelayCommand(18.0,
            DeleteLocalInt(oPC, "PRC_SLA_Store"));
        return;
    }
    else
    {
        //stored, recast it 
        int nSpellClass = GetPersistantLocalInt(oPC, "PRC_SLA_Class_4");
        int nSpellLevel = GetCasterLvl(nSpellClass);
        
        //since this is targetted using a generic feat,
        //make sure were within range and target is valid for this spell
        
        //get current distance
        string sRange = Get2DACache("spells", "Range", nSpellID);
        float fDist;
        if(GetIsObjectValid(oTarget))
             fDist = GetDistanceToObject(oTarget);
        else     
             fDist = GetDistanceBetweenLocations(GetLocation(oPC), lTarget);
        //check distance is allowed 
        if(fDist < 0.0
            || (sRange == "T" && fDist >  2.25)
            || (sRange == "S" && fDist >  8.0 )
            || (sRange == "M" && fDist > 20.0 )
            || (sRange == "L" && fDist > 40.0 )
            )
        {
            //out of range
            FloatingTextStringOnCreature("You are out of range", oPC);
            //replace the useage
            IncrementRemainingFeatUses(oPC, nSLAFeatID);
            //end the script
            return;
        }
        
        //check object type
        int nTargetType = HexToInt(Get2DACache("spells", "TargetType", nSpellID));
        /*
        # 0x01 = 1 = Self
        # 0x02 = 2 = Creature
        # 0x04 = 4 = Area/Ground
        # 0x08 = 8 = Items
        # 0x10 = 16 = Doors
        # 0x20 = 32 = Placeables
        */
        int nCaster     = nTargetType &  1;
        int nCreature   = nTargetType &  2;
        int nLocation   = nTargetType &  4;
        int nItem       = nTargetType &  8;
        int nDoor       = nTargetType & 16;
        int nPlaceable  = nTargetType & 32;
        int nTargetValid = TRUE;
        //test targetting self
        if(oTarget == OBJECT_SELF)
        {
            if(!nCaster)
            {
                nTargetValid = FALSE;
                FloatingTextStringOnCreature("You cannot target yourself", oPC);
            }   
        }
        //test targetting others
        if(GetIsObjectValid(oTarget))
        {
            switch(GetObjectType(oTarget))
            {
                case OBJECT_TYPE_CREATURE:
                    if(!nCreature)
                    {
                        nTargetValid = FALSE;
                        FloatingTextStringOnCreature("You cannot target creatures", oPC);
                    }   
                    break;
                case OBJECT_TYPE_ITEM:
                    if(!nItem)
                    {
                        nTargetValid = FALSE;
                        FloatingTextStringOnCreature("You cannot target items", oPC);
                    }   
                    break;
                case OBJECT_TYPE_DOOR:
                    if(!nDoor)
                    {
                        nTargetValid = FALSE;
                        FloatingTextStringOnCreature("You cannot target doors", oPC);
                    }   
                    break;
                case OBJECT_TYPE_PLACEABLE:
                    if(!nDoor)
                    {
                        nTargetValid = FALSE;
                        FloatingTextStringOnCreature("You cannot target placeables", oPC);
                    }   
                    break;
            }
        }
        //test if can target a location
        if(GetIsObjectValid(GetAreaFromLocation(lTarget)))
        {
            if(!nLocation)
            {
                nTargetValid = FALSE;
                FloatingTextStringOnCreature("You cannot target locations", oPC);
            }   
            
        }
        
        //target was not valid, abort
        if(!nTargetValid)
        {
            //replace the useage
            IncrementRemainingFeatUses(oPC, nSLAFeatID);
            //end the script
            return;
        
        }
        
        //actually cast it at this point
        //note that these are instant-spells, so we have to add the animation part too
        if(GetIsObjectValid(GetAreaFromLocation(lTarget)))
            ActionCastFakeSpellAtLocation(nSpellID, lTarget);
        else
            ActionCastFakeSpellAtObject(nSpellID, oTarget);
        ActionDoCommand(ActionCastSpell(nSpellID, nSpellLevel, 0,-1));
    }
}