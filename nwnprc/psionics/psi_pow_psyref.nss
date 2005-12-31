/*
   ----------------
   Psychic Reformation

   prc_pow_psyref
   ----------------

   25/3/05 by Stratovarius
*/ /** @file
@todo Later. Check whether we really should allow changing all level-up decisions


    Psychic Reformation

Telepathy [Mind-Affecting]
Level: Psion/wilder 4
Manifesting Time: 10 minutes
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Instantaneous
Saving Throw: None
Power Resistance: No
Power Points: 7, XP; see text
Metapsionics: None

When this power is manifested, the subject can choose to spend its most recently gained skill points differently (picking new skills and abandoning old ones if it chooses) and to choose a different feat from the one it selected when advancing from its previous level to its current level.

The subject can also choose to forget powers it acquired when advancing to its current level, replacing them with new ones.

The subject can undo decisions of these sorts that were made at lower levels, if both the subject and the manifester agree to pay the necessary XP before this power is manifested (see below). The subject must abide by the standard rules for selecting skills and feats, and so it cannot take feats for which it doesn’t qualify or take crossclass skills as class skills.

XP Cost: This power costs 50 XP to manifest to reformat choices made when the character reached her current level. For each additional previous level into which the revision reaches, the power costs an additional 50 XP. The manifester and subject split all XP costs evenly.


   Class: Psion/Wilder
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7

   You delevel yourself down to level 1, and then back up to your current level, allowing you to repick all feats, powers,
   and skill assignments from those levels. You lose XP equal to 50 times the number of levels changed. A level 11 using
   this power would pay a cost of 500 XP. This XP loss can cause you to be deleveled.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/
/*
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);

    if (nMetaPsi > 0)
    {
        int nHD = GetHitDice(oCaster);
        int nXP = (GetXP(oCaster) - (50 * nHD - 1));
        SetXP(oCaster,1);
        DelayCommand(1.0, SetXP(oCaster,nXP));
    }
*/
}