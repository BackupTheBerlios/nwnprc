//
// Stub function for possible later use.
//

void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();

    // One of the Epic Seed books.
    if (GetStringLeft(GetTag(oItem), 8) == "EPIC_SD_")
        ExecuteScript("activate_seeds", oPC);

    // One of the Epic Spell books.
    if (GetStringLeft(GetResRef(oItem), 8) == "epic_sp_")
        ExecuteScript("activate_epspell", oPC);

    // "A Gem Caged Creature" item received from the epic spell Gem Cage.
    if (GetTag(oItem) == "IT_GEMCAGE_GEM")
        ExecuteScript("run_gemcage_gem", oPC);

    // "Whip of Shar" item received from the epic spell Whip of Shar.
    if (GetTag(oItem) == "WhipofShar")
        ExecuteScript("run_whipofshar", oPC);
}
