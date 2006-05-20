struct alignment
{
    int nLawChaosValue;
    int nGoodEvilValue;
};

//biowares AdjustAlignment() jumps
//to the middle of the next band when changing.
//This is done to stop players manipulating their alignment easily.
//This function does the opposite.
//
// Adjust the alignment of oSubject.
// - oSubject
// - nAlignment:
//   -> ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_GOOD/ALIGNMENT_EVIL: oSubject's
//      alignment will be shifted in the direction specified
//   -> ALIGNMENT_ALL: nShift will be added to oSubject's law/chaos and
//      good/evil alignment values
//   -> ALIGNMENT_NEUTRAL: nShift is applied to oSubject's law/chaos and
//      good/evil alignment values in the direction which is towards neutrality.
//     e.g. If oSubject has a law/chaos value of 10 (i.e. chaotic) and a
//          good/evil value of 80 (i.e. good) then if nShift is 15, the
//          law/chaos value will become (10+15)=25 and the good/evil value will
//          become (80-25)=55
//     Furthermore, the shift will at most take the alignment value to 50 and
//     not beyond.
//     e.g. If oSubject has a law/chaos value of 40 and a good/evil value of 70,
//          then if nShift is 15, the law/chaos value will become 50 and the
//          good/evil value will become 55
// - nShift: this is the desired shift in alignment
// * No return value
void SmoothAdjustAlignment(object oSubject, int nAlignment, int nShift);

//as SmoothAdjustAlignment except that the size of the shift is scaled based on
//current difference from target value.
//If the difference was maximum, it would do the full shift. Otherwise it will do
//proportionally less, minimum 1
//This will only work for the 5 main alignments, not AIGNMENT_ALL
//This does not support negative shifts
void ScaledSmoothAdjustAlignment(object oSubject, int nAlignment, int nShift, int nTarget);


struct alignment GetCurrentAlignment(object oSubject)
{
    struct alignment aAlign;
    aAlign.nLawChaosValue = GetLawChaosValue(oSubject);
    aAlign.nGoodEvilValue = GetGoodEvilValue(oSubject);
    return aAlign;
}

struct alignment GetTargetAlignment(struct alignment aAlign, int nAlignment, int nShift)
{
    struct alignment aNewAlign = aAlign;
    if(nAlignment == ALIGNMENT_LAWFUL)
        aNewAlign.nLawChaosValue = aAlign.nLawChaosValue+nShift;
    else if(nAlignment == ALIGNMENT_CHAOTIC)
        aNewAlign.nLawChaosValue = aAlign.nLawChaosValue-nShift;
    else if(nAlignment == ALIGNMENT_GOOD)
        aNewAlign.nGoodEvilValue = aAlign.nGoodEvilValue+nShift;
    else if(nAlignment == ALIGNMENT_EVIL)
        aNewAlign.nGoodEvilValue = aAlign.nGoodEvilValue-nShift;
    else if(nAlignment == ALIGNMENT_ALL)
    {
        aNewAlign.nLawChaosValue = aAlign.nLawChaosValue+nShift;
        aNewAlign.nGoodEvilValue = aAlign.nGoodEvilValue+nShift;
    }
    else if(nAlignment == ALIGNMENT_NEUTRAL)
    {
        if(aAlign.nLawChaosValue > 50)
        {
            aNewAlign.nLawChaosValue = aAlign.nLawChaosValue - nShift;
            if(aNewAlign.nLawChaosValue < 50)
                aNewAlign.nLawChaosValue = 50;
        }
        else if(aAlign.nLawChaosValue < 50)
        {
            aNewAlign.nLawChaosValue = aAlign.nLawChaosValue + nShift;
            if(aNewAlign.nLawChaosValue > 50)
                aNewAlign.nLawChaosValue = 50;
        }

        if(aAlign.nGoodEvilValue > 50)
        {
            aNewAlign.nGoodEvilValue = aAlign.nGoodEvilValue - nShift;
            if(aNewAlign.nGoodEvilValue < 50)
                aNewAlign.nGoodEvilValue = 50;
        }
        else if(aAlign.nGoodEvilValue < 50)
        {
            aNewAlign.nGoodEvilValue = aAlign.nGoodEvilValue + nShift;
            if(aNewAlign.nGoodEvilValue > 50)
                aNewAlign.nGoodEvilValue = 50;
        }
    }
    return aNewAlign;
}

