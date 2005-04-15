package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

/* Static import in order to let me use the enum constants in switches */
import static prc.autodoc.Main.SpellType.*;

import static prc.autodoc.Main.*;

public final class MenuGeneration{
	private MenuGeneration(){}
	
	/**
	 * Sorts any of the pages for which GenericEntry is enough into alphabetic order
	 * using a TreeMap, and prints a menu page out of the results.
	 */
	public static void doGenericMenu(HashMap<Integer, GenericEntry> entries, String menuName, String menuFileName){
		TreeMap<String, String> links = new TreeMap<String, String>();
		StringBuffer toPrint = new StringBuffer();
		
		if(verbose) System.out.println("Printing menu for " + menuName);
		
		for(GenericEntry entry : entries.values()){
			links.put(entry.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
			                                                  entry.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
			                                      .replaceAll("~~~targetName~~~", entry.name));
		}
		
		while(links.size() > 0){
			toPrint.append(links.remove(links.firstKey()));
		}
		
		printPage(menuPath + menuFileName, menuTemplate.replaceAll("~~~menuName~~~", menuName)
		                                               .replaceAll("~~~menuEntries~~~", toPrint.toString()));
	}
	
	/**
	 * Sorts the spells into alphabetic order using a TreeMap, and prints a menu
	 * page out of the results. Normal, epic and psionics get their own menus
	 */
	public static void doSpellMenus(){
		TreeMap<String, String> normalSpellLinks  = new TreeMap<String, String>(),
		                        epicSpellLinks    = new TreeMap<String, String>(),
		                        psionicPowerLinks = new TreeMap<String, String>(),
		                        modSpellLinks     = new TreeMap<String, String>();
		StringBuffer normalPrint   = new StringBuffer(),
		             epicPrint     = new StringBuffer(),
		             psionicPrint  = new StringBuffer(),
		             modSpellPrint = new StringBuffer();
		String temp = null;
		
		if(verbose) System.out.println("Printing spell menus");
		
		for(SpellEntry spell : spells.values()){
			switch(spell.type){
				case NORMAL:
					normalSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                             spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                                 .replaceAll("~~~targetName~~~", spell.name));
					break;
				case EPIC:
					temp = spell.name.startsWith("Epic Spell: ") ? spell.name.substring(12) : spell.name;
					epicSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                           spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                               .replaceAll("~~~targetName~~~", temp));
					break;
				case PSIONIC:
					psionicPowerLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                              spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                                  .replaceAll("~~~targetName~~~", spell.name));
					break;
				
