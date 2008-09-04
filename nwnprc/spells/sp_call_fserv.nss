//::///////////////////////////////////////////////
//:: Name      Call Faithful Servants
//:: FileName  sp_call_fserv.nss
//:://////////////////////////////////////////////
/**@file Call Faithful Servants
Conjuration(Calling) [Good]
Level: Celestial 6, cleric 6, sorc/wiz 6
Components: V, S, Abstinance, Celestial
Casting Time: 1 minute
Range: Close
Duration: Instantaneous

You call 1d4 lawful good lantern archons from Celestia,
1d4 chaotic good coure eladrins from Arborea, or 1d4
neutral good mesteval guardinals from Elysium to 
your location.  They serve you for up to one year
as guards, soldiers, spies, or whatever other holy
purpose you have.

No matter how many times you cast this spell, you 
can control no more than 2HD worth of celestials 
per caster level.  If you exceed this number, all
the newly created creatures fall under your 
control, and any excess servants from previous
castings return to their home plane.

Absinance Component: The character must abstain
from casting Conjuration spells for 3 days prior
to casting this spell.

Author:    Tenjac
Created:   6/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_template"

void SummonLoop(int nCounter, location lLoc, object oPC);

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        location lLoc = GetSpellTargetLocation();
        int nCounter = d4(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        if(nMetaMagic == METAMAGIC_MAXIMIZE)
        {
                nCounter = 4;
        }
        if(nMetaMagic == METAMAGIC_EMPOWER)
        {
                nCounter += (nCounter/2);
        }
        
        //Must be celestial
         if(GetHasTemplate(TEMPLATE_CELESTIAL) || 
            GetHasTemplate(TEMPLATE_HALF_CELESTIAL) ||
            (MyPRCGetRacialType(oPC) == RACIAL_TYPE_OUTSIDER && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
            )
         
         {
                 //Get original max henchmen
                 int nMax = GetMaxHenchmen();
                 
                 //Set new max henchmen high
                 SetMaxHenchmen(150);
                 
                 SummonLoop(nCounter, lLoc, oPC);
                 
                 //Restore original max henchmen                 
                 SetMaxHenchmen(nMax);
         }
         
         PRCSetSchool();
         SPGoodShift(oPC);
}

void SummonLoop(int nCounter, location lLoc, object oPC)
{
        while(nCounter > 0)
        {
                //Create appropriate Ghoul henchman
                object oArchon = CreateObject(OBJECT_TYPE_CREATURE, "nw_s_clantern", lLoc, TRUE, "Archon" + IntToString(nCounter)); 
                
                //Make henchman
                AddHenchman(oPC, oArchon);
                
                nCounter--;
                SummonLoop(nCounter, lLoc, oPC);
        }
}
        
        