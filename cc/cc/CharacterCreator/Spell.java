package CharacterCreator;

import CharacterCreator.util.ChkHex;

import java.lang.Comparable;
import java.io.IOException;
import javax.swing.ImageIcon;

public class Spell implements Comparable {
	public int Index;
	public Integer IntegerIndex;
	public String Spell;
	public String Description;
	private ImageIcon icon;
	private String iconName;

	public String School;
	public String Range;
	public String Vs;

	public int Bard;
	public int Cleric;
	public int Druid;
	public int Paladin;
	public int Ranger;
	public int Wiz_Sorc;
	public int Innate;

	public static int INDEX = 0;
	public static int LABEL = 1;
    public static int SPELL = 2;
    public static int ICON = 3;
    public static int SCHOOL = 4;
    public static int RANGE = 5;
    public static int VS = 6;
    public static int METAMAGIC = 7;
    public static int TARGETTYPE = 8;
    public static int IMPACTSCRIPT = 9;
    public static int BARD = 10;
    public static int CLERIC = 11;
    public static int DRUID = 12; 
    public static int PALADIN = 13;
    public static int RANGER = 14;
    public static int WIZ_SORC = 15;
    public static int INNATE = 16;
    public static int CONJTIME = 17;
    public static int CONJANIM = 18;
    public static int CONJHEADVISUAL = 19;
    public static int CONJHANDVISUAL = 20;
    public static int CONJGRNDVISUAL = 21;
    public static int CONJSOUNDVFX = 22;
    public static int CONJSOUNDMALE = 23;
    public static int CONJSOUNDFEMALE = 24;
    public static int CASTANIM = 25;
    public static int CASTTIME = 26;
    public static int CASTHEADVISUAL = 27;
    public static int CASTHANDVISUAL = 28;
    public static int CASTGRNDVISUAL = 29;
    public static int CASTSOUND = 30;
    public static int PROJ = 31;
    public static int PROJMODEL = 32;
    public static int PROJTYPE = 33;
    public static int PROJSPWNPOINT = 34;
    public static int PROJSOUND = 35;
    public static int PROJORIENTATION = 36;
    public static int IMMUNITYTYPE = 37;
    public static int ITEMIMMUNITY = 38;
    public static int SUBRADSPELL1 = 39;
    public static int SUBRADSPELL2 = 40;
    public static int SUBRADSPELL3 = 41;
    public static int SUBRADSPELL4 = 42;
    public static int SUBRADSPELL5 = 43;
    public static int CATEGORY = 44;
    public static int MASTER = 45;
    public static int USERTYPE = 46;
    public static int DESCRIPTION = 47;
    public static int USECONCENTRATION = 48;
    public static int SPONTANEOUSCAST = 49;
    public static int ALTMESSAGE = 50;
    public static int HOSTILESETTING = 51;
    public static int FEATID = 52; 
    public static int COUNTER1 = 53;
    public static int COUNTER2 = 54; 
    public static int HASPROJECTILE = 55;

	public static TLKFactory tlkFactory;
	public static ResourceFactory resFactory;

	public Integer Index() {
		if (IntegerIndex == null)
			IntegerIndex = new Integer(Index);

		return IntegerIndex;
	}

	public ImageIcon Icon() {
		if (icon == null) {
			if (iconName == null) {
				icon = new ImageIcon(
						getClass().getResource(
						"/CharacterCreator/resource/folder.gif")
					);
			}
			else {
				try {
					icon = resFactory.getIcon(iconName);
				}
				catch (IOException ioe) {
				}
			}
		}

		return icon;
	}

	// This should be changed to allow named column parsing
	private Spell(int index, String[] data) {
		// Use the recommended index
		Index = index;
		IntegerIndex = null;

		Spell = tlkFactory.getEntry(data[SPELL]);
		Description = tlkFactory.getEntry(data[DESCRIPTION]);

		// Store the icon name, load actual icon on demand
		iconName = (data[ICON] == null) ? null : data[ICON].toLowerCase();
		icon = null;


		School = data[SCHOOL];
		Range = data[RANGE];
		Vs = data[VS];

		Bard = ChkHex.ChkHex(data[BARD], -1);
		Cleric = ChkHex.ChkHex(data[CLERIC], -1);
		Druid = ChkHex.ChkHex(data[DRUID], -1);
		Paladin = ChkHex.ChkHex(data[PALADIN], -1);
		Ranger = ChkHex.ChkHex(data[RANGER], -1);
		Wiz_Sorc = ChkHex.ChkHex(data[WIZ_SORC], -1);
		Innate = ChkHex.ChkHex(data[INNATE], -1);
	}

	public static Spell ParseSpell(int index, String[] data) {
		Spell spell = null;
		if (data[SPELL] != null)
			spell = new Spell(index, data);

		return spell;
	}

	public int compareTo(Object o) {
		return Spell.compareTo(((Spell)o).Spell);
	}

	public static void InitializeStatics(TLKFactory tlk, ResourceFactory res) {
		tlkFactory = tlk;
		resFactory = res;
	}
}
