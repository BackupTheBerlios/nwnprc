#include "inc_npc"
#include "prc_class_const"

void AnimalCompanion()
{

   if (GetMaxHenchmen() < 5)
   {
      SetMaxHenchmen(5);
   }
   
// add
    location loc = GetLocation(OBJECT_SELF);
    vector vloc = GetPositionFromLocation( loc );
    vector vLoc;
    location locSummon;

    vLoc = Vector( vloc.x + (Random(6) - 2.5f),
                       vloc.y + (Random(6) - 2.5f),
                       vloc.z );
        locSummon = Location( GetArea(OBJECT_SELF), vLoc, IntToFloat(Random(361) - 180) );

//

    object oPC = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER);
    string sRef ;
    /*
    if (nClass >= 18) sRef = "acomep_winwolf";
    else  sRef = "acomp_winwolf";
    */ 
    
    if (nClass >= 30) sRef = "acomep_winwolf";
    else  sRef = "acomp_winwolf";
    
    //object oAni = CreateLocalNPC(OBJECT_SELF,ASSOCIATE_TYPE_ANIMALCOMPANION,sRef,locSummon,1);
    //effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
//    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oAni));
    object oAni = CreateObject(OBJECT_TYPE_CREATURE,sRef,locSummon,TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, locSummon);
    
    int HD = GetHitDice(OBJECT_SELF);
    int i;
    for (i = 1; i < nClass; i++)
      LevelUpHenchman( oAni,CLASS_TYPE_MAGICAL_BEAST,TRUE,PACKAGE_ANIMAL);
      
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oAni);
    
    itemproperty ip = GetFirstItemProperty(oCreR);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oCreR, ip);
        ip = GetNextItemProperty(oCreR);
    }
    
    object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oAni);
    int iStr,iDex;
    if (nClass >= 30)
    {
      iStr = (nClass-30)/2;
      iDex = (nClass-31)/2;
    }
    else
    {
      iStr = (nClass-4)/2;
      iDex = (nClass-5)/2;
    }
    
    /*
    int iStr = nClass - 1;
    
    
    if (nClass>= 18) iStr = nClass - 18;
    else  iStr = nClass - 5;
    
    if (iStr>12) iStr = 12;
    */
    if (iStr>0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iStr),oHide);
    if (iDex>0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iDex),oHide);
        
    int Dmg = IP_CONST_MONSTERDAMAGE_1d6;
    int Enh = (nClass/5)+1;

    if (HD>24) {
       Dmg = IP_CONST_MONSTERDAMAGE_1d12;
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d12),oCreR);
    }
    else if (HD>16){ 
    	   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d10),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d10;
    }
    else if (HD>7) {
    	   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d8),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d8;}
    else{
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d6;}
 
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(Dmg),oCreR);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oCreR);  
    
    int iMax;
    int coneAbi = nClass/5;
    if ( coneAbi == 7) iMax = 1;
    else if ( coneAbi == 6) iMax = 2;
    else if ( coneAbi == 5) iMax = 3;
    else if ( coneAbi == 4) iMax = 4;
    else if ( coneAbi == 3) iMax = 5;
    else if ( coneAbi == 2) iMax = 6;
    else if ( coneAbi == 1) iMax = 7;
    
    if (iMax>0)
    {
      for (i = 1; i < iMax; i++)
         DecrementRemainingSpellUses(oAni,230);
    }
    SetLocalObject(OBJECT_SELF, "URANG",oAni);
    SetAssociateState(NW_ASC_HAVE_MASTER,TRUE,oAni);
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
    SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);

    AddHenchman(OBJECT_SELF,oAni);
}

void main()
{
    if (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER))
    {

      object oDes =  GetLocalObject(OBJECT_SELF, "URANG");

      AssignCommand(oDes, SetIsDestroyable(TRUE));
      DestroyObject(oDes);
      DelayCommand(0.4,AnimalCompanion());
       return;
    }



}
