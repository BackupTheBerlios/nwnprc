/*
 * PackageHandler.java
 *
 * Created on December 14, 2003, 9:55 PM
 *
 * This class dictates the following things, in the following order:
 *
 *First of all, you must have a valid package. Check for valid package, load.
 *Check for valid SpellPref2da.
 *Check for valid FeatPref2da.
 *Check for valid SkillPref2da.
 *
 *If all are valid, we then break everything down.
 *
 *First step, skills.
 *Then feats.
 *Then, if present, assorted spell related crap. (School & Domain)
 *Then, if present, spells.
 *Then, if present, assign associate.
 *Finally, wrap it up with assorted crap that is not one of the above.
 */

package CharacterCreator;

import java.io.*;
import javax.swing.*;
import java.util.*;
import CharacterCreator.defs.*;
/**
 *
 * @author  James
 */
public class PackageHandler {
    
    private int i = 0;
    private int classn = 0;
    private CreateMenu menucreate;
    private ProgressBar progressbar;
    private LinkedList featlist;
    private LinkedList skilllist;
    private LinkedList spellsknown0;
    private LinkedList spellsknown1;
    private LinkedList classfeatlist;
    private LinkedList availclassfeatlist;
    private LinkedList ccskill;
    private ResourceFactory RESFAC;
    private String[] packagesmap;
    private Feat[] featmap;
    private Skill[] skillmap;
    private String[][] attackmap;
    private String[][] racefeat2damap;
    private String[][] classfeat2damap;
    private String[][] bonusfeat2damap;
    private String[][] featpref2damap;
    private String[][] skillpref2damap;
    private String[][] classsk2damap;
	private String[][] spellgain2damap;        
    private boolean DivCaster;
    private boolean WizCaster;
    private boolean SorCaster;
    private boolean Spellcaster;
    
    private int famtype;
    private String famname;
    private int comptype;
    private String compname;
    
    private int domain1 = 0;
    private int domain2 = 0;
    private int school = 0;
    
