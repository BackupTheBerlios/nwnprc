#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "x2_inc_itemprop" // for checking if item is a weapon

/// +3 on Craft Weapon /////////
void Expert_Bowyer(object oPC ,object oSkin ,int nBowyer)
{

   if(GetLocalInt(oSkin, "PABowyer") == nBowyer) return;

    SetCompositeBonus(oSkin, "PABowyer", nBowyer, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
}

// Removes Power Shot feats if they unequip their bow
void CheckPowerShot(object oPC, int iEquip)
{
      object oWeapon = GetPCItemLastUnequipped();
      int bIsWeapon = FALSE;
      int bHasFeatActive = FALSE;
      int iFeatToActivate;

      // checks the item unequiped is a weapon or not
      if(IPGetIsMeleeWeapon(oWeapon) || GetWeaponRanged(oWeapon) )
      {
           bIsWeapon = TRUE;
      }
      
      // if the feat is activated or not
      if(GetHasFeatEffect(FEAT_PA_POWERSHOT) )
      {
           bHasFeatActive = TRUE;
           iFeatToActivate = FEAT_PA_POWERSHOT;
      }
      else if(GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT) )
      {
           bHasFeatActive = TRUE;
           iFeatToActivate = FEAT_PA_POWERSHOT;
      }
      else if(GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT) )
      {
           bHasFeatActive = TRUE;
           iFeatToActivate = FEAT_PA_POWERSHOT;
      }
      
      // if item removes is weapon and they had power shot active
      // then activate the feat - turns off the effects
      if(bIsWeapon && bHasFeatActive)
      {
           AssignCommand(OBJECT_SELF, ActionUseFeat(iFeatToActivate, OBJECT_SELF) );
      }
}

void main()
{
     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iSneak = GetLocalInt(oPC, "HasPASneak");
    int nBowyer = GetHasFeat(FEAT_EXPERT_BOWYER, oPC) ? 3 : 0;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    

    if (nBowyer>0) Expert_Bowyer(oPC, oSkin, nBowyer);

    // These functions have been superceded by the sneak attack system
    // if (iEquip == 1)    RemoveSneakAttack(oPC, iEquip);   
    // if (iEquip == 2)    AddSneakAttack(oPC, iEquip);
    
    // now only fires on unequip
    if (iEquip == 1)    CheckPowerShot(oPC, iEquip);
}