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

#include "x2_inc_itemprop"
void main()
{
    object oItem = GetSpellCastItem();
    object oPC =   OBJECT_SELF;

    int i = 0;
    int nSpellId = -1;
    int nMode = GetSpellId();

    int iMax = IPGetItemSequencerProperty(oItem);

    if (iMax ==0) // Should never happen unless you added clear sequencer to a non sequencer item
    {
        return;
    }
    if (nMode == 720 ) // clear seqencer
    {
        for (i = 1; i <= iMax; i++)
        {
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
        }
        DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS");
        effect eClear = EffectVisualEffect(VFX_IMP_BREACH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eClear,OBJECT_SELF);
        FloatingTextStrRefOnCreature(83882,OBJECT_SELF); // sequencer cleared
    }
    else
    {
        int bSuccess = FALSE;
        for (i = 1; i <= iMax; i++)
        {
            nSpellId = GetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
            int nLevel = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
            if (nSpellId>0)
            {
                bSuccess = TRUE;
                nSpellId --; // I added +1 to the spellID when the sequencer was created, so I have to remove it here
                //modified to use the PRCs casterlevel override to cheatcast at the right level
                ActionDoCommand(SetLocalInt(oPC, "PRC_Castlevel_Override", nLevel));
                ActionCastSpellAtObject(nSpellId, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                ActionDoCommand(DeleteLocalInt(oPC, "PRC_Castlevel_Override"));
            }
        }
        if (!bSuccess)
        {
            FloatingTextStrRefOnCreature(83886,OBJECT_SELF); // no spells stored
         }
    }
}