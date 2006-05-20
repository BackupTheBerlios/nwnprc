//grey mushroom spawn
void main()
{
    //25% glow
    if(Random(4))
        return;
    int nVFX;
    switch(Random(2))
    {
        case 0:
        switch(Random(15))
        {
            case 0: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 1: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 2: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 3: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 4: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 5: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 6: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 7: nVFX = VFX_DUR_LIGHT_GREY_5; break;
            case 8: nVFX = VFX_DUR_LIGHT_GREY_10; break;
            case 9: nVFX = VFX_DUR_LIGHT_GREY_10; break;
            case 10: nVFX = VFX_DUR_LIGHT_GREY_10; break;
            case 11: nVFX = VFX_DUR_LIGHT_GREY_10; break;
            case 12: nVFX = VFX_DUR_LIGHT_GREY_15; break;
            case 13: nVFX = VFX_DUR_LIGHT_GREY_15; break;
            case 14: nVFX = VFX_DUR_LIGHT_GREY_20; break;
        }
        break;
        case 1:
        switch(Random(15))
        {
            case 0: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 1: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 2: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 3: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 4: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 5: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 6: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 7: nVFX = VFX_DUR_LIGHT_WHITE_5; break;
            case 8: nVFX = VFX_DUR_LIGHT_WHITE_10; break;
            case 9: nVFX = VFX_DUR_LIGHT_WHITE_10; break;
            case 10: nVFX = VFX_DUR_LIGHT_WHITE_10; break;
            case 11: nVFX = VFX_DUR_LIGHT_WHITE_10; break;
            case 12: nVFX = VFX_DUR_LIGHT_WHITE_15; break;
            case 13: nVFX = VFX_DUR_LIGHT_WHITE_15; break;
            case 14: nVFX = VFX_DUR_LIGHT_WHITE_20; break;
        }
        break;
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        SupernaturalEffect(EffectVisualEffect(nVFX)),
        OBJECT_SELF);
}
