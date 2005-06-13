////////////////////////////////////////////////////////////////////////////////
//                                  SPELLHOOK                                 //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  This is the spellhook the module uses.  To set up the spellhook, create a //
//local string named "X2_S_UD_SPELLSCRIPT" in the module's variables section, //
//with the value of your desired spellhook script name.                       //
//                                                                            //
//  I.E. to set up the spellhook for this module, I went to Module Properties,//
//Advanced, Variables, and set the following variable ...                     //
//                                                                            //
//  Name                  Type     Value                                      //
//  X2_S_UD_SPELLSCRIPT   string   aa_spellhook                               //
//                                                                            //
//  If you already have a spellhook set up, simply copy the marked lines to   //
//your original spellhook.  If you don't have one, you can use this one with  //
//no problems.                                                                //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Created By  : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

//Required include for Imbue Arrow functionality.
#include "prc_inc_function"
#include "prc_inc_clsfunc"

//Default includes.  Useful for spellhooking functions.
#include "x2_inc_spellhook"
#include "x2_inc_switches"


void main()
{
    //Required for use with Imbue Arrow ability.  Copy into spellhook if they
    //don't already exist.
    object oTarget = GetSpellTargetObject();
    int    iSpell  = PRCGetSpellId();
    int    iLevel  = PRCGetCasterLevel(OBJECT_SELF);

    //Imbue Arrow functionality.  If copying to new spellhook, start copy here ...
    if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        int iResult = AAImbueArrow(oTarget, iSpell, iLevel);

        if (iResult == 1)
        {
            FloatingTextStringOnCreature("* Imbue Arrow success *", OBJECT_SELF);

            //Stops the original spell script from firing.
            PRCSetUserSpecificSpellScriptFinished();

            //If you want the spellhook to end here, uncomment the following line.
            //return;
        }
        else if (iResult == 0)
        {
            FloatingTextStringOnCreature("* Imbue Arrow failure *", OBJECT_SELF);

            //Stops the original spell script from firing.  May be removed, if
            //you have other spells that may affect arrows.
            PRCSetUserSpecificSpellScriptFinished();

            //If you want the spellhook to end here, uncomment the following line.
            //return;
        }
    }
    //... and end copy here.  Paste in front of any other code in the existing
    //spellhook, but inside the void main().
}
