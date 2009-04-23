//::///////////////////////////////////////////////
//:: Name      
//:: FileName  
//:://////////////////////////////////////////////
/**@file 

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
        PRCSetSchool();
        
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
        
        if(GetLocalInt(oPC, "PRC_METASHADOW_EXT"))
        {
                DeleteLocalInt(oPC, "PRC_METASHADOW_EXT");
                fDur += fDur;
        }       
        
        PRCSetSchool();
}