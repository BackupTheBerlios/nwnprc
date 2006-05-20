object RandomizeItemAppearance(object oItem, int nAC = 0);

#include "random_inc"

// Creates a new copy of an item, while making a single change to the appearance of the item.
// Helmet models and simple items ignore iIndex.
// iType                            iIndex                      iNewValue
// ITEM_APPR_TYPE_SIMPLE_MODEL      [Ignored]                   Model #
// ITEM_APPR_TYPE_WEAPON_COLOR      ITEM_APPR_WEAPON_COLOR_*    1-4
// ITEM_APPR_TYPE_WEAPON_MODEL      ITEM_APPR_WEAPON_MODEL_*    Model #
// ITEM_APPR_TYPE_ARMOR_MODEL       ITEM_APPR_ARMOR_MODEL_*     Model #
// ITEM_APPR_TYPE_ARMOR_COLOR       ITEM_APPR_ARMOR_COLOR_*     0-63
//
// Unlike biowares version, this will only return a valid combo
object CheckedCopyItemAndModify(object oItem, int nType, int nIndex, int nNewValueMin, int nNewValueMax = -1, int bCopyVars=TRUE)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
//        DoDebug("oItem is not valid going into CheckedCopyItemAndModify");
        return OBJECT_INVALID;
    }
    if(nNewValueMax == -1)
        nNewValueMax = nNewValueMin;
    string sTag = "RIG_WP_BaseItem_"+IntToString(GetBaseItemType(oItem));
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE, sTag);
    if(!GetIsObjectValid(oWP))
        return OBJECT_INVALID;
//DoDebug("CheckedCopyItemAndModify("+GetName(oItem)+", "+IntToString(nType)+", "+IntToString(nIndex)+", "+IntToString(nNewValueMin)+", "+IntToString(nNewValueMax)+")");
    object oTest;
    do {
//DoDebug("rig_inc_app3line2");
        int nRandom = RandomI(nNewValueMax-nNewValueMin)+nNewValueMin;
//DoDebug("nRandom = "+IntToString(nRandom));
        int nIsValid = GetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nRandom));
        if(nIsValid == 2)//not valid
        {
            oTest = OBJECT_INVALID;
        }
        else
        {
            oTest = CopyItemAndModify(oItem, nType, nIndex, nRandom, bCopyVars);
            if(GetIsObjectValid(oTest))
                SetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nRandom), 1);
            else
                SetLocalInt(oWP, "Appear_"+IntToString(nType)+"_"+IntToString(nIndex)+"_"+IntToString(nRandom), 2);
        }
