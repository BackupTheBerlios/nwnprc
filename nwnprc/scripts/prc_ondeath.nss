//
// Stub function for possible later use.
//

void main()
{

   object oPlayer = GetLastPlayerDied();
   object Asso = GetLocalObject(oPlayer, "BONDED");
   if (GetIsObjectValid(Asso))
   {
     effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
     DestroyObject(Asso);
   } 
}
