#include "prc_inc_switch"
#include "inc_2dacache"

int GetECL(object oTarget)
{
    int nLevel;
  // we need to use a derivation of the base xp formular to compute the
  // pc level based on total XP.
  //
  // base XP formula (x = pc level, t = total xp):
  //
  //   t = x * (x-1) * 500
  //
  // need to use some base math..
  // transform for pq formula use (remove brackets with x inside and zero right side)
  //
  //   x^2 - x - (t / 500) = 0
  //
  // use pq formula to solve it [ x^2 + px + q = 0, p = -1, q = -(t/500) ]...
  //
  // that's our new formular to get the level based on total xp:
  //   level = 0.5 + sqrt(0.25 + (t/500))
  //
    if(GetPRCSwitch(PRC_ECL_USES_XP_NOT_HD)
        && (GetIsPC(oPC) || GetLocalInt(oPC, "NPC_XP"))))
        nLevel = FloatToInt(0.5 + sqrt(0.25 + ( IntToFloat(GetXP(oPC)) / 500 )));
    else
        nLevel = GetHitDice(oTarget);
    int nRace = GetRacialType(oTarget);
    nLevel += StringToInt(Get2DACache("ECL", "LA", nRace));
    return nLevel;
}