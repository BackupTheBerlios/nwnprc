//::///////////////////////////////////////////////
//:: Draconian Death Throes
//:: race_deaththroes.nss
//::///////////////////////////////////////////////
/*
    Handles the after-death effects of Draconians
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 09, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

//function to handle the damage from a kapak's acid pool
void DoKapakAcidDamage(object oPC)
{
        location lTarget = GetLocation(oPC);
        int nDamage = d6();
        effect eBlastVis = EffectVisualEffect(VFX_IMP_PULSE_COLD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlastVis, oPC);
            
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        //Get the distance between the explosion and the target to calculate delay
	        float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
	         
	        effect eDam = PRCEffectDamage(nDamage, DAMAGE_TYPE_ACID);
	        effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
	        // Apply effects to the currently selected target.
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	        //This visual effect is applied to the target object not the location as above.
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                	            
	    }
	    //Select the next target within the spell shape.
	    oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
}


void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("race_deaththroes running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	oPC = OBJECT_SELF;
        // Hook in the events
        if(DEBUG) DoDebug("race_deaththroes: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERDEATH,   "race_deaththroes", TRUE, FALSE);
    }
    
    else if(nEvent == EVENT_ONPLAYERDEATH)
    {
        oPC = GetLastPlayerDied();
        object oEnemy = GetLastHostileActor();
        if(DEBUG) DoDebug("race_deaththroes - OnDeath");   
        
        if(GetRacialType(oPC) == RACIAL_TYPE_BOZAK)
        {
            location lTarget = GetLocation(oPC);
            int nDC = 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
            int nDamage = d6();
            effect eBlastVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlastVis, oPC);
            
            //Declare the spell shape, size and the location.  Capture the first target object in the shape.
            object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            //Cycle through the targets within the spell shape until an invalid object is captured.
            while (GetIsObjectValid(oTarget))
	    {
	        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	        {
	                //Get the distance between the explosion and the target to calculate delay
	                float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
	                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
	                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
	                if(nDamage > 0)
	                {
				//Set the damage effect
				effect eDam = PRCEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
				effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	                        // Apply effects to the currently selected target.
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	                        //This visual effect is applied to the target object not the location as above.
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                 }
	            
	        }
	       //Select the next target within the spell shape.
	       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	    }
        }
        
        else if(GetRacialType(oPC) == RACIAL_TYPE_KAPAK)
        {
            int nDuration = d6();
            
            //use a switch to set the proper amount of "pulses" of damage
            switch(nDuration)
            {
            	case 6: 
            	    DelayCommand(RoundsToSeconds(5), DoKapakAcidDamage(oPC));
            	    
            	case 5: 
            	    DelayCommand(RoundsToSeconds(4), DoKapakAcidDamage(oPC));
            	    
            	case 4: 
            	    DelayCommand(RoundsToSeconds(3), DoKapakAcidDamage(oPC));
            	    
            	case 3: 
            	    DelayCommand(RoundsToSeconds(2), DoKapakAcidDamage(oPC));
            	    
            	case 2: 
            	    DelayCommand(RoundsToSeconds(1), DoKapakAcidDamage(oPC));
            	    
            	case 1: 
            	    DoKapakAcidDamage(oPC); break;
            }
        }
        
        else if(GetRacialType(oPC) == RACIAL_TYPE_BAAZ)
        {
            //disarm code
            if(GetIsCreatureDisarmable(oEnemy))
            {
                if(DEBUG) DoDebug("race_deaththroes: Disarming Enemy");
            	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy);
            	AssignCommand(oEnemy, ActionGiveItem(oItem, oPC));
            }
        	
        }
        
    }
    
}