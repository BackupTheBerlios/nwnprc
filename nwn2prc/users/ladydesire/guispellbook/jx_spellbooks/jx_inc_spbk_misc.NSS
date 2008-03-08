string JXMetaMagicGetFeatIcon(int iMetaMagic)
{
	switch (iMetaMagic)
	{
		case METAMAGIC_NONE: return "b_empty.tga";
		case METAMAGIC_EMPOWER: return Get2DAString("feat", "ICON", FEAT_EMPOWER_SPELL) + ".tga";
		case METAMAGIC_EXTEND : return Get2DAString("feat", "ICON", FEAT_EXTEND_SPELL) + ".tga";
		case METAMAGIC_MAXIMIZE : return Get2DAString("feat", "ICON", FEAT_MAXIMIZE_SPELL) + ".tga";
		case METAMAGIC_QUICKEN : return Get2DAString("feat", "ICON", FEAT_QUICKEN_SPELL) + ".tga";
		case METAMAGIC_SILENT : return Get2DAString("feat", "ICON", FEAT_SILENCE_SPELL) + ".tga";
		case METAMAGIC_STILL : return Get2DAString("feat", "ICON", FEAT_STILL_SPELL) + ".tga";
		case METAMAGIC_PERSISTENT : return Get2DAString("feat", "ICON", 1679) + ".tga";
		case METAMAGIC_PERMANENT : return "b_empty.tga";
		case METAMAGIC_INVOC_DRAINING_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_DRAINING_BLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_SPEAR : return Get2DAString("spells", "IconResRef", SPELL_I_ELDRITCH_SPEAR) + ".tga";
		case METAMAGIC_INVOC_FRIGHTFUL_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_FRIGHTFUL_BLAST) + ".tga";
		case METAMAGIC_INVOC_HIDEOUS_BLOW : return Get2DAString("spells", "IconResRef", SPELL_I_HIDEOUS_BLOW) + ".tga";
		case METAMAGIC_INVOC_BESHADOWED_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_BESHADOWED_BLAST) + ".tga";
		case METAMAGIC_INVOC_BRIMSTONE_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_BRIMSTONE_BLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_CHAIN : return Get2DAString("spells", "IconResRef", SPELL_I_ELDRITCH_CHAIN) + ".tga";
		case METAMAGIC_INVOC_HELLRIME_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_HELLRIME_BLAST) + ".tga";
		case METAMAGIC_INVOC_BEWITCHING_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_BEWITCHING_BLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_CONE : return Get2DAString("spells", "IconResRef", SPELL_I_ELDRITCH_CONE) + ".tga";
		case METAMAGIC_INVOC_NOXIOUS_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_NOXIOUS_BLAST) + ".tga";
		case METAMAGIC_INVOC_VITRIOLIC_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_VITRIOLIC_BLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_DOOM : return Get2DAString("spells", "IconResRef", SPELL_I_ELDRITCH_DOOM) + ".tga";
		case METAMAGIC_INVOC_UTTERDARK_BLAST : return Get2DAString("spells", "IconResRef", SPELL_I_UTTERDARK_BLAST) + ".tga";
		case METAMAGIC_INVOC_HINDERING_BLAST : return Get2DAString("spells", "IconResRef", 1130) + ".tga";
		case METAMAGIC_INVOC_BINDING_BLAST : return Get2DAString("spells", "IconResRef", 1131) + ".tga";
	}

	return "b_empty.tga";
}