    /** Creates a new instance of PackageHandler */
    public PackageHandler() {
        menucreate = TLKFactory.getCreateMenu();
        //Time to break out the progress bar
        progressbar = new ProgressBar();
        //progressbar.ProgressText.setText("Loading Dialog.TLK...");
        progressbar.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        progressbar.ProgressBar.setStringPainted(false);
        progressbar.ProgressBar.setIndeterminate(true);
        progressbar.show();
        
        //Set up us the linked list
        featlist = new LinkedList();
        skilllist = new LinkedList();
        spellsknown0 = new LinkedList();
        spellsknown1 = new LinkedList();
        availclassfeatlist = new LinkedList();
        ccskill = new LinkedList();
        classfeatlist = new LinkedList();
        RESFAC = menucreate.getResourceFactory();
        
        //Time to set up for the sets
        packagesmap = menucreate.MainCharDataAux[7];
        classn = Integer.parseInt(menucreate.MainCharDataAux[3][0]);
        
        HandleSkills();
        
        HandleFeats();
        
        //We need to determine whether or not the char is a divine and/or arcane spellcaster
        Spellcaster = false;
        if(menucreate.MainCharDataAux[3][classes.SpellCaster].equalsIgnoreCase("1")) {
            //You ARE a spell caster. Arcane or divine?
            if(menucreate.MainCharDataAux[7][packages.School] != null) {
                //ARCANE = true
                //Can you specialize?
                //System.out.println("Data in 7:6: " + ((String)menucreate.MainCharData[3].get(new Integer(classes.SpellKnownTable))));
                if(menucreate.MainCharDataAux[3][classes.SpellKnownTable] == null) {
                    //Yes. Wizard class.
                    WizCaster = true;
                    Spellcaster = true;
                } else {
                    //No. Other caster
                    SorCaster = true;
                    Spellcaster = true;
                }
            } else {
                //DIVINE = true
                //Do you have 2 domains?
                if(menucreate.MainCharDataAux[7][packages.Domain1] != null
						|| menucreate.MainCharDataAux[7][packages.Domain2] != null) {
                    DivCaster = true;
                    Spellcaster = true;
                }
                //You are not a cleric type, so you don't care about domains
                //You have all clerical spells, or spells for your class
                
            }
        }
        
        if(Spellcaster) {
            HandleSpellRelated();
            
            HandleSpells();
        }
        
        HandleAssociate();
        
        HandleAssorted();
        
        
        //Write the data to the main menu, and reset everything correctly
        progressbar.ProgressText.setText("Finalizing Data...");
        menucreate.MainCharData[8] = new HashMap();
        for(i=0; i < skilllist.size(); i++) {
            menucreate.MainCharData[8].put(new Integer(i), skilllist.get(i));
        }
        menucreate.MainCharData[9] = new HashMap();
        menucreate.MainCharData[9].put(new Integer(0),new Integer(featlist.size()));
        for(i=0; i < featlist.size(); i++) {
            menucreate.MainCharData[9].put(new Integer(i+1),featlist.get(i));
        }
        menucreate.MainCharData[10] = new HashMap();
        menucreate.MainCharData[10].put(new Integer(0),new Integer(spellsknown0.size()));
        for(int i = 0; i < spellsknown0.size(); i++) {
            menucreate.MainCharData[10].put(new Integer(i+1),spellsknown0.get(i));
        }
        menucreate.MainCharData[11] = new HashMap();
        menucreate.MainCharData[11].put(new Integer(0),new Integer(spellsknown1.size()));
        for(int i = 0; i < spellsknown1.size(); i++) {
            menucreate.MainCharData[11].put(new Integer(i+1),spellsknown1.get(i));
        }
        if(menucreate.MainCharData[14] == null) {
            menucreate.MainCharData[14] = new HashMap();
        }
        if(famname != null) {
            menucreate.MainCharData[14].put(new Integer(1), new Integer(famtype));
            menucreate.MainCharData[14].put(new Integer(0), famname);
        }
        if(compname != null) {
            menucreate.MainCharData[14].put(new Integer(3), new Integer(comptype));
            menucreate.MainCharData[14].put(new Integer(2), compname);
        }
        if(menucreate.MainCharData[16] == null) {
            menucreate.MainCharData[16] = new HashMap();
        }
        if(domain1 != 0) {
            menucreate.MainCharData[16].put(new Integer(1), new Integer(domain1));
            menucreate.MainCharData[16].put(new Integer(2), new Integer(domain2));
        }
        if(school != 0) {
            menucreate.MainCharData[16].put(new Integer(0), new Integer(school));
        }
        //And finally
        menucreate.BlockWindow(false);
        menucreate.CustomizeButton.setEnabled(true);
        menucreate.RedoAll();
        progressbar.setVisible(false);
        progressbar.dispose();
    }
    
