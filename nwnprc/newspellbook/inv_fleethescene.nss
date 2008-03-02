//::///////////////////////////////////////////////
//:: Spell: Dimension Door
//:: sp_dimens_door
//::///////////////////////////////////////////////
/** @ file
    Dimension Door

    Conjuration (Teleportation)
    Level: Brd 4, Sor/Wiz 4, Travel 4
    Components: V
    Casting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Target: You and other touched willing creatures (ie. party members within 10ft of you)
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired—whether by simply visualizing the area or by
    stating direction**. You may also bring one additional willing Medium or smaller creature
    or its equivalent per three caster levels. A Large creature counts as two Medium creatures,
    a Huge creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
    * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
    ** The direction is the same as the direction of where you target the spell relative to you.
       A listener will be created so you can say the distance.

    @author Ornedan
    @date   Created  - 2005.07.04
    @date   Modified - 2005.10.12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_dimdoor"
#include "prc_inc_shifting"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void CleanCopy(object oImage)
{
    SetLootable(oImage, FALSE);
    // remove inventory contents
    object oItem = GetFirstItemInInventory(oImage);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oImage);
    }
    // remove non-visible equipped items
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oImage);
        if(GetIsObjectValid(oItem))
        {
            if(i == INVENTORY_SLOT_HEAD || i == INVENTORY_SLOT_CHEST ||
                i == INVENTORY_SLOT_RIGHTHAND || i == INVENTORY_SLOT_LEFTHAND ||
                i == INVENTORY_SLOT_CLOAK) // visible equipped items
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
                // remove all item properties
                itemproperty ipLoop=GetFirstItemProperty(oItem);
                while (GetIsItemPropertyValid(ipLoop))
                {
                    RemoveItemProperty(oItem, ipLoop);
                    ipLoop=GetNextItemProperty(oItem);
                }
            }
            else // can't see it so destroy
            {                
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            }
        }
        
    }
    TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void CreateDecoy()
{
    int iImages = 1;
    int nDuration = 1;
    

    string sImage = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";

    effect eImage = EffectCutsceneParalyze();
           eImage = SupernaturalEffect(eImage);
    effect eGhost = EffectCutsceneGhost();
           eGhost = SupernaturalEffect(eGhost);
    effect eNoSpell = EffectSpellFailure(100);
           eNoSpell = SupernaturalEffect(eNoSpell);
    
    // make, then clean up, first image and copy it, not the PC for subsequent images
    object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);
    CleanCopy(oImage);
    
    // images will have only 1 HP
    int iHP = GetCurrentHitPoints(oImage);
    --iHP;
    effect eDamage = EffectDamage(iHP); // reduces image to 1 hp

    // these need to be applied to every image
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oImage);
    SetImmortal(oImage, TRUE);
    ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
    SetIsTemporaryFriend(OBJECT_SELF, oImage, FALSE);
    DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oImage));
    DestroyObject(oImage, RoundsToSeconds(1));
}

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    /* Main spellscript */
    object oCaster   = OBJECT_SELF;
    int nCasterLvl   = GetInvokerLevel(oCaster, GetInvokingClass());
    int nSpellID     = PRCGetSpellId();
    int bUseDirDist  = nSpellID == INVOKE_FLEE_THE_SCENE_DIRDIST;
    SetLocalInt(oCaster, "FleeTheScene", TRUE);

    DimensionDoor(oCaster, nCasterLvl, nSpellID, "", DIMENSIONDOOR_SELF, bUseDirDist);
    if(!bUseDirDist)
        CreateDecoy();
    else
    DelayCommand(10.0, CreateDecoy());
    
    DelayCommand(10.1, DeleteLocalInt(oCaster, "FleeTheScene"));

}


