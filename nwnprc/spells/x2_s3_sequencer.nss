//::///////////////////////////////////////////////
//:: x2_s3_sequencer
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires the spells stored on this sequencer.
    GZ: - Also handles clearing off spells if the
          item has the clear sequencer property
        - added feedback strings
*/
//Modifed by primogenitor to use the PRC casterlevel override for the right level
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2003
//:: Updated By: Georg
//:://////////////////////////////////////////////

#include "prc_inc_spells"


void main()
{
    object oItem = GetSpellCastItem();
    object oPC =   OBJECT_SELF;

    int i = 0;
    int nSpellId = -1;
    int nMode = PRCGetSpellId();
    int iMax = 5;
//    int iMax = IPGetItemSequencerProperty(oItem);
//    if (iMax ==0) // Should never happen unless you added clear sequencer to a non sequencer item
//    {
//        DoDebug("No sequencer on item");
//        return;
//    }
    if (nMode == 720 ) // clear seqencer
    {
        for (i = 1; i <= iMax; i++)
        {
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i));
        }
        DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS");
        effect eClear = EffectVisualEffect(VFX_IMP_BREACH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eClear,OBJECT_SELF);
        FloatingTextStrRefOnCreature(83882,OBJECT_SELF); // sequencer cleared
    }
    else
    {
        int bSuccess = FALSE;
        if(nMode == 700) //Fired via OnHit:CastUniqueSpell
        {
            ClearAllActions();
            DoDebug("Mode 700");
        }
        for (i = 1; i <= iMax; i++)
        {
            nSpellId = GetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
            int nLevel = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
            int nMeta  = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i));
            int nDC    = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i));
		DoDebug("nMode = "+IntToString(nMode));
		DoDebug("nLevel = "+IntToString(nLevel));
		DoDebug("nMeta = "+IntToString(nMeta));
		DoDebug("nDC = "+IntToString(nDC));
            if (nSpellId>0)
            {
                bSuccess = TRUE;
                nSpellId --; // I added +1 to the spellID when the sequencer was created, so I have to remove it here
                //modified to use the PRCs casterlevel override to cheatcast at the right level                
                ActionCastSpell(nSpellId, nLevel,0, nDC, nMeta);
                DoDebug("Channel Spell Cast");
            }
        }
        if (!bSuccess)
        {
            FloatingTextStrRefOnCreature(83886,OBJECT_SELF); // no spells stored
        }
        if(nMode == 700 //Fired via OnHit:CastUniqueSpell
            && GetLocalInt(oItem, "DuskbladeChannelDischarge")!=2)//and not a discharging duskblade
        {
            DoDebug("Mode 700, Not a Duskblade Discharge");
            ActionAttack(GetAttackTarget());
            //clear the settings
            for (i = 1; i <= iMax; i++)
            {
                DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
                DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
                DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i));
                DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i));
            }
            DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS");
        }
        else if(nMode == 700 //Fired via OnHit:CastUniqueSpell
            && GetLocalInt(oItem, "DuskbladeChannelDischarge")==2)//and is a discharging duskblade
        {
            DoDebug("Mode 700, Duskblade Discharge");
            ActionAttack(GetAttackTarget());
            //clear the settings
            for (i = 1; i <= iMax; i++)
            {
                DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER"   + IntToString(i)));
                DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i)));
                DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i)));
                DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i)));
            }
            DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS"));
        }
    }
}