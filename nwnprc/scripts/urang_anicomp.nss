#include "heartward_inc"
#include "soul_inc"
#include "inc_npc"


void AnimalCompanion()
{

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
    if (nClass<10) sRef = "nw_ac_dwlf0"+IntToString(nClass);
    else sRef = "nw_ac_dwlf"+IntToString(nClass);
 
    object oAni = CreateLocalNPC(OBJECT_SELF,ASSOCIATE_TYPE_ANIMALCOMPANION,sRef,locSummon,1);
    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
//    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oAni));
    SetLocalObject(OBJECT_SELF, "URANG",oAni);

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
