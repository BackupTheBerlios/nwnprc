//:://////////////////////////////////////////////
//:: Samurai Ancestral Daisho conversation
//:: codi_s2_ancdaic
//:://////////////////////////////////////////////
/** @file
    


    @author Primogenitor
    @date   Created  - 2006.01.24
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY               = 0;
const int STAGE_IMPROVE             = 1;
const int STAGE_IMPROVE_TYPE        = 2;
const int STAGE_IMPROVE_SUB_TYPE    = 3;
const int STAGE_IMPROVE_PARAM1      = 4;
const int STAGE_IMPROVE_VALUE       = 5;
const int STAGE_IMPROVE_ADD         = 6;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("You have invoked the power of your ancestral daisho. What would you like to do?");
                AddChoice("[Sacrifice one or more items]", 1, oPC);
                AddChoice("[Improve an ancestral weapon]", 2, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IMPROVE)
            {
                SetHeader("Which type of weapon would you like to improve?");
                AddChoice("[Katana]", 1, oPC);
                AddChoice("[Wakizashi (short sword)]", 2, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IMPROVE_TYPE)
            {
                SetHeader("Which type of itemproperty do you wish to add?");
                int nRow      = 0;
                string sLabel = Get2DACache("itempropdef", "Label", nRow);
                while(sLabel != "")
                {
                    int bIsValid = StringToInt(Get2DACache("itemprops", "0_Melee", nRow));
                    if(bIsValid)
                    {
                        int nStrRef = StringToInt(Get2DACache("itemprops", "StringRef", nRow));
                        AddChoice(GetStringByStrRef(nStrRef), nRow, oPC);                    
                    }
                    nRow++;
                    sLabel = Get2DACache("itempropdef", "Label", nRow);
                }
            }
            else if(nStage == STAGE_IMPROVE_SUB_TYPE)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                SetHeader("Which subtype of itemproperty do you wish to add?");
                string sSubTypeResRef = Get2DACache("itempropdef", "SubTypeResRef", nType);
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sSubTypeResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        AddChoice(GetStringByStrRef(nStrRef), i, oPC);                         
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_PARAM1)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_sub_type");
                SetHeader("Which variation of itemproperty do you wish to add?");
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                //may depend on subtype
                if(sParam1ResRef == "")
                {
                    string sSubTypeResRef = Get2DACache("itempropdef", "SubTypeResRef", nType);
                    if(sSubTypeResRef != "")
                    {
                        sParam1ResRef = Get2DACache(sSubTypeResRef, "Param1ResRef", nSubType);
                    }                
                }
                //lookup the number to get the real filename
                sParam1ResRef = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1ResRef));
                //now loop over rows
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sParam1ResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        AddChoice(GetStringByStrRef(nStrRef), i, oPC);                         
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_VALUE)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_sub_type");
                int nParam1 = GetLocalInt(oPC, "codi_ancdai_param1");
                SetHeader("Which value of itemproperty do you wish to add?");
                string sCostResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                //lookup the number to get the real filename
                sCostResRef = Get2DACache("iprp_costtable", "Name", StringToInt(sCostResRef));
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sCostResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        AddChoice(GetStringByStrRef(nStrRef), i, oPC);                         
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_ADD)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_sub_type");
                int nParam1 = GetLocalInt(oPC, "codi_ancdai_param1");
                int nValue = GetLocalInt(oPC, "codi_ancdai_value");
                
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalObject(oPC, "codi_ancdai"); 
        DeleteLocalInt(oPC, "codi_ancdai_type"); 
        DeleteLocalInt(oPC, "codi_ancdai_subtype"); 
        DeleteLocalInt(oPC, "codi_ancdai_param1"); 
        DeleteLocalInt(oPC, "codi_ancdai_value"); 
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalObject(oPC, "codi_ancdai"); 
        DeleteLocalInt(oPC, "codi_ancdai_type"); 
        DeleteLocalInt(oPC, "codi_ancdai_subtype"); 
        DeleteLocalInt(oPC, "codi_ancdai_param1"); 
        DeleteLocalInt(oPC, "codi_ancdai_value"); 
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1) //sacrifice items
            {
                object oAltar = CreateObject(OBJECT_TYPE_PLACEABLE, "codi_sam_altar", GetLocation(oPC));
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, DoPlaceableObjectAction(oAltar, PLACEABLE_ACTION_USE));
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oAltar);
                DestroyObject(oAltar, 360.0); //6 minutes
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);            
            }
            else if(nChoice == 2) //improve weapon
            {
                nStage = STAGE_IMPROVE;
            }
            
        }
        else if(nStage == STAGE_IMPROVE)
        {
            if(nChoice == 1) //katana
            {
                object oKatana;
                object oTest = GetFirstItemInInventory(OBJECT_SELF);
                while(GetIsObjectValid(oTest))
                {
                    if(GetTag(oTest) == "codi_katana")
                        oKatana = oTest;
                    oTest = GetNextItemInInventory(OBJECT_SELF);
                }
                int i;
                for(i=0;i<14;i++)
                {
                    oTest = GetItemInSlot(i, OBJECT_SELF);
                    if(GetTag(oTest) == "codi_katana")
                        oKatana = oTest;
                }
                SetLocalObject(oPC, "codi_ancdai", oKatana); 
                nStage = STAGE_IMPROVE_TYPE;            
            }
            else if(nChoice == 2) //wakizashi
            {
                object oWakizashi;
                object oTest = GetFirstItemInInventory(OBJECT_SELF);
                while(GetIsObjectValid(oTest))
                {
                    if(GetTag(oTest) == "codi_wakizashi")
                        oWakizashi = oTest;
                    oTest = GetNextItemInInventory(OBJECT_SELF);
                }
                int i;
                for(i=0;i<14;i++)
                {
                    oTest = GetItemInSlot(i, OBJECT_SELF);
                    if(GetTag(oTest) == "codi_wakizashi")
                        oWakizashi = oTest;
                }
                SetLocalObject(oPC, "codi_ancdai", oWakizashi); 
                nStage = STAGE_IMPROVE_TYPE;            
            }
        }
        else if(nStage == STAGE_IMPROVE_TYPE)
        {
            SetLocalInt(oPC, "codi_ancdai_type", nChoice);
            int nType = nChoice;
            //look for subtype
            string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
            if(sSubType != "")
                nStage = STAGE_IMPROVE_SUB_TYPE;
            else
            {
                //no subtype
                //check param1
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                if(sParam1ResRef != "")
                {
                    nStage = STAGE_IMPROVE_PARAM1;                
                }
                else
                {
                    //no param1
                    //check value
                    string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                    if(sValueResRef != "")
                    {
                        nStage = STAGE_IMPROVE_VALUE;                     
                    }
                    else
                    {
                        //no value
                        //proceed to add
                        nStage = STAGE_IMPROVE_ADD; 
                    }
                }
                
            }
            
        }
        else if(nStage == STAGE_IMPROVE_SUB_TYPE)
        {
            SetLocalInt(oPC, "codi_ancdai_subtype", nChoice);
            int nType = GetLocalInt(oPC, "codi_ancdai_type");
            int nSubType = nChoice;
            //check param1
            string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
            if(sParam1ResRef != "")
            {
                nStage = STAGE_IMPROVE_PARAM1;                
            }
            else
            {
                //if there is a subtype, param1 may be defined there
                string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
                if(sSubType != "")
                {
                    sParam1ResRef = Get2DACache(sSubType, "Param1ResRef", nSubType);
                    if(sParam1ResRef != "")
                    {
                        nStage = STAGE_IMPROVE_PARAM1;                
                    }
                    else
                    {
                        //certainly no param1 now
                        //cheat a bit and pretend no subtype to get into the next if statement
                        sSubType = "";
                    }
                }
                if(sSubType == "")
                {
                    //no param1
                    //check value
                    string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                    if(sValueResRef != "")
                    {
                        nStage = STAGE_IMPROVE_VALUE;                     
                    }
                    else
                    {
                        //no value
                        //proceed to add
                        nStage = STAGE_IMPROVE_ADD; 
                    }
                }
            }
        }
        else if(nStage == STAGE_IMPROVE_PARAM1)
        {
            SetLocalInt(oPC, "codi_ancdai_param1", nChoice);
            int nType = GetLocalInt(oPC, "codi_ancdai_type");
            int nSubType = GetLocalInt(oPC, "codi_ancdai_sub_type");
            //check value
            string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
            if(sValueResRef != "")
            {
                nStage = STAGE_IMPROVE_VALUE;                     
            }
            else
            {
                //no value
                //proceed to add
                nStage = STAGE_IMPROVE_ADD; 
            }
        }
        else if(nStage == STAGE_IMPROVE_VALUE)
        {
            SetLocalInt(oPC, "codi_ancdai_value", nChoice);
            int nType = GetLocalInt(oPC, "codi_ancdai_type");
            //proceed to add
            nStage = STAGE_IMPROVE_ADD; 
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
