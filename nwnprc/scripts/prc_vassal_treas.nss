{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Courier New;}{\f1\fswiss\fcharset0 Arial;}}
\viewkind4\uc1\pard\f0\fs20 #include "inc_item_props"\par
#include "prc_feat_const"\par
#include "prc_class_const"\par
\par
void main()\par
\{\par
\par
    // *get the vassal's class level and his armors\par
    int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL,OBJECT_SELF);\par
    object oArmor4 = GetItemPossessedBy(OBJECT_SELF, "PlatinumArmor4");\par
    object oArmor6 = GetItemPossessedBy(OBJECT_SELF, "PlatinumArmor6");\par
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);\par
    object oPC = OBJECT_SELF;\par
    object oSkin = GetPCSkin(oPC);\par
    int bVassal = nVassal /2;\par
\par
\par
    // *Level 1\par
    if (nVassal==1)\par
    // *Give him the Platinum Armor+4\par
    \{\par
    if ( GetLocalInt(OBJECT_SELF, "Level1") == 1) return ;\par
\par
    CreateItemOnObject("Platinumarmor4", OBJECT_SELF, 1);\par
    SetLocalInt(OBJECT_SELF, "Level1", 1);\par
    \}\par
\par
    // *Level 2\par
    if (nVassal==2)\par
    // *Shared Trove\par
    \{\par
    if ( GetLocalInt(OBJECT_SELF, "Level2") == 1) return ;\par
    \{\par
    GiveGoldToCreature(OBJECT_SELF, 20000);\par
    SetLocalInt( OBJECT_SELF, "Level2", 1);\par
    \}\par
    \}\par
\par
\par
    // *Level 5\par
    if (nVassal==5)\par
    // *Shared Trove\par
    \{\par
    if ( GetLocalInt(OBJECT_SELF, "Level5") == 1) return ;\par
    \{\par
    GiveGoldToCreature(OBJECT_SELF, 50000);\par
    SetLocalInt( OBJECT_SELF, "Level5", 1);\par
    \}\par
    // *Platinum Armor +6\par
    DestroyObject(oArmor4, 0.0f);\par
    CreateItemOnObject("Platinumarmor6", OBJECT_SELF, 1);\par
    SetLocalInt( OBJECT_SELF, "Level5", 1);\par
    \}\par
\par
    // *Level 8\par
    if (nVassal==8)\par
    \{\par
    // *Shared Trove\par
    if ( GetLocalInt(OBJECT_SELF, "Level8") == 1) return ;\par
    \{\par
    GiveGoldToCreature(OBJECT_SELF, 80000);\par
    SetLocalInt( OBJECT_SELF, "Level8", 1);\par
    \}\par
    \}\par
\par
    // *Level 10\par
    if (nVassal==10)\par
    \{\par
    // *platinum Armor +8\par
    if ( GetLocalInt(OBJECT_SELF, "Level10") == 1) return ;\par
    DestroyObject(oArmor6, 0.0f);\par
    CreateItemOnObject("Platinumarmor8", OBJECT_SELF, 1);\par
    SetLocalInt( OBJECT_SELF, "Level10", 1);\par
    \}\par
\}\par
\f1\par
}
 