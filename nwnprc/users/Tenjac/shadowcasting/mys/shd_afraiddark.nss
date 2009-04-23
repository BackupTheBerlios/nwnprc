//::///////////////////////////////////////////////
//:: Name      
//:: FileName  
//:://////////////////////////////////////////////
/**@file AFRAID OF THE DARK
Apprentice, Umbral Mind
Level/School: 3rd/Illusion (Mind-Affecting, Shadow)
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature
Duration: Instantaneous
Saving Throw: Will half
Spell Resistance: Yes

You draw forth a twisted reflection of your foe from the 
Plane of Shadow. The image unerringly touches the subject, 
causing Wisdom damage equal to 1d6 points +1 point per four
caster levels (maximum +5). A Will saving throw halves the 
Wisdom damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "shd_inc_shdfunc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool(SPELL_SCHOOL_ILLUSION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nLevel = PRCGetMysteryUserLevel(oPC);        
        int nMastery = PRCGetSCMastery(GetSpellId())      
        
        
        GetLocation(oTarget);
        
        
        
        //metashadow block - metashadow reach not listed here as it is much less frequent
        if(GetLocalInt(oPC, "PRC_METASHADOW_MAX"))
        {
                DeleteLocalInt(oPC, "PRC_METASHADOW_MAX");
                nDam = nmax;
        }
        
        if(GetLocalInt(oPC, "PRC_METASHADOW_EMP"))
        {
                DeleteLocalInt(oPC, "PRC_METASHADOW_EMP");
                nDam += (nDam / 2);
        }          
        
        PRCSetSchool();
}