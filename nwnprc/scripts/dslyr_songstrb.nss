#include "minstrelsong"
#include "prc_spell_const"

void main()
{

   int iConc = GetLocalInt(GetAreaOfEffectCreator(), "SpellConc");
   if (!iConc)
   {
        RemoveOldSongEffects(GetAreaOfEffectCreator(),SPELL_DSL_SONG_STRENGTH);
        DestroyObject(OBJECT_SELF);     
   }
 
}