    private void HandleSkills() {
        progressbar.ProgressText.setText("Selecting Skills...");
        String skillpref2da = packagesmap[packages.SkillPref2DA];
        String classsk2da = menucreate.MainCharDataAux[3][classes.SkillsTable];
        int baseskillpoints = Integer.parseInt(menucreate.MainCharDataAux[3][classes.SkillPointBase]);
		skillmap = SkillMap.GetSkillMap();
        try {
            skillpref2damap = RESFAC.getResourceAs2DA(skillpref2da);
            classsk2damap = RESFAC.getResourceAs2DA(classsk2da);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + skillpref2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        int intmod = new Integer(((String)menucreate.MainCharData[5].get(new Integer(15)))).intValue();
        int skillpoints = 4 * (baseskillpoints + intmod);
        
        int racenumber = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        if(racenumber == 6) {
            //if(featlist.contains(new Integer(258))) {
            skillpoints += 4;
        }
        //LinkedList ccskill = new LinkedList();
        for(i = 0; i<skillmap.length; i++) {
            ccskill.add(null);
            skilllist.add(new Integer(0));
        }
        try {
            //System.out.println("Size of ClassSkill2daMap: " + classsk2damap.length);
            for(i = 0; i<classsk2damap.length; i++) {
                if(classsk2damap[i][clsskill.SkillIndex] != null) {
                    String clsentry = classsk2damap[i][clsskill.SkillIndex];
                    int skillchange = Integer.parseInt(clsentry);
                    //int skillchange = (new Integer((String)classsk2damap[i].get(new Integer(clsskill.SkillIndex)))).intValue();
                    ccskill.set(skillchange, new Integer(classsk2damap[i][clsskill.ClassSkill]));
                }
            }
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - " + classsk2da + ", line " + i + ".\nError returned: " + err, "Error", 0);
            System.exit(0);
        }
        catch(IndexOutOfBoundsException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - " + classsk2da + ", line " + i + ".\nError returned: " + err, "Error", 0);
            System.exit(0);
        }
        //for(i = 0; i<skillmap.length; i++) {
        //for(i = 0; i<numskills; i++) {
        //    skilllist.add(new Integer(0));
        //}
        //System.out.println("CCSkill list: " + ccskill.toString());
        int skillentry = 0;
        //System.out.println("This is skill package " +skill2da);
        //System.out.println("Beginning skill points: " + skillpoints);
        for(i = skillpoints; i > 0; i--) {
            int entrynum = Integer.parseInt(skillpref2damap[skillentry][1]);
            //System.out.println("Entrynum: " + entrynum);
            //System.out.println("Current skill ranks: " + ((Integer)skilllist.get(entrynum)).intValue());
            if(
            (((Integer)skilllist.get(entrynum)).intValue() < 4 && ((Integer)ccskill.get(entrynum)).intValue() == 1)
            ||
            (((Integer)skilllist.get(entrynum)).intValue() < 2 && ((Integer)ccskill.get(entrynum)).intValue() == 0)
            ) {
                int oldnum = ((Integer)skilllist.get(entrynum)).intValue();
                if(((Integer)ccskill.get(entrynum)).intValue() == 1) {
                    skilllist.set(entrynum, new Integer(++oldnum));
                }
                if(((Integer)ccskill.get(entrynum)).intValue() == 0) {
                    skilllist.set(entrynum, new Integer(++oldnum));
                    i--;
                }
            } else {
                skillentry++;
                i++;
            }
            //System.out.println("Current points: " + i);
        }
        //System.out.println(skilllist.toString());
    }
    
    private void HandleFeats() {
        progressbar.ProgressText.setText("Selecting Feats...");
		featmap = FeatMap.GetFeatMap();

        String attack2da = menucreate.MainCharDataAux[3][classes.AttackBonusTable];
        String racefeat2da = menucreate.MainCharDataAux[1][racialtypes.FeatsTable];
        String classfeat2da = menucreate.MainCharDataAux[3][classes.FeatsTable];
        String classskill2da = menucreate.MainCharDataAux[3][classes.SkillsTable];
        String bonusfeat2da = menucreate.MainCharDataAux[3][classes.BonusFeatsTable];
        String featpref2da = packagesmap[packages.FeatPref2DA];
		String SpellGainTable = menucreate.MainCharDataAux[3][classes.SpellGainTable];
        try {
            attackmap = RESFAC.getResourceAs2DA(attack2da);
            if(racefeat2da != null)
                racefeat2damap = RESFAC.getResourceAs2DA(racefeat2da);
            if(classfeat2da != null)
                classfeat2damap = RESFAC.getResourceAs2DA(classfeat2da);
            if(bonusfeat2da != null)
                bonusfeat2damap = RESFAC.getResourceAs2DA(bonusfeat2da);
            if(featpref2da != null)
                featpref2damap = RESFAC.getResourceAs2DA(featpref2da);
			if (SpellGainTable != null)
				spellgain2damap = RESFAC.getResourceAs2DA(SpellGainTable);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + featpref2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        //System.out.println("Class Feat 2da: " + classfeat2da);
        //System.out.println("Class Feat 2da length: " + classfeat2damap.length);
        for(i = 0; i < classfeat2damap.length; i++) {
            if(classfeat2damap[i][clsfeat.GrantedOnLevel] != null) {
                if(classfeat2damap[i][clsfeat.GrantedOnLevel].equalsIgnoreCase("1")
						&& classfeat2damap[i][clsfeat.List].equalsIgnoreCase("3")) {
                    String tmp = classfeat2damap[i][clsfeat.FeatIndex];
                    //System.out.println(tmp);
                    featlist.add(new Integer(classfeat2damap[i][clsfeat.FeatIndex]));
                    //startfeatlist.add(new Integer(((String)classfeat2damap[i].get(new Integer(clsfeat.FeatIndex)))));
                }
            }
            if(classfeat2damap[i][clsfeat.FeatIndex] != null) {
				classfeatlist.add(new Integer(classfeat2damap[i][clsfeat.FeatIndex]));
				if(classfeat2damap[i][clsfeat.GrantedOnLevel].equalsIgnoreCase("-1")
						|| classfeat2damap[i][clsfeat.GrantedOnLevel].equalsIgnoreCase("1")
						&& classfeat2damap[i][clsfeat.List].equalsIgnoreCase("0")) {
					if(classfeat2damap[i][clsfeat.List].equalsIgnoreCase("0")) {
						availclassfeatlist.add(new Integer(classfeat2damap[i][clsfeat.FeatIndex]));
					}
				}
            }
        }
        for(i = 0; i < racefeat2damap.length; i++) {
            if(racefeat2damap[i][racefeat.FeatIndex] != null) {
                featlist.add(new Integer(racefeat2damap[i][racefeat.FeatIndex]));
                //startfeatlist.add(new Integer(((String)racefeat2damap[i].get(new Integer(racefeat.FeatIndex)))));
            }
        }
        int numfeats = 1;
        //If they have Quick to Master, add a feat
        if(featlist.contains(new Integer(258))) {
            numfeats++;
        }
        //If class is fighter, add a feat
        //Defunct with bonus feat tables
        
        if(bonusfeat2damap[0][1] != null) {
            int numbonusfeats = Integer.parseInt(bonusfeat2damap[0][1]);
            for(int g = 0; g < numbonusfeats; g++) {
                numfeats++;
            }
        }
        
        //System.out.println("Total feat num: " + numfeats);
        int featposition = 0;
        for(i = 0; i < numfeats; i++) {
            //Uh, check to see if the feat is valid for this character - DUH
            int featnum = Integer.parseInt(featpref2damap[featposition][1]);
            if (featmap[featnum] != null && isValidFeat(featmap[featnum])) {
                featlist.add(new Integer(featpref2damap[featposition++][1]));
            } else {
                featposition++;
                i--;
            }
        }
        //If the character is a ranger, add a favored enemy based on the package
        if(classn == 7) {
            int favoredenemy = GetFirstFavored();
            if(favoredenemy > 0) {
                //int favoredenemy = new Integer(((String)feat2damap[0].get(new Integer(1)))).intValue();
                featlist.add(new Integer(favoredenemy));
            }
        }
        
        // END OF FEAT ALLOCATION
        //System.out.println(featlist.toString());
    }
    
    private void HandleSpellRelated() {
        progressbar.ProgressText.setText("Selecting Spells...");
        if(Spellcaster && WizCaster) {
            school = Integer.parseInt(packagesmap[packages.School]);
        }
        
        if(DivCaster) {
            domain1 = Integer.parseInt(packagesmap[packages.Domain1]);
            domain2 = Integer.parseInt(packagesmap[packages.Domain2]);
            try {
                String[][] domain2damap = RESFAC.getResourceAs2DA("domains");

				if(domain2damap[domain1][dom.GrantedFeat] != null)
					featlist.add(new Integer(domain2damap[domain1][dom.GrantedFeat]));
				if(domain2damap[domain2][dom.GrantedFeat] != null)
					featlist.add(new Integer(domain2damap[domain2][dom.GrantedFeat]));
            }
            catch(IOException err) {
                JOptionPane.showMessageDialog(null, "Fatal Error - domains.2da not found. Your data files might be corrupt.", "Error", 0);
                System.exit(0);
            }
        }
    }
    
    private void HandleSpells() {
        progressbar.ProgressText.setText("Selecting Spells...");
        //Wizards have a static number they get; all 0 level, and 3+int mod 1st level
        //Sorcerers and Bards go off a chart.
        if(Spellcaster && !DivCaster) {
            int intmod = new Integer(((String)menucreate.MainCharData[5].get(new Integer(15)))).intValue();
            //String spellallowed2da = ((String)packagesmap.get(new Integer(13)));
            String spellpref2da = packagesmap[packages.SpellPref2DA];
            //System.out.println("Spell Pref 2da: " + spellpref2da);
            String[][] spellpref2damap = null;
            LinkedList wiz0lvl = new LinkedList();
            LinkedList wiz1lvl = new LinkedList();
            LinkedList bard0lvl = new LinkedList();

			Spell[] spellmap = SpellMap.GetSpellMap();
			for (int ii=0; ii < spellmap.length; ++ii) {
				if (spellmap[ii] != null) {
					if (spellmap[ii].Bard == 0)
						bard0lvl.add(spellmap[ii].Index());
					if (spellmap[ii].Wiz_Sorc == 0)
						wiz0lvl.add(spellmap[ii].Index());
					else if (spellmap[ii].Wiz_Sorc == 1)
						wiz1lvl.add(spellmap[ii].Index());
				}
			}

            try {
                spellpref2damap = RESFAC.getResourceAs2DA(spellpref2da);
            }
            catch(IOException err) {
                JOptionPane.showMessageDialog(null, "Fatal Error - " + spellpref2da + " not found. Your data files might be corrupt.", "Error", 0);
                System.exit(0);
            }

            String spknowntable = menucreate.MainCharDataAux[3][classes.SpellKnownTable];
            if(spknowntable == null) {
                //Wizard stuff
                int sk0 = 4; //Make this all 0 level spells?
                int sk1 = 3 + intmod;
                spellsknown0 = wiz0lvl;
                int entrynumber = 0;
                for(i = 0; i < sk1; i++) {
                    if(wiz1lvl.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                        spellsknown1.add(new Integer(spellpref2damap[entrynumber][1]));
                        entrynumber++;
                    } else {
                        i--;
                        entrynumber++;
                    }
                }
            } else {
                //Bard and sorc stuff
                //HAVE to determine, hard coded, whether class is bard or sorc
                String[][] spknownmap = null;
                try {
                    spknownmap = RESFAC.getResourceAs2DA(spknowntable);
                }
                catch(IOException err) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - " + spknowntable + " not found. Your data files might be corrupt.", "Error", 0);
                    System.exit(0);
                }
                if(classn == 9) { // Sorcerer
                    int sk0 = Integer.parseInt(spknownmap[0][spkn.SpellLevel0]);
                    int sk1 = Integer.parseInt(spknownmap[0][spkn.SpellLevel1]);
                    int entrynumber = 0;
                    for(i = 0; i < sk0; i++) {
                        if(wiz0lvl.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                            spellsknown0.add(new Integer(spellpref2damap[entrynumber][1]));
                            entrynumber++;
                        } else {
                            i--;
                            entrynumber++;
                        }
                    }
                    entrynumber = 0;
                    for(i = 0; i < sk1; i++) {
                        //System.out.println("Entry " + i);
                        //System.out.println("Testing spell " + new Integer(((String)spellpref2damap[entrynumber].get(new Integer(1)))).intValue());
                        if(wiz1lvl.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                            spellsknown1.add(new Integer(spellpref2damap[entrynumber][1]));
                            entrynumber++;
                        } else {
                            i--;
                            entrynumber++;
                        }
                    }
                }
                if(classn == 1) { // Bard
                    int sk0 = Integer.parseInt(spknownmap[0][spkn.SpellLevel0]);
                    //int sk1 = 3 + intmod;
                    //spellsknown0 = wiz0lvl;
                    //System.out.println("Size of spellprefmap : " + spellpref2damap.length);
                    //System.out.println("Last entry: " + spellpref2damap[spellpref2damap.length - 1]);
                    int entrythings = 0;
                    for(i = 0; i < sk0; i++) {
                        //System.out.println("Entry " + i);
                        //System.out.println("Testing spell " + new Integer(((String)spellpref2damap[entrythings].get(new Integer(1)))).intValue());
                        if(bard0lvl.contains(new Integer(spellpref2damap[entrythings][1]))) {
                            spellsknown0.add(new Integer(spellpref2damap[entrythings][1]));
                            entrythings++;
                        } else {
                            i--;
                            entrythings++;
                        }
                    }
                }
            }
        }
        System.out.println("Lv0: " + spellsknown0.toString());
        System.out.println("Lv1: " + spellsknown1.toString());
        //END of SPELL ALLOCATION
    }
    
    private void HandleAssociate() {
        progressbar.ProgressText.setText("Selecting Familiars...");
        if(featlist.contains(new Integer(303))) { // Set info about familiar
            famtype = Integer.parseInt(packagesmap[packages.Associate]);;
            famname = "Merath";
        }
        
        if(featlist.contains(new Integer(199))) { // Set info about companion
            comptype = Integer.parseInt(packagesmap[packages.Associate]);;
            compname = "Forik";
        }
    }
    
    private void HandleAssorted() {
    }

	private int calcSkill(int skillnum) {
		// Skill is unknown and requires training
		int retval = -1;

		// Is this skill known?  If so return the amount.
		if(menucreate.MainCharData[8] != null) {
			Integer skill = new Integer(skillnum);
			skill = (Integer)menucreate.MainCharData[8].get(skill);
			if (skill.intValue() > 0)
				retval = skill.intValue();
		}

		// Skill doesn't require training so we get 0 as a default value
		if (retval < 0 && skillmap[skillnum].Untrained)
			retval = 0;

		return retval;
	}

 
    
    private boolean isValidFeat(Feat feat) {
		// Test that this feat is valid
		if (feat == null)
			return false;

		// Debug variable
        boolean extra = false;

		// Second, this routine filters feat that are already known
        if (featlist.contains(feat.Index())) {
            if (extra)
				System.out.println("Character already has feat: " + feat.Feat);

			return false;
        }

		// Thirdly, remove all non-global feats not listed in the class file
		if (!feat.AllClassesCanUse && !availclassfeatlist.contains(feat.Index())) {
			if (extra)
				System.out.println("Feat isn't available to this class: " + feat.Feat);

			return false;
		}

        return CheckFeatRequirements(feat);
    }

	private boolean CheckFeatRequirements(Feat feat) {
		// Test that this feat is valid
		if (feat == null)
			return false;

		boolean extra = false;

		// Next we check to see if we satisfy the one _or_ the other requirements
        LinkedList altreq = new LinkedList();
		if (feat.OrReqFeat0 > -1)
            altreq.add(new Integer(feat.OrReqFeat0));
		if (feat.OrReqFeat1 > -1)
            altreq.add(new Integer(feat.OrReqFeat1));
		if (feat.OrReqFeat2 > -1)
            altreq.add(new Integer(feat.OrReqFeat2));
		if (feat.OrReqFeat3 > -1)
            altreq.add(new Integer(feat.OrReqFeat3));
		if (feat.OrReqFeat4 > -1)
            altreq.add(new Integer(feat.OrReqFeat4));
        if (altreq.size() > 0) {
			boolean found = false;
            for (int ii = 0; ii < altreq.size(); ++ii)
                if (featlist.contains(altreq.get(ii))) {
					found = true;
					break;
				}

            if (!found) {
                if (extra)
					System.out.println("Feat feat requirements aren't satisfied: " + feat.Feat);

                return false;
            }
        }

		// Verify any required skills
		if (feat.ReqSkill > -1) {
			// If this char doesn't have access to the skill
			if (calcSkill(feat.ReqSkill) < feat.ReqSkillMinRanks) {
				if (extra)
					System.out.println("Feat skill requirements aren't satisfied: " + feat.Feat);

				return false;
			}
		}
		// Verify any required skills
		if (feat.ReqSkill2 > -1) {
			// If this char doesn't have access to the skill
			if (calcSkill(feat.ReqSkill2) < feat.ReqSkillMinRanks2) {
				if (extra)
					System.out.println("Feat skill requirements aren't satisfied: " + feat.Feat);

				return false;
			}
		}

		// Determine if the Mandatory Feat Prerequisites are satisfied
		if (feat.PreReqFeat1 > -1 && !featlist.contains(new Integer(feat.PreReqFeat1))) {
			if (extra)
				System.out.println("Feat feat requirements weren't satisfied: " + feat.Feat);

			return false;
		}
		if (feat.PreReqFeat2 > -1 && !featlist.contains(new Integer(feat.PreReqFeat2))) {
			if (extra)
				System.out.println("Feat feat requirements weren't satisfied: " + feat.Feat);

			return false;
		}
        
		// This is ugly, but I don't feel like trying to make this prettier.  I already wanna nix it.
        int realstr = new Integer(((String)menucreate.MainCharData[5].get(new Integer(0)))).intValue();
        int realdex = new Integer(((String)menucreate.MainCharData[5].get(new Integer(1)))).intValue();
        int realcon = new Integer(((String)menucreate.MainCharData[5].get(new Integer(2)))).intValue();
        int realint = new Integer(((String)menucreate.MainCharData[5].get(new Integer(3)))).intValue();
        int realwis = new Integer(((String)menucreate.MainCharData[5].get(new Integer(4)))).intValue();
        int realcha = new Integer(((String)menucreate.MainCharData[5].get(new Integer(5)))).intValue();

		// Check Str Requirements
		if (realstr < feat.MinStr) {
			if (extra)
				System.out.println("Feat STR requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check Dex Requirements
		if (realdex < feat.MinDex) {
			if (extra)
				System.out.println("Feat DEX requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check Con Requirements
		if (realcon < feat.MinCon) {
			if (extra)
				System.out.println("Feat CON requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check Int Requirements
		if (realint < feat.MinInt) {
			if (extra)
				System.out.println("Feat INT requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check Wis Requirements
		if (realwis < feat.MinWis) {
			if (extra)
				System.out.println("Feat WIS requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check Cha Requirements
		if (realcha < feat.MinCha) {
			if (extra)
				System.out.println("Feat CHA requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check for attack bonus
		int attackBonus = (attackmap == null || attackmap[0][1] == null)
				? 0 : Integer.parseInt(attackmap[0][1]);
		if (attackBonus < feat.MinAttackBonus) {
			if (extra)
				System.out.println("Feat Attack Bonus requirements weren't satisfied: " + feat.Feat);

			return false;
		}

		// Check for Fortitude save
        //If it requires a base fortitude save, you can't start with it, all of them are too high
        //Yes, this is a workaround - otherwise, we'd need to query the saves, and that's extra time
        if (feat.MinFortSave > 0) {
            if (extra)
				System.out.println("Feat Fortitude Save requirements weren't satisfied: " + feat.Feat);

            return false;
        }

		// Check for Epic requirement.  1st level chars aren't epic
        if (feat.PreReqEpic) {
            if (extra)
				System.out.println("Feat requires Epic Stature: " + feat.Feat);

            return false;
        }

        //If you're not a spell user, or you don't have the right spell level, then no
        if (feat.MinSpellLvl > -1) {
            if (Integer.parseInt(menucreate.MainCharDataAux[3][classes.SpellCaster]) == 0) {
                if (extra)
					System.out.println("Feat requires spell caster: " + feat.Feat);

                return false;
            }
            if (feat.MinSpellLvl > 1) {
                if (extra)
					System.out.println("Feat requires higher spell level: " + feat.Feat);

                return false;
            }
			int spells = 0;
			if (feat.MinSpellLvl == 1) {
				// Read the given line of the spell progression table
				if (spellgain2damap != null && spellgain2damap[0][4] != null) {
					spells = Integer.parseInt(spellgain2damap[0][4]);
					if (spells == 0) {
						if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("WIS") && realwis >= 12)
							++spells;
						else if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("INT") && realint >= 12)
							++spells;
						else if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("CHA") && realcha >= 12)
							++spells;
					}
				}
			}
			else if (feat.MinSpellLvl == 0) {
				// Read the given line of the spell progression table
				if (spellgain2damap != null && spellgain2damap[0][3] != null)
					spells = Integer.parseInt(spellgain2damap[0][3]);
			}

			if (spells == 0) {
                if (extra)
					System.out.println("Feat requires spell casting abilities: " + feat.Feat);

                return false;
			}
        }

        return true;
	}
    
    public int GetFirstFavored() {
        //This assumes the person is a ranger; if there is no favored enemy found, returns 0
        if (featmap == null || featpref2damap == null)
            return 0;

        int q = 0;
        int r = 0;
        int z = 0;
        try {
            for(z=0;z<featpref2damap.length;z++) {
                q = Integer.parseInt(featpref2damap[z][1]);
				if (featmap[q].MasterFeat == 5)
					return q;
            }
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - line " + z + ".\nCheck Ranger Package Feats.\nError returned: " + err, "Error", 0);
            System.exit(0);
        }
        catch(IndexOutOfBoundsException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - line " + z + ".\nCheck Ranger Package Feats.\nError returned: " + err, "Error", 0);
            System.exit(0);
        }

        return 0;
    }
}

