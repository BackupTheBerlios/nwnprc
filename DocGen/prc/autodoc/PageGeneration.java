package prc.autodoc;

import java.io.*;
import java.util.*;
//import java.util.regex.*;

/* Static import in order to let me use the enum constants in switches */
import static prc.autodoc.Main.SpellType.*;

import static prc.Main.*;
import static prc.autodoc.Main.*;

/**
 * This class contains the methods for manual page generation.
 *
 * @author Ornedan
 */
public final class PageGeneration{
	private PageGeneration(){/* No need for instantiation */}

	/**
	 * Handles creation of the skill pages.
	 */
	public static void doSkills(){
		String skillPath = contentPath + "skills" + fileSeparator;
		String name      = null,
		       text      = null,
		       path      = null;
		boolean errored;

		skills = new HashMap<Integer, GenericEntry>();
		Data_2da skills2da = twoDA.get("skills");

		for(int i = 0; i < skills2da.getEntryCount(); i++){
			errored = false;
			try{
				// Get the name of the skill and check if it's valid
				name = tlk.get(skills2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for skill " + i);
					errored = true;
				}

				// Start building the entry data. First, place in the name
				text = skillTemplate;
				text = text.replaceAll("~~~SkillName~~~",
				                         name);
				// Then, put in the description
				text = text.replaceAll("~~~SkillTLKDescription~~~",
				                       htmlizeTLK(tlk.get(skills2da.getEntry("Description", i))));
				// Again, check if we had a valid description
				if(tlk.get(skills2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for skill " + i + ": " + name);
					errored = true;
				}
				// Add in the icon
				String icon = skills2da.getEntry("Icon", i);
				if(icon.equals("****")){
					err_pr.println("Icon not defined for skill " + i + ": " + name);
					errored = true;
				}
				text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));

				// Build the final path
				path = skillPath + i + ".html";

				// Check if we had any errors. If we did, and the error tolerance flag isn't up, skip printing this page
				if(!errored || tolErr){
					printPage(path, text);
					// Store a data structure represeting the skill into a hashmap
					skills.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for skill " + i + ": " + name + ":\n" + e);
			}
		}
		// Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
		// hits the memory limit
		System.gc();
	}
	
	