int JXMetaMagicGetFeatName(int iMetaMagic)
{
	switch (iMetaMagic)
	{
		case METAMAGIC_NONE: return 0;
		case METAMAGIC_EMPOWER: return StringToInt(Get2DAString("feat", "FEAT", FEAT_EMPOWER_SPELL));
		case METAMAGIC_EXTEND : return StringToInt(Get2DAString("feat", "FEAT", FEAT_EXTEND_SPELL));
		case METAMAGIC_MAXIMIZE : return StringToInt(Get2DAString("feat", "FEAT", FEAT_MAXIMIZE_SPELL));
		case METAMAGIC_QUICKEN : return StringToInt(Get2DAString("feat", "FEAT", FEAT_QUICKEN_SPELL));
		case METAMAGIC_SILENT : return StringToInt(Get2DAString("feat", "FEAT", FEAT_SILENCE_SPELL));
		case METAMAGIC_STILL : return StringToInt(Get2DAString("feat", "FEAT", FEAT_STILL_SPELL));
		case METAMAGIC_PERSISTENT : return StringToInt(Get2DAString("feat", "FEAT", 1679));
		case METAMAGIC_PERMANENT : return 0;
		case METAMAGIC_INVOC_DRAINING_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_DRAINING_BLAST));
		case METAMAGIC_INVOC_ELDRITCH_SPEAR : return StringToInt(Get2DAString("spells", "Name", SPELL_I_ELDRITCH_SPEAR));
		case METAMAGIC_INVOC_FRIGHTFUL_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_FRIGHTFUL_BLAST));
		case METAMAGIC_INVOC_HIDEOUS_BLOW : return StringToInt(Get2DAString("spells", "Name", SPELL_I_HIDEOUS_BLOW));
		case METAMAGIC_INVOC_BESHADOWED_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_BESHADOWED_BLAST));
		case METAMAGIC_INVOC_BRIMSTONE_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_BRIMSTONE_BLAST));
		case METAMAGIC_INVOC_ELDRITCH_CHAIN : return StringToInt(Get2DAString("spells", "Name", SPELL_I_ELDRITCH_CHAIN));
		case METAMAGIC_INVOC_HELLRIME_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_HELLRIME_BLAST));
		case METAMAGIC_INVOC_BEWITCHING_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_BEWITCHING_BLAST));
		case METAMAGIC_INVOC_ELDRITCH_CONE : return StringToInt(Get2DAString("spells", "Name", SPELL_I_ELDRITCH_CONE));
		case METAMAGIC_INVOC_NOXIOUS_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_NOXIOUS_BLAST));
		case METAMAGIC_INVOC_VITRIOLIC_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_VITRIOLIC_BLAST));
		case METAMAGIC_INVOC_ELDRITCH_DOOM : return StringToInt(Get2DAString("spells", "Name", SPELL_I_ELDRITCH_DOOM));
		case METAMAGIC_INVOC_UTTERDARK_BLAST : return StringToInt(Get2DAString("spells", "Name", SPELL_I_UTTERDARK_BLAST));
		case METAMAGIC_INVOC_HINDERING_BLAST : return StringToInt(Get2DAString("spells", "Name", 1130));
		case METAMAGIC_INVOC_BINDING_BLAST : return StringToInt(Get2DAString("spells", "Name", 1131));
	}

	return 0;
}

string JXMetaMagicGetIcon(int iMetaMagic)
{
	switch (iMetaMagic)
	{
		case METAMAGIC_NONE: return "b_empty.tga";
		case METAMAGIC_EMPOWER: return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_EMPOWER) + ".tga";
		case METAMAGIC_EXTEND : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_EXTEND) + ".tga";
		case METAMAGIC_MAXIMIZE : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_MAXIMIZE) + ".tga";
		case METAMAGIC_QUICKEN : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_QUICKEN) + ".tga";
		case METAMAGIC_SILENT : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_SILENT) + ".tga";
		case METAMAGIC_STILL : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_STILL) + ".tga";
		case METAMAGIC_PERSISTENT : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_PERSISTENT) + ".tga";
		case METAMAGIC_PERMANENT : return "b_empty.tga";
		case METAMAGIC_INVOC_DRAINING_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_DRAININGBLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_SPEAR : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHSPEAR) + ".tga";
		case METAMAGIC_INVOC_FRIGHTFUL_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_FRIGHTFULBLAST) + ".tga";
		case METAMAGIC_INVOC_HIDEOUS_BLOW : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HIDEOUSBLOW) + ".tga";
		case METAMAGIC_INVOC_BESHADOWED_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BESHADOWEDBLAST) + ".tga";
		case METAMAGIC_INVOC_BRIMSTONE_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BRIMSTONEBLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_CHAIN : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHCHAIN) + ".tga";
		case METAMAGIC_INVOC_HELLRIME_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HELLRIMEBLAST) + ".tga";
		case METAMAGIC_INVOC_BEWITCHING_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BEWITCHINGBLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_CONE : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHCONE) + ".tga";
		case METAMAGIC_INVOC_NOXIOUS_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_NOXIOUSBLAST) + ".tga";
		case METAMAGIC_INVOC_VITRIOLIC_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_VITRIOLICBLAST) + ".tga";
		case METAMAGIC_INVOC_ELDRITCH_DOOM : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHDOOM) + ".tga";
		case METAMAGIC_INVOC_UTTERDARK_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_UTTERDARKBLAST) + ".tga";
		case METAMAGIC_INVOC_HINDERING_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HINDERINGBLAST) + ".tga";
		case METAMAGIC_INVOC_BINDING_BLAST : return Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BINDINGBLAST) + ".tga";
	}

	return "b_empty.tga";
}