void ScaledSmoothAdjustAlignment(object oSubject, int nAlignment, int nShift, int nTarget)
{
    struct alignment aAlign = GetCurrentAlignment(oSubject);
    int nMaxDifference;
    int nCurrDifference;
    if(nAlignment == ALIGNMENT_LAWFUL)
    {
        nMaxDifference = nTarget;
        nCurrDifference = nTarget-aAlign.nLawChaosValue;
    }
    else if(nAlignment == ALIGNMENT_CHAOTIC)
    {
        nMaxDifference = 100-nTarget;
        nCurrDifference = aAlign.nLawChaosValue-nTarget;
    }
    else if(nAlignment == ALIGNMENT_GOOD)
    {
        nMaxDifference = nTarget;
        nCurrDifference = nTarget-aAlign.nGoodEvilValue;
    }
    else if(nAlignment == ALIGNMENT_EVIL)
    {
        nMaxDifference = 100-nTarget;
        nCurrDifference = aAlign.nGoodEvilValue-nTarget;
    }
    else if(nAlignment == ALIGNMENT_NEUTRAL)
    {
        nMaxDifference = 100-nTarget;
        if(nTarget > nMaxDifference)
            nMaxDifference = nTarget;
        nCurrDifference = aAlign.nGoodEvilValue-nTarget;
        if(nTarget-aAlign.nGoodEvilValue > nCurrDifference)
            nCurrDifference = nTarget-aAlign.nGoodEvilValue;
        if(aAlign.nLawChaosValue-nTarget > nCurrDifference)
            nCurrDifference = aAlign.nLawChaosValue-nTarget;
        if(nTarget-aAlign.nLawChaosValue > nCurrDifference)
            nCurrDifference = nTarget-aAlign.nLawChaosValue;
    }
    //now scale it
    nShift = FloatToInt((IntToFloat(nCurrDifference)/IntToFloat(nMaxDifference))*IntToFloat(nShift));
    //minimum of 1
    if(nShift < 1)
        nShift = 1;
    //do the real alignment change
    SmoothAdjustAlignment(oSubject, nAlignment, nShift);
}

void SmoothAdjustAlignment(object oSubject, int nAlignment, int nShift)
{
    struct alignment aAlign = GetCurrentAlignment(oSubject);
    struct alignment aNewAlign = GetTargetAlignment(aAlign, nAlignment, nShift);
    //do one adjustment
    AdjustAlignment(oSubject, nAlignment, nShift);
    //check it was correct
    aAlign = GetCurrentAlignment(oSubject);
    if(aAlign.nLawChaosValue != aNewAlign.nLawChaosValue)
    {
        if(aAlign.nLawChaosValue > aNewAlign.nLawChaosValue)
            AdjustAlignment(oSubject, ALIGNMENT_CHAOTIC, aAlign.nLawChaosValue-aNewAlign.nLawChaosValue);
        else if(aAlign.nLawChaosValue < aNewAlign.nLawChaosValue)
            AdjustAlignment(oSubject, ALIGNMENT_LAWFUL, aNewAlign.nLawChaosValue-aAlign.nLawChaosValue);
    }
    if(aAlign.nGoodEvilValue != aNewAlign.nGoodEvilValue)
    {
        if(aAlign.nGoodEvilValue >  aNewAlign.nGoodEvilValue)
            AdjustAlignment(oSubject, ALIGNMENT_EVIL, aAlign.nGoodEvilValue-aNewAlign.nGoodEvilValue);
        else if(aAlign.nGoodEvilValue < aNewAlign.nGoodEvilValue)
            AdjustAlignment(oSubject, ALIGNMENT_GOOD, aNewAlign.nGoodEvilValue-aAlign.nGoodEvilValue);
    }
}