	/**
	 * Prints normal & epic spells and psionic powers.
	 * As of now, all of these are similar enough to share the same
	 * template, so they can be done here together.
	 *
	 * The enumeration class used here is found at the end of the file
	 */
	public static void doSpells(){
		String spellPath = contentPath + "spells" + fileSeparator,
		       epicPath  = contentPath + "epic_spells" + fileSeparator,
		       psiPath   = contentPath + "psionic_powers" + fileSeparator;

		String path = null,
		       name = null,
		       text = null,
		       icon = null,
		       subradName = null,
		       subradIcon = null;
		StringBuffer subradialText = null;
		boolean errored;
		int subRadial;

		SpellType spelltype = NONE;

		spells = new HashMap<Integer, SpellEntry>();
		Data_2da spells2da = twoDA.get("spells");

		for(int i = 0; i < spells2da.getEntryCount(); i++){
			spelltype = NONE;
			errored = false;
			try{
				if(isNormalSpell(spells2da, i))       spelltype = NORMAL;
				else if(isEpicSpell(spells2da, i))    spelltype = EPIC;
				else if(isPsionicPower(spells2da, i)) spelltype = PSIONIC;

				if(spelltype != NONE){
					name = tlk.get(spells2da.getEntry("Name", i))
					          .replaceAll("/", " / ");
					if(verbose) System.out.println("Printing page for " + name);
					// Check the name for validity
					if(name.equals(badStrRef)){
						err_pr.println("Invalid name entry for spell " + i);
						errored = true;
					}

					// Start building the entry data. First, place in the name
					text = spellTemplate;
					text = text.replaceAll("~~~SpellName~~~", name);
					// Then, put in the description
					text = text.replaceAll("~~~SpellTLKDescription~~~",
					                       htmlizeTLK(tlk.get(spells2da.getEntry("SpellDesc", i))));
					// Check the description validity
					if(tlk.get(spells2da.getEntry("SpellDesc", i)).equals(badStrRef)){
						err_pr.println("Invalid description for spell " + i + ": " + name);
						errored = true;
					}
					// Add in the icon
					icon = spells2da.getEntry("IconResRef", i);
					if(icon.equals("****")){
						err_pr.println("Icon not defined for spell " + i + ": " + name);
						errored = true;
					}
					text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));
					
					// Handle subradials, if any
					subradialText = new StringBuffer();
					// Assume that if there are any, the first slot is always non-****
					if(!spells2da.getEntry("SubRadSpell1", i).equals("****")){
						for(int j = 1; j <= 5; j++) {
							try {
								subRadial = Integer.parseInt(spells2da.getEntry("SubRadSpell" + j, i));
								
								// Try name
								subradName = tlk.get(spells2da.getEntry("Name", subRadial))
								                .replaceAll("/", " / ");
								// Check the name for validity
								if(subradName.equals(badStrRef)){
									err_pr.println("Invalid name entry for spell " + subRadial);
									errored = true;
								}
								
								// Try icon
								subradIcon = spells2da.getEntry("IconResRef", subRadial);
								if(subradIcon.equals("****")){
									err_pr.println("Icon not defined for spell " + subRadial + ": " + subradName);
									errored = true;
								}
								
								// Build list
								subradialText.append(spellSubradialListEntryTemplate.replaceAll("~~~Icon~~~", Icons.buildIcon(subradIcon))
								                                                    .replaceAll("~~~SubradialName~~~", subradName));
							} catch(NumberFormatException e) {
								err_pr.println("Invalid SubRadSpell" + j + " for spell " + i + ": " + name);
								errored = true;
							}
						}
						
						subradialText = new StringBuffer(spellSubradialListTemplate.replaceAll("~~~EntryList~~~", subradialText.toString()));
					}
					text = text.replaceAll("~~~SubradialNames~~~", subradialText.toString());

					// Build the path
					switch(spelltype){
						case NORMAL:
							path = spellPath + i + ".html";
							break;
						case EPIC:
							path = epicPath + i + ".html";
							break;
						case PSIONIC:
							path = psiPath + i + ".html";
							break;

						default:
							throw new AssertionError("Unhandled spelltype: " + spelltype);
					}

					// Check if we had any errors. If we did, and the error tolerance flag isn't up, skip printing this page
					if(!errored || tolErr){
						// Print the page
						printPage(path, text);
						// Store a data structure represeting the entry into a hashmap
						spells.put(i, new SpellEntry(name, /*text, */path, i, spelltype));
					}else
						throw new PageGenerationException("Error(s) encountered while creating page");
				}
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for spell " + i + ": " + name + ":\n" + e);
			}
		}
		// Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
		// hits the memory limit
		System.gc();
	}

	/**
	 * Creates a list of spells.2da rows that should contain a psionic power's class-specific
	 * entry.
	 */
	public static void listPsionicPowers(){
		// A map of power name to class-specific spells.2da entry
		HashMap<String, Integer> psiPowMap = new HashMap<String, Integer>();
		
		// Load cls_psipw_*.2da
		String[] fileNames = new File("2da").list(new FilenameFilter(){
			public boolean accept(File dir, String name){
				return name.toLowerCase().startsWith("cls_psipw_") &&
				       name.toLowerCase().endsWith(".2da");
			}
		});
		
		Data_2da[] cls_psipw_2das = new Data_2da[fileNames.length];
		for(int i = 0; i < fileNames.length; i++)
			//Strip out the ".2da" from the filenames before loading, since the loader function assumes it's missing
			cls_psipw_2das[i] = twoDA.get(fileNames[i].replace(".2da", ""));
		
		// Parse the 2das
		for(Data_2da cls_psipw : cls_psipw_2das){
			for(int i = 0; i < cls_psipw.getEntryCount(); i++){
				// Column FeatID is used to determine if the row specifies the main entry of a power
				if(!cls_psipw.getEntry("FeatID", i).equals("****")) {
					try {
						psiPowMap.put(tlk.get(cls_psipw.getEntry("Name", i)), Integer.parseInt(cls_psipw.getEntry("SpellID", i)));
					} catch(NumberFormatException e) {
						err_pr.println("Invalid SpellID entry in " + cls_psipw.getName() + ", line " + i);
					}
				}
			}
		}

		psiPowIDs = new HashSet<Integer>(psiPowMap.values());
	}

	/**
	 * A small convenience method for wrapping all the normal spell checks into
	 * one.
	 *
	 * @param spells2da the Data_2da entry containing spells.2da
	 * @param entryNum  the line number to use for testing
	 *
	 * @return <code>true</code> if any of the class spell level columns contain a number,
	 *           <code>false</code> otherwise
	 */
	private static boolean isNormalSpell(Data_2da spells2da, int entryNum){
		if(!spells2da.getEntry("Bard", entryNum).equals("****"))     return true;
		if(!spells2da.getEntry("Cleric", entryNum).equals("****"))   return true;
		if(!spells2da.getEntry("Druid", entryNum).equals("****"))    return true;
		if(!spells2da.getEntry("Paladin", entryNum).equals("****"))  return true;
		if(!spells2da.getEntry("Ranger", entryNum).equals("****"))   return true;
		if(!spells2da.getEntry("Wiz_Sorc", entryNum).equals("****")) return true;

		return false;
	}


	/**
	 * A small convenience method for testing if the given entry contains a
	 * epic spell.
	 *
	 * @param spells2da the Data_2da entry containing spells.2da
	 * @param entryNum  the line number to use for testing
	 *
	 * @return <code>true</code> if the impactscript name starts with strings specified in settings,
	 *           <code>false</code> otherwise
	 */
	private static boolean isEpicSpell(Data_2da spells2da, int entryNum){
		for(String check : settings.epicspellSignatures)
			if(spells2da.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
		return false;
	}

	/**
	 * A small convenience method for testing if the given entry contains a
	 * psionic power. This is determined by whether the power's id is
	 * in the psiPowIDs Set. 
	 *
	 * @param spells2da the Data_2da entry containing spells.2da
	 * @param entryNum  the line number to use for testing
	 *
	 * @return <code>true</code> if the impactscript name starts with strings specified in settings,
	 *           <code>false</code> otherwise
	 */
	private static boolean isPsionicPower(Data_2da spells2da, int entryNum){
		/*
		// First, check if the power is a radial master.
		String subRad = spells2da.getEntry("SubRadSpell1", entryNum);
		
		if(!subRad.equals("****")){
			try{
				// Check if the subradialspell is a psionic power
				subRad = spells2da.getEntry("ImpactScript", Integer.parseInt(subRad));
				for(String check : settings.psionicpowerSignatures)
					if(subRad.startsWith(check)) return true;
			}catch(NumberFormatException e){
				throw new PageGenerationException("Invalid SubRadSpell1 entry:\n" + e);
		}}
		// Skip any spells with a Master entry
		if(!spells2da.getEntry("Master", entryNum).equals("****")) return false;
		
		// Check if the power's impactscript has the correct prefix
		for(String check : settings.psionicpowerSignatures)
			if(spells2da.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
		return false;
		*/
		return psiPowIDs.contains(entryNum);
	}


	/**
	 * Build the preliminary list of master feats, without the child feats
	 * linked in.
	 */
	public static void preliMasterFeats(){
		String mFeatPath = contentPath + "master_feats" + fileSeparator;
		String name     = null,
		       text     = null;
		FeatEntry entry = null;
		boolean errored;

		masterFeats = new HashMap<Integer, FeatEntry>();
		Data_2da masterFeats2da = twoDA.get("masterfeats");

		for(int i = 0; i < masterFeats2da.getEntryCount(); i++){
			// Skip blank rows
			if(masterFeats2da.getEntry("LABEL", i).equals("****")) continue;
			errored = false;

			try{
				name = tlk.get(masterFeats2da.getEntry("STRREF", i));
				if(verbose) System.out.println("Generating preliminary data for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for masterfeat " + i);
					errored = true;
				}

				// Build the entry data
				text = mFeatTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i))));
				// Check the description validity
				if(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)){
					err_pr.println("Invalid description for masterfeat " + i + ": " + name);
					errored = true;
				}
				// Add in the icon
				String icon = masterFeats2da.getEntry("ICON", i);
				if(icon.equals("****")){
					err_pr.println("Icon not defined for masterfeat " + i + ": " + name);
					errored = true;
				}
				text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));

				if(!errored || tolErr){
					// Store the entry to wait for further processing
					// Masterfeats start as class feats and are converted into general feats if any child
					// is a general feat
					entry = new FeatEntry(name , text, mFeatPath + i + ".html", i, false, true);
					masterFeats.put(i, entry);
				}else
					throw new PageGenerationException("Error(s) encountered while creating entry data");
			}catch(PageGenerationException e){
				err_pr.println("Failed to generate page data for masterfeat " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}


	/**
	 * Build the preliminary list of feats, without master / successor / predecessor feats
	 * linked in.
	 */
	public static void preliFeats(){
		String featPath      = contentPath + "feats" + fileSeparator,
		       epicPath      = contentPath + "epic_feats" + fileSeparator,
		       classFeatPath = contentPath + "class_feats" + fileSeparator,
		       classEpicPath = contentPath + "class_epic_feats" + fileSeparator;
		String name     = null,
		       text     = null,
		       path     = null;
		FeatEntry entry = null;
		boolean isEpic      = false,
		        isClassFeat = false;
		boolean errored;

		feats = new HashMap<Integer, FeatEntry>();
		Data_2da feats2da = twoDA.get("feat");

		for(int i = 0; i < feats2da.getEntryCount(); i++){
			// Skip blank rows and markers
			if(feats2da.getEntry("LABEL", i).equals("****") ||
			   feats2da.getEntry("FEAT", i).equals("****"))
				continue;
			// Skip the ISC & Epic spell markers
			if(feats2da.getEntry("LABEL", i).equals("ReservedForISCAndESS")) continue;
			errored = false;

			try{
				name = tlk.get(feats2da.getEntry("FEAT", i));
				if(verbose) System.out.println("Generating preliminary data for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for feat " + i);
					errored = true;
				}

				// Build the entry data
				text = featTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(feats2da.getEntry("DESCRIPTION", i))));
				// Check the description validity
				if(tlk.get(feats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)){
					err_pr.println("Invalid description for feat " + i + ": " + name);
					errored = true;
				}
				// Add in the icon
				String icon = feats2da.getEntry("ICON", i);
				if(icon.equals("****")){
					err_pr.println("Icon not defined for feat " + i + ": " + name);
					errored = true;
				}
				text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));


				isEpic = feats2da.getEntry("PreReqEpic", i).equals("1");
				isClassFeat = !feats2da.getEntry("ALLCLASSESCANUSE", i).equals("1");

				// Get the path
				if(isEpic){
					if(isClassFeat) path = classEpicPath + i + ".html";
					else            path = epicPath + i + ".html";
				}else{
					if(isClassFeat) path = classFeatPath + i + ".html";
					else            path = featPath + i + ".html";
				}

				if(!errored || tolErr){
					// Create the entry data structure
					entry = new FeatEntry(name , text, path, i, isEpic, isClassFeat);
					// Store the entry to wait for further processing
					feats.put(i, entry);
				}else
					throw new PageGenerationException("Error(s) encountered while creating entry data");
			}catch(PageGenerationException e){
				err_pr.println("Failed to generate page data for feat " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}


	/**
	 * Builds the master - child, predecessor - successor and prerequisite links
	 * and modifies the entry texts accordingly.
	 */
	public static void linkFeats(){
		FeatEntry other = null;
		String temp = null;
		Data_2da feats2da = twoDA.get("feat");
		boolean allChildrenEpic, allChildrenClassFeat;

		//path.replace(contentPath, "../");

		// Link normal feats to each other and to masterfeats
		for(FeatEntry check : feats.values()){
			if(verbose) System.out.println("Linking feat " + check.name);
			// Link to master
			if(!feats2da.getEntry("MASTERFEAT", check.entryNum).equals("****")){
				try{
					other = masterFeats.get(Integer.parseInt(feats2da.getEntry("MASTERFEAT", check.entryNum)));
					check.master = other;
					other.childFeats.put(check.name, check);
					if(check.isEpic) other.isEpic = true;
					if(!check.isClassFeat) other.isClassFeat = false;
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid MASTERFEAT entry");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " MASTERFEAT points to a nonexistent masterfeat entry");
			}}

			// Print prerequisites into the entry
			temp = buildPrerequisites(check, feats2da);
			check.text = check.text.replaceAll("~~~PrerequisiteFeatList~~~", temp);

			// Print the successor, if any, into the entry
			temp = "";
			if(!feats2da.getEntry("SUCCESSOR", check.entryNum).equals("****")){
				try{
					other = feats.get(Integer.parseInt(feats2da.getEntry("SUCCESSOR", check.entryNum)));
					// Check for feats that have themselves as successor
					if(other == check)
						err_pr.println("Feat " + check.entryNum + ": " + check.name + " has itself as successor");
					other.isSuccessor = true;
					temp += successorFeatHeaderTemplate + pageLinkTemplate.replace("~~~Path~~~", other.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
					                                                      .replace("~~~Name~~~", other.name);
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid SUCCESSOR entry");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " SUCCESSOR points to a nonexistent feat entry");
			}}
			check.text = check.text.replaceAll("~~~SuccessorFeat~~~", temp);
		}
		// Another loop over all feats, this time to write the prereq data in
		if(verbose) System.out.println("Linking feats to those they are prerequisites of");
		for(FeatEntry check : feats.values()){
			// Copy the map from FeatEntry. It's contents might have use later on, but iterating will
			// wipe the map
			boolean headerDone = false;
			temp = "";
			for(FeatEntry req : check.requiredForFeats.values()){
				if(!headerDone){ temp += requiredForFeatHeaderTemplate; headerDone = true; }
				temp += pageLinkTemplate.replace("~~~Path~~~", req.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                        .replace("~~~Name~~~", req.name);
			}

			check.text = check.text.replaceAll("~~~RequiredForFeatList~~~", temp);
		}

		// Add the child links to masterfeat texts
		for(FeatEntry check : masterFeats.values()){
			if(verbose) System.out.println("Linking masterfeat " + check.name);
			temp = "";
			allChildrenEpic = allChildrenClassFeat = true;
			for(FeatEntry child : check.childFeats.values()){
				if(!child.isEpic) allChildrenEpic = false; 
				if(!child.isClassFeat) allChildrenClassFeat = false;
				temp += pageLinkTemplate.replace("~~~Path~~~", child.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
	                                    .replace("~~~Name~~~", child.name);
			}

			check.text = check.text.replaceAll("~~~MasterFeatChildList~~~", temp);
			check.allChildrenClassFeat = allChildrenClassFeat;
			check.allChildrenEpic = allChildrenEpic;
		}
		System.gc();
	}

	/**
	 * Constructs a text containing links to the prerequisite feats of the
	 * given feat. Separated from the linkFeats method for improved
	 * readability.
	 * Also links the feat to it's prerequisites.
	 *
	 * @param check    the feat entry to be examined
	 * @param feats2da the data structure representing feat.2da
	 *
	 * @return string containing html links to such prerequisite feats that
	 *                  have FeatEntry data structures build for them
	 */
	private static String buildPrerequisites(FeatEntry check, Data_2da feats2da){
		FeatEntry andReq1 = null, andReq2 = null, orReq = null;
		String andReq1Num = feats2da.getEntry("PREREQFEAT1", check.entryNum),
		       andReq2Num = feats2da.getEntry("PREREQFEAT2", check.entryNum);
		String[] orReqs = {feats2da.getEntry("OrReqFeat0", check.entryNum),
		                   feats2da.getEntry("OrReqFeat1", check.entryNum),
		                   feats2da.getEntry("OrReqFeat2", check.entryNum),
		                   feats2da.getEntry("OrReqFeat3", check.entryNum),
		                   feats2da.getEntry("OrReqFeat4", check.entryNum)};
		String preReqText = "";

		/* Handle AND prerequisite feats */
		// Some paranoia about bad entries
		if(!andReq1Num.equals("****")){
			try{
				andReq1 = feats.get(Integer.parseInt(andReq1Num));
				if(andReq1 == null) err_pr.println("Feat " + check.entryNum + ": " + check.name + " PREREQFEAT1 points to a nonexistent feat entry");
				else if(andReq1 == check) err_pr.println("Feat " + check.entryNum + ": " + check.name + " has itself as PREREQFEAT1");
			}catch(NumberFormatException e){
				err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid PREREQFEAT1 entry");
		}}
		if(!andReq2Num.equals("****")){
			try{
				andReq2 = feats.get(Integer.parseInt(andReq2Num));
				if(andReq2 == null) err_pr.println("Feat " + check.entryNum + ": " + check.name + " PREREQFEAT2 points to a nonexistent feat entry");
				else if(andReq2 == check) err_pr.println("Feat " + check.entryNum + ": " + check.name + " has itself as PREREQFEAT2");
			}
			catch(NumberFormatException e){
				err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid PREREQFEAT2 entry");
		}}
		// Check if we had at least one valid entry
		if(andReq1 != null || andReq2 != null){
			preReqText = prereqANDFeatHeaderTemplate;
			if(andReq1 != null){
				preReqText += pageLinkTemplate.replace("~~~Path~~~", andReq1.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                              .replace("~~~Name~~~", andReq1.name);
				andReq1.requiredForFeats.put(check.name, check);
			}
			if(andReq2 != null){
				preReqText += pageLinkTemplate.replace("~~~Path~~~", andReq2.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                              .replace("~~~Name~~~", andReq2.name);
				andReq2.requiredForFeats.put(check.name, check);
			}
		}


		/* Handle OR prerequisite feats */
		// First, check if there are any
		boolean printOrReqs = false;
		for(String orReqCheck : orReqs)
			if(!orReqCheck.equals("****")) printOrReqs = true;

		if(printOrReqs){
			boolean headerDone = false;
			// Loop through each req and see if it's a valid link
			for(int i = 0; i < orReqs.length; i++){
				if(!orReqs[i].equals("****")){
					try{ orReq = feats.get(Integer.parseInt(orReqs[i])); }
					catch(NumberFormatException e){
						err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid OrReqFeat" + i + " entry");
					}
					if(orReq != null){
						if(orReq == check) err_pr.println("Feat " + check.entryNum + ": " + check.name + " has itself as OrReqFeat" + i);
						if(!headerDone){
							preReqText = prereqORFeatHeaderTemplate;
							headerDone = true;
						}
						preReqText += pageLinkTemplate.replace("~~~Path~~~", orReq.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                                      .replace("~~~Name~~~", orReq.name);
						orReq.requiredForFeats.put(check.name, check);
					}
					else
						err_pr.println("Feat " + check.entryNum + ": " + check.name + " OrReqFeat" + i + " points to a nonexistent feat entry");
				}
			}
			// End the <div> if we printed anything
		}

		return preReqText;
	}


	/**
	 * A simple method for printing out all the feat pages
	 */
	public static void printFeats(){
		// Print feats
		for(FeatEntry toPrint : feats.values()){
			if(verbose) System.out.println("Printing page for " + toPrint.name);
			try{
				printPage(toPrint.filePath, toPrint.text);
			}catch(PageGenerationException e){
				err_pr.println("Exception when writing page for feat " + toPrint.entryNum + ": " + toPrint.name + ":\n" + e);
		}}
		System.gc();
		// Print masterfeats
		for(FeatEntry toPrint : masterFeats.values()){
			if(verbose) System.out.println("Printing page for " + toPrint.name);
			try{
				printPage(toPrint.filePath, toPrint.text);
			}catch(PageGenerationException e){
				err_pr.println("Exception when writing page for masterfeat " + toPrint.entryNum + ": " + toPrint.name + ":\n" + e);
		}}
		System.gc();

		// Print a page with alphabetically sorted list of all feats
		printPage(contentPath + "feats" + fileSeparator + "alphasortedfeats.html", buildAllFeatsList(false));
		
		// Print a page with alphabetically sorted list of all epic feats
		printPage(contentPath + "epic_feats" + fileSeparator + "alphasortedepicfeats.html", buildAllFeatsList(true));
	}

	/**
	 * Constructs an alphabetically sorted list of all (or only all epic) feats.
	 *
	 * @param epicOnly if <code>true</code>, only feats that are epic are placed in the list. Otherwise, all feats.
	 * @return an html page containing the list
	 */
	private static String buildAllFeatsList(boolean epicOnly){
		TreeMap<String, FeatEntry> sorted = new TreeMap<String, FeatEntry>(String.CASE_INSENSITIVE_ORDER);
		for(FeatEntry entry : feats.values())
			if(!epicOnly || (epicOnly && entry.isEpic))
				sorted.put(entry.name, entry);
		String toReturn = alphaSortedListTemplate,
		       entrySet;
		FeatEntry entry;
		char cha = (char)0;
		int counter = 0;
		boolean addedAny;
		while(sorted.size() > 0){
			// Build the list for a single letter
			entrySet = listEntrySetTemplate.replace("~~~LinkId~~~", new String(new char[]{cha}))
			                               .replace("~~~EntrySetName~~~", new String(new char[]{cha}).toUpperCase());
			addedAny = false;
			while(sorted.size() > 0 &&
			      sorted.firstKey().toLowerCase().startsWith(new String(new char[]{cha}))){
				addedAny = true;
				entry = sorted.remove(sorted.firstKey());

				entrySet = entrySet.replace("~~~FeatList~~~", listEntryTemplate.replace("~~~EvenOrOdd~~~", (counter++ % 2) == 0 ? "even":"odd")
						                                                       .replace("~~~EntryPath~~~",
						                                                                entry.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
						                                                       .replace("~~~EntryName~~~", entry.name)
						                                      + "~~~FeatList~~~");
			}
			entrySet = entrySet.replace("~~~FeatList~~~", "");
			cha++;

			// Add the sublist to the page
			if(addedAny)
				toReturn = toReturn.replace("~~~Content~~~", entrySet + "\n" + "~~~Content~~~");
		}
		// Clear off the last replacement marker
		toReturn = toReturn.replace("~~~Content~~~", "");

		return toReturn;
	}


	/**
	 * Handles creation of the domain pages.
	 * Kills page generation on bad strref for name.
	 * Other errors are logged and prevent page write
	 */
	public static void doDomains(){
		String domainPath = contentPath + "domains" + fileSeparator;
		String name      = null,
		       text      = null,
		       path      = null;
		StringBuffer spellList  = null;
		FeatEntry grantedFeat   = null;
		SpellEntry grantedSpell = null;
		boolean errored;

		domains = new HashMap<Integer, GenericEntry>();
		Data_2da domains2da = twoDA.get("domains");

		for(int i = 0; i < domains2da.getEntryCount(); i++){
			// Skip blank rows
			if(domains2da.getEntry("LABEL", i).equals("****")) continue;
			errored = false;
			try{
				name = tlk.get(domains2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for domain " + i);
					errored = true;
				}

				// Build the entry data
				text = domainTemplate;
				text = text.replaceAll("~~~DomainName~~~",
				                         name);
				text = text.replaceAll("~~~DomainTLKDescription~~~",
				                        htmlizeTLK(tlk.get(domains2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(domains2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for domain " + i + ": " + name);
					errored = true;
				}
				// Add in the icon
				String icon = domains2da.getEntry("Icon", i);
				if(icon.equals("****")){
					err_pr.println("Icon not defined for domain " + i + ": " + name);
					errored = true;
				}
				text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));

				// Add a link to the granted feat
				try{
					grantedFeat = feats.get(Integer.parseInt(domains2da.getEntry("GrantedFeat", i)));
					text = text.replaceAll("~~~DomainFeat~~~",
							               pageLinkTemplate.replace("~~~Path~~~", grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                                           .replace("~~~Name~~~", grantedFeat.name));
				}catch(NumberFormatException e){
					err_pr.println("Invalid entry in GrantedFeat of domain " + i + ": " + name);
					errored = true;
				}catch(NullPointerException e){
					err_pr.println("GrantedFeat entry for domain " + i + ": " + name + " points to non-existent feat: " + domains2da.getEntry("GrantedFeat", i));
					errored = true;
				}

				// Add links to the granted spells
				spellList = new StringBuffer();
				for(int j = 1; j <= 9; j++){
					// Skip blanks
					if(domains2da.getEntry("Level_" + j, i).equals("****")) continue;
					try{
						grantedSpell = spells.get(Integer.parseInt(domains2da.getEntry("Level_" + j, i)));
						spellList.append(pageLinkTemplate.replace("~~~Path~~~", grantedSpell.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                                         .replace("~~~Name~~~", grantedSpell.name));
					}catch(NumberFormatException e){
						err_pr.println("Invalid entry in Level_" + j + " of domain " + i + ": " + name);
						errored = true;
					}catch(NullPointerException e){
						err_pr.println("Level_" + j + " entry for domain " + i + ": " + name + " points to non-existent spell: " + domains2da.getEntry("Level_" + j, i));
						errored = true;
					}
				}
				text = text.replaceAll("~~~DomainSpellList~~~", spellList.toString());

				// Build path and print
				path = domainPath + i + ".html";
				if(!errored || tolErr){
					printPage(path, text);
					domains.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for domain " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}


	/**
	 * Handles creation of the race pages.
	 */
	public static void doRaces(){
		String racePath = contentPath + "races" + fileSeparator;
		String name     = null,
		       text     = null,
		       path     = null;
		StringBuffer featList = null;
		FeatEntry grantedFeat = null;
		Data_2da featTable    = null;
		boolean errored;

		races = new HashMap<Integer, GenericEntry>();
		Data_2da racialtypes2da = twoDA.get("racialtypes");

		for(int i = 0; i < racialtypes2da.getEntryCount(); i++){
			// Skip non-player races
			if(!racialtypes2da.getEntry("PlayerRace", i).equals("1")) continue;
			errored = false;
			try{
				name = tlk.get(racialtypes2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for race " + i);
					errored = true;
				}

				// Build the entry data
				text = raceTemplate;
				text = text.replaceAll("~~~RaceName~~~",
				                       name);
				text = text.replaceAll("~~~RaceTLKDescription~~~",
				                        htmlizeTLK(tlk.get(racialtypes2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(racialtypes2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for race " + i + ": " + name);
					errored = true;
				}


				// Add links to the racial feats
				try{
			        featTable = twoDA.get(racialtypes2da.getEntry("FeatsTable", i));
		        }catch(TwoDAReadException e){
					throw new PageGenerationException("Failed to read RACE_FEAT_*.2da for race " + i + ": " + name + ":\n" + e);
				}

				featList = new StringBuffer();
				for(int j = 0; j < featTable.getEntryCount(); j++){
					try{
						grantedFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", j)));
						featList.append(pageLinkTemplate.replace("~~~Path~~~", grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                                                        .replace("~~~Name~~~", grantedFeat.name));
					}catch(NumberFormatException e){
						err_pr.println("Invalid entry in FeatIndex line " + j + " of " + featTable.getName());
						errored = true;
					}catch(NullPointerException e){
						err_pr.println("FeatIndex line " + j + " of " + featTable.getName() + " points to non-existent feat: " + featTable.getEntry("FeatIndex", j));
						errored = true;
					}
				}
				text = text.replaceAll("~~~RaceFeats~~~", featList.toString());

				// Build path and print
				path = racePath + i + ".html";
				if(!errored || tolErr){
					printPage(path, text);
					races.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for race " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}


	/**
	 * Handles creation of the class pages.
	 * Subsections handled by several following methods.
	 */
	public static void doClasses(){
		String baseClassPath     = contentPath + "base_classes" + fileSeparator,
		       prestigeClassPath = contentPath + "prestige_classes" + fileSeparator;
		String name      = null,
		       text      = null,
		       path      = null,
		       temp      = null;
		String[] tempArr = null;

		boolean errored;

		classes = new HashMap<Integer, ClassEntry>();
		Data_2da classes2da = twoDA.get("classes");

		for(int i = 0; i < classes2da.getEntryCount(); i++){
			// Skip non-player classes
			if(!classes2da.getEntry("PlayerClass", i).equals("1")) continue;
			errored = false;
			try{
				name = tlk.get(classes2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for class " + i);
					errored = true;
				}

				// Build the entry data
				text = classTemplate;
				text = text.replaceAll("~~~ClassName~~~",
				                       name);
				text = text.replaceAll("~~~ClassTLKDescription~~~",
				                        htmlizeTLK(tlk.get(classes2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(classes2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for class " + i + ": " + name);
					errored = true;
				}
				// Add in the icon
				String icon = classes2da.getEntry("Icon", i);
				if(icon.equals("****")){
					err_pr.println("Icon not definedfor class " + i + ": " + name);
					errored = true;
				}
				text = text.replaceAll("~~~Icon~~~", Icons.buildIcon(icon));

				// Add in the BAB and saving throws table
				text = text.replaceAll("~~~ClassBABAndSavThrTable~~~", buildBabAndSaveTable(classes2da, i));

				// Add in the skills table
				text = text.replaceAll("~~~ClassSkillTable~~~", buildSkillTable(classes2da, i));

				// Add in the feat table
				text = text.replaceAll("~~~ClassFeatTable~~~", buildClassFeatTables(classes2da, i));

				/* Check whether this is a base or a prestige class. No prestige
				 * class should give exp penalty (nor should any base class not give it),
				 * so it gan be used as an indicator.
				 */
				temp = classes2da.getEntry("XPPenalty", i);
				if(!(temp.equals("0") || temp.equals("1"))){
					if(tolErr){
						err_pr.println("Invalid List XPPenalty in classes.2da on row " + i + ": " + temp);
						continue;
					}else throw new PageGenerationException("Invalid XPPenalty entry in classes.2da on row " + i + ": " + temp);
				}
				if(temp.equals("1"))
					path = baseClassPath + i + ".html";
				else
					path = prestigeClassPath + i + ".html";

				if(!errored || tolErr){
					printPage(path, text);
					classes.put(i, new ClassEntry(name, path, temp.equals("1"), i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for class " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}


	/**
	 * Constructs the html table of levels and their bab + saving throw bonus values.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  string representation of the table
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String buildBabAndSaveTable(Data_2da classes2da, int entryNum){
		Data_2da babTable  = null,
		         saveTable = null;
		try{
			babTable = twoDA.get(classes2da.getEntry("AttackBonusTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_ATK_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_ATK_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		try{
			saveTable = twoDA.get(classes2da.getEntry("SavingThrowTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_SAVTHR_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_SAVTHR_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}

		String toReturn = "";

		/* Determine maximum level to print bab & save values to
		 * The maximum level of the class, or the last non-epic level
		 * whichever is lower
		 */
		int maxToPrint = 0, maxLevel = 0, epicLevel = 0;
		try{ maxLevel = Integer.parseInt(classes2da.getEntry("MaxLevel", entryNum)); }
		catch(NumberFormatException e){
			if(tolErr) err_pr.println("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
			else throw new PageGenerationException("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		try{ epicLevel = Integer.parseInt(classes2da.getEntry("EpicLevel", entryNum)); }
		catch(NumberFormatException e){
			if(tolErr) err_pr.println("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
			else throw new PageGenerationException("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}

		// base classes have special notation for the epic level limit
		if(epicLevel == -1)
			maxToPrint = 20;
		else
			maxToPrint = maxLevel > epicLevel ? epicLevel : maxLevel;

		// If the class has any pre-epic levels
		if(maxToPrint > 0){
			toReturn += babAndSavthrTableHeaderTemplate + "\n";
			// Start building the table
			for(int i = 0; i < maxToPrint; i++){
				toReturn += "<tr>\n";
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", (i + 1) + "");
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", babTable.getEntry("BAB", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("FortSave", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("RefSave", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("WillSave", i));
				toReturn += "</tr>\n";
			}
			toReturn += "</table>\n";
		}

		return toReturn;
	}

	/**
	 * Constructs the html table of the class & cross-class skills of this class.
	 * TreeMaps are used to arrange the printed skills in alphabetic order.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  string representation of the table
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String buildSkillTable(Data_2da classes2da, int entryNum){
		Data_2da skillTable = null;
		try{
			skillTable = twoDA.get(classes2da.getEntry("SkillsTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_SKILL_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_SKILL_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		String toReturn = skillTableHeaderTemplate;
		String temp = null;
		GenericEntry tempSkill = null;
		TreeMap<String, GenericEntry> classSkills      = new TreeMap<String, GenericEntry>(),
		                              crossClassSkills = new TreeMap<String, GenericEntry>();

		for(int i = 0; i < skillTable.getEntryCount(); i++){
			temp = skillTable.getEntry("ClassSkill", i);
			// Yet more validity checking :P
			if(!(temp.equals("0") || temp.equals("1"))){
				if(tolErr){
					err_pr.println("Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
					continue;
				}else throw new PageGenerationException("Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
			}

			try{
				tempSkill = skills.get(Integer.parseInt(skillTable.getEntry("SkillIndex", i)));
			}catch(NumberFormatException e){
				if(tolErr){
					err_pr.println("Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
					continue;
				}else throw new PageGenerationException("Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
			}
			if(tempSkill == null){
				if(tolErr){
					err_pr.println("SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
					continue;
				}else throw new PageGenerationException("SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
			}

			if(temp.equals("1")) classSkills.put(tempSkill.name, tempSkill);
			else            crossClassSkills.put(tempSkill.name, tempSkill);
		}

		while(classSkills.size() > 0 || crossClassSkills.size() > 0){
			toReturn += "<tr>\n";

			if(classSkills.size() > 0){
				tempSkill = classSkills.remove(classSkills.firstKey());
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
			}else
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");

			if(crossClassSkills.size() > 0){
				tempSkill = crossClassSkills.remove(crossClassSkills.firstKey());
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
			}else
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");

			toReturn += "</tr>\n";
		}

		toReturn += "</table>\n";
		return toReturn;
	}


	/**
	 * Constructs the html table of the bonus and selectable class feats of the given class.
	 * TreeMaps are used to arrange the printed feats in alphabetic order.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  String that contains the tables
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String buildClassFeatTables(Data_2da classes2da, int entryNum){
		Data_2da featTable      = null,
		         bonusFeatTable = null;
		ArrayList<TreeMap<String, FeatEntry>> grantedFeatList    = new ArrayList<TreeMap<String, FeatEntry>>(40),
		                                      selectableFeatList = new ArrayList<TreeMap<String, FeatEntry>>(40);
		HashSet<FeatEntry> masterFeatsUsed = new HashSet<FeatEntry>();
		String listNum = null;
		FeatEntry classFeat = null;
		int maxLevel, epicLevel, grantedLevel;
		
		// Attempt to load the class feats table
		try{
			featTable = twoDA.get(classes2da.getEntry("FeatsTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_FEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_FEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		// Attempt to load the class bonus feat slots table
		try{
			bonusFeatTable = twoDA.get(classes2da.getEntry("BonusFeatsTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_BFEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_BFEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		// Attempt to read the class epic level
		try{
			epicLevel = Integer.parseInt(classes2da.getEntry("EpicLevel", entryNum));
		}catch(NumberFormatException e){
			if(tolErr){
				err_pr.println("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
				return "";
			}
			else throw new PageGenerationException("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		// Attempt to read the class maximum level
		try{
			if(epicLevel == -1)
				maxLevel = 40;
			else
				maxLevel = Integer.parseInt(classes2da.getEntry("MaxLevel", entryNum));
		}catch(NumberFormatException e){
			if(tolErr){
				err_pr.println("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
				return "";
			}
			else throw new PageGenerationException("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		
		// Base classes have EpicLevel defined as -1, but become epic at L20
		if(epicLevel == -1) epicLevel = 20;
		// Sanity check
		else if(epicLevel > maxLevel){
			if(tolErr){
				err_pr.println("EpicLevel value(" + epicLevel + ") greater than MaxLevel value(" + maxLevel + ") for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
				epicLevel = maxLevel;
			}
			else throw new PageGenerationException("EpicLevel value(" + epicLevel + ") greater than MaxLevel value(" + maxLevel + ") for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		
		
		// Init the lists
		for(int i = 0; i < maxLevel; i++) grantedFeatList.add(null);
		for(int i = 0; i < maxLevel; i++) selectableFeatList.add(null);
		
		
		// Build a level-sorted list of feats
		for(int i = 0; i < featTable.getEntryCount(); i++){
			// Skip empty rows and comments
			if(featTable.getEntry("FeatLabel", i).equals("****") ||
			   featTable.getEntry("FeatIndex", i).equals("****"))
				continue;
			
			// Read the list number and validate
			listNum = featTable.getEntry("List", i);
			if(!(listNum.equals("0") || listNum.equals("1") || listNum.equals("2") || listNum.equals("3"))){
				if(tolErr){
					err_pr.println("Invalid List entry in " + featTable.getName() + " on row " + i + ": " + listNum);
					continue;
				}else throw new PageGenerationException("Invalid List entry in " + featTable.getName() + " on row " + i + ": " + listNum);
			}
			
			// Read the level granted on and validate
			try{
				grantedLevel = Integer.parseInt(featTable.getEntry("GrantedOnLevel", i));
			}catch(NumberFormatException e){
				if(tolErr){
					err_pr.println("Invalid GrantedOnLevel entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("GrantedOnLevel", i));
					continue;
				}else throw new PageGenerationException("Invalid GrantedOnLevel entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("GrantedOnLevel", i));
			}
			
			// Complain about a semantic error
			if(listNum.equals("3") && grantedLevel == -1){
				if(tolErr){
					err_pr.println("List value '3' combined with GrantedOnLevel value '-1' in " + featTable.getName() + " on row " + i);
					continue;
				}else throw new PageGenerationException("List value '3' combined with GrantedOnLevel value '-1' in " + featTable.getName() + " on row " + i);
			}
			
			// Get the feat on this row and validate
			try{
				classFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", i)));
			}catch(NumberFormatException e){
				if(tolErr){
					err_pr.println("Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
					continue;
				}else throw new PageGenerationException("Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
			}
			if(classFeat == null){
				if(tolErr){
					err_pr.println("FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
					continue;
				}else throw new PageGenerationException("FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
			}
			
			
			// Skip feats that can never be gotten
			if(grantedLevel > 40) continue;
			
			// If the feat has a master, replace it with the master in the listing to prevent massive spammage
			if(classFeat.master != null){
				// Only add masterfeats to the list once.
				if(masterFeatsUsed.contains(classFeat.master)) continue;
				masterFeatsUsed.add(classFeat.master);
				classFeat = classFeat.master;
			}
			
			// Freely selectable feats become available at L1
			if(grantedLevel == -1){
				if(classFeat.isEpic){
					// Epic feats should be shown to become available on the level that is the first after the class's normal progression ends
					// Sanity check here against bad class entries causing index violations
					grantedLevel = Math.min(epicLevel + 1, maxLevel);
				}
				else
					grantedLevel = 1;
			}
			grantedLevel -= 1; // Adjust to 0-based array index
			// Differentiate by automatically granted or selectable
			if(listNum.equals("3")){
				// Create the map if missing
				if(grantedFeatList.get(grantedLevel) == null)
					grantedFeatList.set(grantedLevel, new TreeMap<String, FeatEntry>());
				
				// Add the feat to the map
				grantedFeatList.get(grantedLevel).put(classFeat.name, classFeat);
			}
			else{
				// Create the map if missing
				if(selectableFeatList.get(grantedLevel) == null)
					selectableFeatList.set(grantedLevel, new TreeMap<String, FeatEntry>());
				
				// Add the feat to the map
				selectableFeatList.get(grantedLevel).put(classFeat.name, classFeat);
			}
		}
		
		// Make sure there are enough entries in the bonus feat table
		if(bonusFeatTable.getEntryCount() < maxLevel) {
			if(tolErr){
				err_pr.println("Too few entries in class bonus feat table " + bonusFeatTable.getName() + ": " + bonusFeatTable.getEntryCount() + ". Need " + maxLevel);
				return "";
			}
			else throw new PageGenerationException("Too few entries in class bonus feat table " + bonusFeatTable.getName() + ": " + bonusFeatTable.getEntryCount() + ". Need " + maxLevel);
		}
		
		// Start constructing the table
		StringBuffer tableText = new StringBuffer();
		StringBuffer linkList = null;
		String tableLine = null;
		for(int i = 0; i < maxLevel; i++) {
			tableLine = classFeatTableEntryTemplate.replace("~~~Level~~~", String.valueOf(i + 1))
			                                       .replace("~~~NumberOfBonusFeats~~~", bonusFeatTable.getEntry("Bonus", i));
			// Generate the granted feats list
			linkList = new StringBuffer();
			if(grantedFeatList.get(i) != null)
				for(FeatEntry feat : grantedFeatList.get(i).values()){
					linkList.append(pageLinkTemplate.replace("~~~Path~~~", feat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
	                                                .replace("~~~Name~~~", feat.name));
				}
			else
				linkList.append("&nbsp;");
			tableLine = tableLine.replace("~~~FeatsGrantedList~~~", linkList.toString());
			
			// Generate the granted feats list
			linkList = new StringBuffer();
			if(selectableFeatList.get(i) != null)
				for(FeatEntry feat : selectableFeatList.get(i).values()){
					linkList.append(pageLinkTemplate.replace("~~~Path~~~", feat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
	                                                .replace("~~~Name~~~", feat.name));
				}
			else
				linkList.append("&nbsp;");
			tableLine = tableLine.replace("~~~SelectableFeatsList~~~", linkList.toString());
			
			// Append the line to the table
			tableText.append(tableLine);
		}
		
		return classFeatTableTemplate.replace("~~~TableContents~~~", tableText.toString());
	}
}