				default: throw new AssertionError("This message should not be seen");
			}
			
			if(settings.modifiedSpells.contains(spell.entryNum))
				modSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                          spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                              .replaceAll("~~~targetName~~~", spell.name));
		}
		
		while(normalSpellLinks.size() > 0)
			normalPrint.append(normalSpellLinks.remove(normalSpellLinks.firstKey()));
		while(epicSpellLinks.size() > 0)
			epicPrint.append(epicSpellLinks.remove(epicSpellLinks.firstKey()));
		while(psionicPowerLinks.size() > 0)
			psionicPrint.append(psionicPowerLinks.remove(psionicPowerLinks.firstKey()));
		while(modSpellLinks.size() > 0)
			modSpellPrint.append(modSpellLinks.remove(modSpellLinks.firstKey()));
		
		printPage(menuPath + "manual_menus_spells.html", menuTemplate.replaceAll("~~~menuName~~~", "Spells")
		                                                             .replaceAll("~~~menuEntries~~~", normalPrint.toString()));
		printPage(menuPath + "manual_menus_epic_spells.html", menuTemplate.replaceAll("~~~menuName~~~", "Epic Spells")
		                                                                  .replaceAll("~~~menuEntries~~~", epicPrint.toString()));
		printPage(menuPath + "manual_menus_psionic_powers.html", menuTemplate.replaceAll("~~~menuName~~~", "Psionic Powers")
		                                                                     .replaceAll("~~~menuEntries~~~", psionicPrint.toString()));
		printPage(menuPath + "manual_menus_modified_spells.html", menuTemplate.replaceAll("~~~menuName~~~", "Modified Spells")
		                                                                      .replaceAll("~~~menuEntries~~~", modSpellPrint.toString()));
	}
	
	
	/**
	 * Sorts the feats into alphabetic order using a TreeMap, and prints a menu
	 * page out of the results. Normal and epic feats get their own menus and class feats
	 * are skipped.
	 */
	public static void doFeatMenus(){
		TreeMap<String, String> normalFeatLinks  = new TreeMap<String, String>(),
		                        epicFeatLinks    = new TreeMap<String, String>();
		StringBuffer normalPrint  = new StringBuffer(),
		             epicPrint    = new StringBuffer();
		String temp = null;
		
		if(verbose) System.out.println("Printing feat menus");
		
		// Parse through feats
		for(FeatEntry feat : feats.values()){
			// Skip class feats and feats with masterfeat or a predecessor
			if(feat.isClassFeat || feat.isSuccessor || feat.master != null) continue; 
			if(!feat.isEpic)
				normalFeatLinks.put(feat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                           feat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                               .replaceAll("~~~targetName~~~", feat.name));
			else
				epicFeatLinks.put(feat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                         feat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                             .replaceAll("~~~targetName~~~", feat.name));
		}
		
		// Parse through masterfeats
		for(FeatEntry masterfeat : masterFeats.values()){
			if(masterfeat.isClassFeat) continue;
			if(!masterfeat.isEpic)
				normalFeatLinks.put(masterfeat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                                 masterfeat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                                     .replaceAll("~~~targetName~~~", masterfeat.name));
			else
				epicFeatLinks.put(masterfeat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                               masterfeat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                                   .replaceAll("~~~targetName~~~", masterfeat.name));
		}
		
		// Add in a link to the page listing *all* feats
		normalPrint.append(menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                       (contentPath + "feats" + fileSeparator + "alphasortedfeats.html")
				                                        .replace(mainPath, "../").replaceAll("\\\\", "/"))
				                           .replaceAll("~~~targetName~~~", curLanguageData[3]));
		
		while(normalFeatLinks.size() > 0)
			normalPrint.append(normalFeatLinks.remove(normalFeatLinks.firstKey()));
		while(epicFeatLinks.size() > 0)
			epicPrint.append(epicFeatLinks.remove(epicFeatLinks.firstKey()));
		
		printPage(menuPath + "manual_menus_feat.html", menuTemplate.replaceAll("~~~menuName~~~", "Feats")
		                                                           .replaceAll("~~~menuEntries~~~", normalPrint.toString()));
		printPage(menuPath + "manual_menus_epic_feat.html", menuTemplate.replaceAll("~~~menuName~~~", "Epic Feats")
		                                                                .replaceAll("~~~menuEntries~~~", epicPrint.toString()));
	}
	
	
	/**
	 * Sorts the classes into alphabetic order using a TreeMap, and prints a menu
	 * page out of the results. Base and prestige classes get their own menus
	 */
	public static void doClassMenus(){
		TreeMap<String, String> baseLinks      = new TreeMap<String, String>(),
		                        prestigeLinks  = new TreeMap<String, String>();
		StringBuffer basePrint     = new StringBuffer(),
		             prestigePrint = new StringBuffer();
		String temp = null;
		
		if(verbose) System.out.println("Printing class menus");
		
		for(ClassEntry clazz : classes.values()){
			if(clazz.isBase)
				baseLinks.put(clazz.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                      clazz.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                          .replaceAll("~~~targetName~~~", clazz.name));
			else
				prestigeLinks.put(clazz.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
				                                                          clazz.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
				                                              .replaceAll("~~~targetName~~~", clazz.name));
		}
		
		while(baseLinks.size() > 0)
			basePrint.append(baseLinks.remove(baseLinks.firstKey()));
		while(prestigeLinks.size() > 0)
			prestigePrint.append(prestigeLinks.remove(prestigeLinks.firstKey()));
		
		printPage(menuPath + "manual_menus_base_classes.html", menuTemplate.replaceAll("~~~menuName~~~", "Base Classes")
		                                                                   .replaceAll("~~~menuEntries~~~", basePrint.toString()));
		printPage(menuPath + "manual_menus_prestige_classes.html", menuTemplate.replaceAll("~~~menuName~~~", "Prestige Classes")
		                                                                       .replaceAll("~~~menuEntries~~~", prestigePrint.toString()));
	}
}