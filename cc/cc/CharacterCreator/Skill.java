package CharacterCreator;

import CharacterCreator.util.ChkHex;

import java.lang.Comparable;
import java.io.IOException;
import javax.swing.ImageIcon;

public class Skill implements Comparable {
	public int Index;
	public Integer IntegerIndex;
	public String Skill;
	public String Description;
	private ImageIcon icon;
	private String iconName;
	public boolean Untrained;
	public String KeyAbility;
	public boolean ArmorCheckPenalty;
	public boolean NonClassSkill;
	public boolean HostileSkill;

    public static int INDEX = 0;
    public static int LABEL = 1;
    public static int SKILL = 2;
    public static int DESCRIPTION = 3;
    public static int ICON = 4;
    public static int UNTRAINED = 5;
    public static int KEYABILITY = 6;
    public static int ARMORCHECKPENALTY = 7;
    public static int ALLCLASSESCANUSE = 8;
    public static int CATEGORY = 9;
    public static int MAXCR = 10;
    public static int CONSTANT = 11;
    public static int HOSTILESKILL = 12; 

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
				catch (IOException ioe) { }
			}
		}

		return icon;
	}

	// This should be changed to allow named column parsing
	private Skill(int index, String[] data) {
		// Use the recommended index
		Index = index;
		IntegerIndex = null;

		Skill = tlkFactory.getEntry(data[SKILL]);
		Description = tlkFactory.getEntry(data[DESCRIPTION]);

		// Store the icon name, load actual icon on demand
		iconName = (data[ICON] == null) ? null : data[ICON].toLowerCase();
		icon = null;

		Untrained = (ChkHex.ChkHex(data[ALLCLASSESCANUSE]) == 1);
		KeyAbility = data[KEYABILITY];
		ArmorCheckPenalty = (ChkHex.ChkHex(data[ARMORCHECKPENALTY]) == 1);
		NonClassSkill = (ChkHex.ChkHex(data[ALLCLASSESCANUSE]) == 1);
		HostileSkill = (ChkHex.ChkHex(data[HOSTILESKILL]) == 1);
	}

	public static Skill ParseSkill(int index, String[] data) {
		
		Skill skill = null;
		if (data[SKILL] != null)
			skill = new Skill(index, data);

		return skill;
	}

	public int compareTo(Object o) {
		return (Skill.compareTo(((Skill)o).Skill));
	}

	public static void InitializeStatics(TLKFactory tlk, ResourceFactory res) {
		tlkFactory = tlk;
		resFactory = res;
	}
}