//        if(!GetIsObjectValid(oTest))
//            DoDebug("Re-testing");
    } while(!GetIsObjectValid(oTest) && nNewValueMax != nNewValueMin);
    DestroyObject(oItem);
    return oTest;
}
object RandomizeItemAppearance(object oItem, int nAC = 0)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
//        DoDebug("oItem is not valid going into RandomizeItemAppearance");
        return OBJECT_INVALID;
    }
    int nBaseItem = GetBaseItemType(oItem);
    int nModelType = StringToInt(Get2DACache("baseitems", "ModelType", nBaseItem));
    int nMinRange  = StringToInt(Get2DACache("baseitems", "MinRange",  nBaseItem));
    int nMaxRange  = StringToInt(Get2DACache("baseitems", "MaxRange",  nBaseItem));
    object oTest = CopyItem(oItem, OBJECT_INVALID, TRUE);

    int nColourRow;
    int nArmorRow;
    switch(nModelType)
    {
        case 0: //Simple
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, nMinRange, nMaxRange);
            break;
        case 1: //Layered (simple with customizable colors, e.g. helmets)
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, -1, nMinRange, nMaxRange);
            //this is the colour scheme, uses semi-randomization
            nColourRow = StringToInt(GetRandomFrom2DA("rig_color_r", "random_default", 0));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, StringToInt(Get2DACache("rig_colour", "Cloth1", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, StringToInt(Get2DACache("rig_colour", "Cloth2", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, StringToInt(Get2DACache("rig_colour", "Leather1", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, StringToInt(Get2DACache("rig_colour", "Leather2", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, StringToInt(Get2DACache("rig_colour", "Metal1", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, StringToInt(Get2DACache("rig_colour", "Metal2", nColourRow)));
            break;
        case 2: //Composite (weapons & poitions)
        {
            //units are colour
            /*
            nMinRange = nMinRange/10;
            nMaxRange = nMaxRange/10;
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, nMinRange, nMaxRange);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, nMinRange, nMaxRange);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP, nMinRange, nMaxRange);
            //assume all 10 colors used. Not realistic, but hey.
            //for speed, assume 5 used.
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, 0, 5);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, 0, 5);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, 0, 5);
            */
            int nRow         = StringToInt(GetRandomFrom2DA("rig_a_r", "random_default", nBaseItem));
            int nBottom      = StringToInt(Get2DACache("rig_a", "Bottom", nRow));
            int nMiddle      = StringToInt(Get2DACache("rig_a", "Middle", nRow));
            int nTop         = StringToInt(Get2DACache("rig_a", "Top", nRow));
            //too many combinations if you include color
            //assume all 4 colors in all 4 appearances
            //int nBottomColor = StringToInt(Get2DACache("rig_a", "BottomColor", nRow));
            //int nMiddleColor = StringToInt(Get2DACache("rig_a", "MiddleColor", nRow));
            //int nTopColor    = StringToInt(Get2DACache("rig_a", "TopColor", nRow));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, nBottom);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, nMiddle);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP,    nTop);
            //oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, nBottomColor);
            //oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, nMiddleColor);
            //oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP,    nTopColor);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, 1, 4);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, 1, 4);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP,    1, 4);
        }
            break;
        case 3: //Armor
        {
            //should randomize model, but keep the same overall AC.
            nArmorRow = StringToInt(GetRandomFrom2DA("rig_armor_r", "random_default", nAC));
            int nRobe       = StringToInt(Get2DACache("rig_armor", "Robe",      nArmorRow));
            int nNeck       = StringToInt(Get2DACache("rig_armor", "Neck",      nArmorRow));
            int nTorso      = StringToInt(Get2DACache("rig_armor", "Torso",     nArmorRow));
            int nBelt       = StringToInt(Get2DACache("rig_armor", "Belt",      nArmorRow));
            int nPelvis     = StringToInt(Get2DACache("rig_armor", "Pelvis",    nArmorRow));
            int nLShoulder  = StringToInt(Get2DACache("rig_armor", "LShoulder", nArmorRow));
            int nLBicep     = StringToInt(Get2DACache("rig_armor", "LBicep",    nArmorRow));
            int nLForearm   = StringToInt(Get2DACache("rig_armor", "LForearm",  nArmorRow));
            int nLHand      = StringToInt(Get2DACache("rig_armor", "LHand",     nArmorRow));
            int nLThigh     = StringToInt(Get2DACache("rig_armor", "LThigh",    nArmorRow));
            int nLShin      = StringToInt(Get2DACache("rig_armor", "LShin",     nArmorRow));
            int nLFoot      = StringToInt(Get2DACache("rig_armor", "LFoot",     nArmorRow));
            int nRShoulder  = StringToInt(Get2DACache("rig_armor", "RShoulder", nArmorRow));
            int nRBicep     = StringToInt(Get2DACache("rig_armor", "RBicep",    nArmorRow));
            int nRForearm   = StringToInt(Get2DACache("rig_armor", "RForearm",  nArmorRow));
            int nRHand      = StringToInt(Get2DACache("rig_armor", "RHand",     nArmorRow));
            int nRThigh     = StringToInt(Get2DACache("rig_armor", "RThigh",    nArmorRow));
            int nRShin      = StringToInt(Get2DACache("rig_armor", "RShin",     nArmorRow));
            int nRFoot      = StringToInt(Get2DACache("rig_armor", "RFoot",     nArmorRow));

/*
DoDebug("nArmorRow = "+IntToString(nArmorRow));
DoDebug("nNeck = "+IntToString(nNeck));
DoDebug("nTorso = "+IntToString(nTorso));
DoDebug("nBelt = "+IntToString(nBelt));
DoDebug("nPelvis = "+IntToString(nPelvis));
DoDebug("nLShoulder = "+IntToString(nLShoulder));
DoDebug("nLBicep = "+IntToString(nLBicep));
DoDebug("nLForearm = "+IntToString(nLForearm));
DoDebug("nLHand = "+IntToString(nLHand));
DoDebug("nLThigh = "+IntToString(nLThigh));
DoDebug("nLShin = "+IntToString(nLShin));
DoDebug("nLFoot = "+IntToString(nLFoot));
DoDebug("nRShoulder = "+IntToString(nRShoulder));
DoDebug("nRBicep = "+IntToString(nRBicep));
DoDebug("nRForearm = "+IntToString(nRForearm));
DoDebug("nRHand = "+IntToString(nRHand));
DoDebug("nRThigh = "+IntToString(nRThigh));
DoDebug("nRShin = "+IntToString(nRShin));
DoDebug("nRFoot = "+IntToString(nRFoot));
*/

            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE,      nRobe);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT,      nBelt);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK,      nNeck);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO,     nTorso);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP,    nLBicep);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT,     nLFoot);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM,  nLForearm);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND,     nLHand);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN,     nLShin);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, nLShoulder);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH,    nLThigh);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP,    nRBicep);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT,     nRFoot);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM,  nRForearm);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND,     nRHand);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN,     nRShin);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER, nRShoulder);
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH,    nRThigh);

            //this is the colour scheme, uses semi-randomization
            nColourRow = StringToInt(GetRandomFrom2DA("rig_color_r", "random_default", 0));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1,   StringToInt(Get2DACache("rig_colour", "Cloth1",   nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2,   StringToInt(Get2DACache("rig_colour", "Cloth2",   nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, StringToInt(Get2DACache("rig_colour", "Leather1", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, StringToInt(Get2DACache("rig_colour", "Leather2", nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1,   StringToInt(Get2DACache("rig_colour", "Metal1",   nColourRow)));
            oTest = CheckedCopyItemAndModify(oTest, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2,   StringToInt(Get2DACache("rig_colour", "Metal2",   nColourRow)));
        }
            break;
        default:
            //something odds going on here...
            DestroyObject(oTest);
            oTest = OBJECT_INVALID;
            break;
    }
    if(!GetIsObjectValid(oTest))
    {
//        DoDebug("Invalid appearance, rerandomizing "+GetName(oItem));
        oTest = RandomizeItemAppearance(oItem);
    }
    DestroyObject(oItem);
    return oTest;
}
