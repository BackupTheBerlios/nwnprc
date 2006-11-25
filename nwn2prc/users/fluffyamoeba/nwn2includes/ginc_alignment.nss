// ginc_alignment
/*
    This include file has functions for adjusting alignment
*/
// FAB 2/8
// ChazM 3/8/05	- file name changed

// This function adjusts oPC's Good/Evil alignment. nChange is from
// -3 (truly evil acts) to +3 (truly saintly acts).
int AdjustGood(object oPC, int nChange);

// This function adjusts oPC's Law/Chaos alignment. nChange is from
// -3 (truly chaotic acts) to +3 (truly lawful acts).
int AdjustLaw(object oPC, int nChange);

int AdjustGood(object oPC, int nChange)
{

    int nAlignCurrent = GetAlignmentGoodEvil( oPC );    // Current alignment
    int nAdjustment;        // How much alignment moves
    int nAlignScale;        // Scale of the alignment (from +3 to -3)

    // Set their current scale
    if ( nAlignCurrent >= 85 ) nAlignScale = 3;
    else if ( nAlignCurrent >= 60 ) nAlignScale = 2;
    else if ( nAlignCurrent >= 25 ) nAlignScale = 1;
    else if ( nAlignCurrent >= -24 ) nAlignScale = 0;
    else if ( nAlignCurrent >= -59 ) nAlignScale = -1;
    else if ( nAlignCurrent >= -84 ) nAlignScale = -2;
    else nAlignScale = -3;

    switch ( nChange )
    {
        case -3:        // FIENDISH ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = -2;
                    break;
                case -2:
                    nAdjustment = -4;
                    break;
                case -1:
                    nAdjustment = -71 - nAlignCurrent;
                    break;
                case 0:
                    nAdjustment = -42 - nAlignCurrent;
                    break;
                case 1:
                    nAdjustment = -nAlignCurrent;
                    break;
                case 2:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
                case 3:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
            }
            break;

        case -2:        // MALEVOLENT ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = -2;
                    break;
                case -1:
                    nAdjustment = -4;
                    break;
                case 0:
                    nAdjustment = -6;
                    break;
                case 1:
                    nAdjustment = -8;
                    break;
                case 2:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
                case 3:
                    nAdjustment = 72 - nAlignCurrent;
                    break;
            }
            break;

        case -1:        // IMPISH ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = 0;
                    break;
                case -1:
                    nAdjustment = -1;
                    break;
                case 0:
                    nAdjustment = -1;
                    break;
                case 1:
                    nAdjustment = -2;
                    break;
                case 2:
                    nAdjustment = -3;
                    break;
                case 3:
                    nAdjustment = 72 - nAlignCurrent;
                    break;
            }
            break;

        case 1:         // KIND ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 3;
                    break;
                case -2:
                    nAdjustment = 3;
                    break;
                case -1:
                    nAdjustment = 2;
                    break;
                case 0:
                    nAdjustment = 1;
                    break;
                case 1:
                    nAdjustment = 1;
                    break;
                case 2:
                    nAdjustment = 0;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 2:         // BENEVOLENT ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 4;
                    break;
                case -2:
                    nAdjustment = 4;
                    break;
                case -1:
                    nAdjustment = 4;
                    break;
                case 0:
                    nAdjustment = 3;
                    break;
                case 1:
                    nAdjustment = 2;
                    break;
                case 2:
                    nAdjustment = 1;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 3:         // SAINTLY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 5;
                    break;
                case -2:
                    nAdjustment = 5;
                    break;
                case -1:
                    nAdjustment = 5;
                    break;
                case 0:
                    nAdjustment = 4;
                    break;
                case 1:
                    nAdjustment = 3;
                    break;
                case 2:
                    nAdjustment = 2;
                    break;
                case 3:
                    nAdjustment = 1;
                    break;
            }
            break;
    }

    if ( nAdjustment > 0 ) AdjustAlignment( oPC,ALIGNMENT_GOOD,nAdjustment );
    else AdjustAlignment( oPC,ALIGNMENT_EVIL,-nAdjustment );

    return nAdjustment;
}

int AdjustLaw(object oPC, int nChange)
{

    int nAlignCurrent = GetAlignmentLawChaos( oPC );    // Current alignment
    int nAdjustment;        // How much alignment moves
    int nAlignScale;        // Scale of the alignment (from +3 to -3)

    // Set their current scale
    if ( nAlignCurrent >= 85 ) nAlignScale = 3;
    else if ( nAlignCurrent >= 60 ) nAlignScale = 2;
    else if ( nAlignCurrent >= 25 ) nAlignScale = 1;
    else if ( nAlignCurrent >= -24 ) nAlignScale = 0;
    else if ( nAlignCurrent >= -59 ) nAlignScale = -1;
    else if ( nAlignCurrent >= -84 ) nAlignScale = -2;
    else nAlignScale = -3;

    switch ( nChange )
    {
        case -3:        // ANARCHIC ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = -1;
                    break;
                case -2:
                    nAdjustment = -2;
                    break;
                case -1:
                    nAdjustment = -3;
                    break;
                case 0:
                    nAdjustment = -4;
                    break;
                case 1:
                    nAdjustment = -5;
                    break;
                case 2:
                    nAdjustment = -5;
                    break;
                case 3:
                    nAdjustment = -5;
                    break;
            }
            break;

        case -2:        // FEY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = -1;
                    break;
                case -1:
                    nAdjustment = -2;
                    break;
                case 0:
                    nAdjustment = -3;
                    break;
                case 1:
                    nAdjustment = -4;
                    break;
                case 2:
                    nAdjustment = -4;
                    break;
                case 3:
                    nAdjustment = -4;
                    break;
            }
            break;

        case -1:        // WILD ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = 0;
                    break;
                case -1:
                    nAdjustment = -1;
                    break;
                case 0:
                    nAdjustment = -1;
                    break;
                case 1:
                    nAdjustment = -2;
                    break;
                case 2:
                    nAdjustment = -2;
                    break;
                case 3:
                    nAdjustment = -3;
                    break;
            }
            break;

        case 1:         // HONEST ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 3;
                    break;
                case -2:
                    nAdjustment = 3;
                    break;
                case -1:
                    nAdjustment = 2;
                    break;
                case 0:
                    nAdjustment = 1;
                    break;
                case 1:
                    nAdjustment = 1;
                    break;
                case 2:
                    nAdjustment = 0;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 2:         // ORDERLY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 4;
                    break;
                case -2:
                    nAdjustment = 4;
                    break;
                case -1:
                    nAdjustment = 4;
                    break;
                case 0:
                    nAdjustment = 3;
                    break;
                case 1:
                    nAdjustment = 2;
                    break;
                case 2:
                    nAdjustment = 1;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 3:         // PARAGON ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 5;
                    break;
                case -2:
                    nAdjustment = 5;
                    break;
                case -1:
                    nAdjustment = 5;
                    break;
                case 0:
                    nAdjustment = 4;
                    break;
                case 1:
                    nAdjustment = 3;
                    break;
                case 2:
                    nAdjustment = 2;
                    break;
                case 3:
                    nAdjustment = 1;
                    break;
            }
            break;
    }

    if ( nAdjustment > 0 ) AdjustAlignment( oPC,ALIGNMENT_LAWFUL,nAdjustment );
    else AdjustAlignment( oPC,ALIGNMENT_CHAOTIC,-nAdjustment );

    return nAdjustment;
}
