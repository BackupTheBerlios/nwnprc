/*
 * ResourceFactory.java
 *
 * Created on February 23, 2003, 6:26 PM
 */

package CharacterCreator;

import CharacterCreator.io.*;
import CharacterCreator.key.*;
import CharacterCreator.key.HakResource;
import CharacterCreator.key.BIFFile;
import CharacterCreator.key.KeyFile;
import CharacterCreator.key.PatchKeyFile;
import CharacterCreator.key.XP1KeyFile;
import CharacterCreator.key.ResourceFile;
import CharacterCreator.key.HakFile;
import CharacterCreator.key.XP1PatchKeyFile;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.prefs.Preferences;
import javax.swing.JOptionPane;
import javax.swing.ImageIcon;

// Referenced classes of package CharacterCreator:
//            WindowBlocker, MainMenu

public class ResourceFactory {
    
    public ResourceFactory() {
        moreoutput = false;
        blocker.setBlocked(true);
        key = new KeyFile();
        patchkey = new PatchKeyFile();
        xp1 = new XP1KeyFile();
        xp1patch = new XP1PatchKeyFile();
        xp2 = new XP2KeyFile();
        xp2patch = new XP2PatchKeyFile();        
        try {
            key.KeyFile();
            if(patchkey.testkey()) {
                patchkey.KeyFile();
            }
            if(xp1.testkey()) {
                xp1.KeyFile();
            }
            if(xp1patch.testkey()) {
                xp1patch.KeyFile();
            }
            if(xp2.testkey()) {
                xp2.KeyFile();
            }
            if(xp2patch.testkey()) {
                xp2patch.KeyFile();
            }            
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - chitin.key or patch.key corrupt or missing - Reinstall NWN.", "Error", 0);
            System.exit(0);
        }

        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        FileDelim = prefs.get("FileDelim", null);
        NWNDir = prefs.get("GameDir", null);
        String HakNumStr = prefs.get("HakNum", null);
		hakFiles = new HakFile[(HakNumStr == null) ? 0 : Integer.parseInt(HakNumStr)];

		for(int ii = 0; ii < hakFiles.length; ++ii)
			try {
				hakFiles[ii] = new HakFile(prefs.get("HakFile" + ii, null));
			}
			catch (IOException ioe) {}

        blocker.setBlocked(false);
    }
    
    private boolean SetToResource(String FullResource) throws IOException {
        String Resource = FullResource.substring(0, FullResource.length() - 4).toLowerCase();
        
		for(int ii = 0; ii < hakFiles.length; ++ii) {
			if (hakFiles[ii].FileExists(Resource)) {
				if (moreoutput)
					System.out.println(FullResource + " exists in " + hakFiles[ii].getHAKname() + ".");

				HakResource targetres = (HakResource)hakFiles[ii].HAKMap.get(Resource);
				int hakindex = targetres.getindex();
				RandomAccessFile raf_biffile = new RandomAccessFile(new File(hakFiles[ii].getHAKname()), "r");
				int totaloffset = hakFiles[ii].getposoffset() + (hakindex * 8);
				raf_biffile.seek(totaloffset);
				resfileoffset = Filereader.readInt(raf_biffile);
				resfilesize = Filereader.readInt(raf_biffile);
				resfiletype = targetres.getintextension();

				if(resfilesize > 0xf4240)
					blocker.setBlocked(true);

				raf_biffile.seek(resfileoffset);
				ResourceBuffer = new byte[resfilesize];
				raf_biffile.readFully(ResourceBuffer);

				raf_biffile.close();
				blocker.setBlocked(false);
				return true;
			}
			else if (moreoutput)
				System.out.println(FullResource + " does not exist in " + hakFiles[ii].getHAKname() + ".");
		}

        // Portrait search
        try {
            if(NWNDir == null || !(new File(NWNDir + "portraits" + FileDelim + FullResource)).exists()) {
                if(moreoutput) System.out.println(FullResource + " does not exist in the Portraits directory.");
            } else {
                if(moreoutput) System.out.println(FullResource + " exists in the Portraits directory.");
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(NWNDir + "portraits" + FileDelim + FullResource), "r");
                ResourceBuffer = new byte[(int)raf_biffile.length()];
                raf_biffile.readFully(ResourceBuffer);
                resfileoffset = 0;
                resfilesize = ResourceBuffer.length;
                raf_biffile.close();
                return true;
            }
        }
        catch(NullPointerException err) {
            if(moreoutput) System.out.println(FullResource + " does not exist in the Portraits directory.");
        }
        // Override search
        try {
            if(NWNDir == null || !(new File(NWNDir + "override" + FileDelim + FullResource)).exists()) {
                if(moreoutput) System.out.println(FullResource + " does not exist in the Override directory.");
            } else {
                if(moreoutput) System.out.println(FullResource + " exists in the Override directory.");
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(NWNDir + "override" + FileDelim + FullResource), "r");
                ResourceBuffer = new byte[(int)raf_biffile.length()];
                raf_biffile.readFully(ResourceBuffer);
                raf_biffile.close();
                resfileoffset = 0;
                resfilesize = ResourceBuffer.length;
                return true;
            }
        }
        catch(NullPointerException err) {
            if(moreoutput) System.out.println(FullResource + " does not exist in the Override directory.");
        }

        // Patch search
        if(patchkey.testkey()) {
            if(!(PatchKeyFile.resourcemap.containsKey(Resource))) {
                if(moreoutput) System.out.println(FullResource + " not found in the Patch folder.");
            } else {
                if(moreoutput) System.out.println(FullResource + " found in the Patch folder.");
                ResourceFile resfile = (ResourceFile)PatchKeyFile.resourcemap.get(Resource);
                BIFFile testbif = (BIFFile)PatchKeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
                String biffilename = NWNDir + testbif.getBIFname();
                InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
                String signature = Filereader.readString(is, 4);
                is.close();
                if(!signature.equals("BIFF")) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                    System.exit(0);
                }
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
                raf_biffile.seek(8L);
                numfiles = 0;
                numfiles = Filereader.readInt(raf_biffile);
                Filereader.readInt(raf_biffile);
                resoff = 0;
                resoff = Filereader.readInt(raf_biffile);
                int resinfooffset = 0;
                resinfooffset = 16 * resfile.getBIFloc();
                raf_biffile.seek(resoff + resinfooffset);
                int resentry = 0;
                resentry = Filereader.readShort(raf_biffile);
                int resentrymult = Filereader.readShort(raf_biffile);
                resfileoffset = Filereader.readInt(raf_biffile);
                resfilesize = Filereader.readInt(raf_biffile);
                resfiletype = Filereader.readShort(raf_biffile);
                if(resfilesize > 0xf4240)
                    blocker.setBlocked(true);
                raf_biffile.seek(resfileoffset);
                ResourceBuffer = new byte[resfilesize];
                raf_biffile.readFully(ResourceBuffer);
                blocker.setBlocked(false);
                raf_biffile.close();
                return true;
            }
        }
        //XP2 Patch Search
        if(xp2patch.testkey()) {
            if(!(XP2PatchKeyFile.resourcemap.containsKey(Resource))) {
                if(moreoutput) System.out.println(FullResource + " not found in the XP2Patch folder.");
            } else {
                if(moreoutput) System.out.println(FullResource + " found in the XP2Patch folder.");
                ResourceFile resfile = (ResourceFile)XP2PatchKeyFile.resourcemap.get(Resource);
                BIFFile testbif = (BIFFile)XP2PatchKeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
                String biffilename = NWNDir + testbif.getBIFname();
                InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
                String signature = Filereader.readString(is, 4);
                is.close();
                if(!signature.equals("BIFF")) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                    System.exit(0);
                }
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
                raf_biffile.seek(8L);
                numfiles = 0;
                numfiles = Filereader.readInt(raf_biffile);
                Filereader.readInt(raf_biffile);
                resoff = 0;
                resoff = Filereader.readInt(raf_biffile);
                int resinfooffset = 0;
                resinfooffset = 16 * resfile.getBIFloc();
                raf_biffile.seek(resoff + resinfooffset);
                int resentry = 0;
                resentry = Filereader.readShort(raf_biffile);
                int resentrymult = Filereader.readShort(raf_biffile);
                resfileoffset = Filereader.readInt(raf_biffile);
                resfilesize = Filereader.readInt(raf_biffile);
                resfiletype = Filereader.readShort(raf_biffile);
                if(resfilesize > 0xf4240)
                    blocker.setBlocked(true);
                raf_biffile.seek(resfileoffset);
                ResourceBuffer = new byte[resfilesize];
                raf_biffile.readFully(ResourceBuffer);
                blocker.setBlocked(false);
                raf_biffile.close();
                return true;
            }
        }
        // XP2 Search
        if(xp2.testkey()) {
            if(!(XP2KeyFile.resourcemap.containsKey(Resource))) {
                if(moreoutput) System.out.println(FullResource + " not found in the XP2 folder.");
            } else {
                if(moreoutput) System.out.println(FullResource + " found in the XP2 folder.");
                ResourceFile resfile = (ResourceFile)XP2KeyFile.resourcemap.get(Resource);
                BIFFile testbif = (BIFFile)XP2KeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
                String biffilename = NWNDir + testbif.getBIFname();
                InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
                String signature = Filereader.readString(is, 4);
                is.close();
                if(!signature.equals("BIFF")) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                    System.exit(0);
                }
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
                raf_biffile.seek(8L);
                numfiles = 0;
                numfiles = Filereader.readInt(raf_biffile);
                Filereader.readInt(raf_biffile);
                resoff = 0;
                resoff = Filereader.readInt(raf_biffile);
                int resinfooffset = 0;
                resinfooffset = 16 * resfile.getBIFloc();
                raf_biffile.seek(resoff + resinfooffset);
                int resentry = 0;
                resentry = Filereader.readShort(raf_biffile);
                int resentrymult = Filereader.readShort(raf_biffile);
                resfileoffset = Filereader.readInt(raf_biffile);
                resfilesize = Filereader.readInt(raf_biffile);
                resfiletype = Filereader.readShort(raf_biffile);
                if(resfilesize > 0xf4240)
                    blocker.setBlocked(true);
                raf_biffile.seek(resfileoffset);
                ResourceBuffer = new byte[resfilesize];
                raf_biffile.readFully(ResourceBuffer);
                blocker.setBlocked(false);
                raf_biffile.close();
                return true;
            }
        }        
        
        //XP Patch Search
        if(xp1patch.testkey()) {
            if(!(XP1PatchKeyFile.resourcemap.containsKey(Resource))) {
                if(moreoutput) System.out.println(FullResource + " not found in the XP1Patch folder.");
            } else {
                if(moreoutput) System.out.println(FullResource + " found in the XP1Patch folder.");
                ResourceFile resfile = (ResourceFile)XP1PatchKeyFile.resourcemap.get(Resource);
                BIFFile testbif = (BIFFile)XP1PatchKeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
                String biffilename = NWNDir + testbif.getBIFname();
                InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
                String signature = Filereader.readString(is, 4);
                is.close();
                if(!signature.equals("BIFF")) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                    System.exit(0);
				}
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
                raf_biffile.seek(8L);
                numfiles = 0;
                numfiles = Filereader.readInt(raf_biffile);
                Filereader.readInt(raf_biffile);
                resoff = 0;
                resoff = Filereader.readInt(raf_biffile);
                int resinfooffset = 0;
                resinfooffset = 16 * resfile.getBIFloc();
                raf_biffile.seek(resoff + resinfooffset);
                int resentry = 0;
                resentry = Filereader.readShort(raf_biffile);
                int resentrymult = Filereader.readShort(raf_biffile);
                resfileoffset = Filereader.readInt(raf_biffile);
                resfilesize = Filereader.readInt(raf_biffile);
                resfiletype = Filereader.readShort(raf_biffile);
                if(resfilesize > 0xf4240)
                    blocker.setBlocked(true);
                raf_biffile.seek(resfileoffset);
                ResourceBuffer = new byte[resfilesize];
                raf_biffile.readFully(ResourceBuffer);
                blocker.setBlocked(false);
                raf_biffile.close();
                return true;
            }
        }
        // XP Search
        if(xp1.testkey()) {
            if(!(XP1KeyFile.resourcemap.containsKey(Resource))) {
                if (moreoutput)
					System.out.println(FullResource + " not found in the XP1 folder.");
            }
			else {
                if(moreoutput) System.out.println(FullResource + " found in the XP1 folder.");
                ResourceFile resfile = (ResourceFile)XP1KeyFile.resourcemap.get(Resource);
                BIFFile testbif = (BIFFile)XP1KeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
                String biffilename = NWNDir + testbif.getBIFname();
                InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
                String signature = Filereader.readString(is, 4);
                is.close();
                if(!signature.equals("BIFF")) {
                    JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                    System.exit(0);
                }
                RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
                raf_biffile.seek(8L);
                numfiles = 0;
                numfiles = Filereader.readInt(raf_biffile);
                Filereader.readInt(raf_biffile);
                resoff = 0;
                resoff = Filereader.readInt(raf_biffile);
                int resinfooffset = 0;
                resinfooffset = 16 * resfile.getBIFloc();
                raf_biffile.seek(resoff + resinfooffset);
                int resentry = 0;
                resentry = Filereader.readShort(raf_biffile);
                int resentrymult = Filereader.readShort(raf_biffile);
                resfileoffset = Filereader.readInt(raf_biffile);
                resfilesize = Filereader.readInt(raf_biffile);
                resfiletype = Filereader.readShort(raf_biffile);
                if(resfilesize > 0xf4240)
                    blocker.setBlocked(true);
                raf_biffile.seek(resfileoffset);
                ResourceBuffer = new byte[resfilesize];
                raf_biffile.readFully(ResourceBuffer);
                blocker.setBlocked(false);
                raf_biffile.close();
                return true;
            }
        }
        
        // Data search
        if(!(KeyFile.resourcemap.containsKey(Resource))) {
            if(moreoutput)
				System.out.println(FullResource + " not found in the Data folder.");
            if(moreoutput)
				System.out.println("I'm giving up, that file doesn't exist.");
        }
		else {
            if(moreoutput) System.out.println(FullResource + " found in the Data folder.");
            ResourceFile resfile = (ResourceFile)KeyFile.resourcemap.get(Resource);
            BIFFile testbif = (BIFFile)KeyFile.BIFmap.get(new Integer(resfile.getBIFid()));
            String biffilename = NWNDir + testbif.getBIFname();
            InputStream is = new BufferedInputStream(new FileInputStream(new File(biffilename)));
            String signature = Filereader.readString(is, 4);
			is.close();
            if(!signature.equals("BIFF")) {
                JOptionPane.showMessageDialog(null, "Fatal Error - unsupported BIF format.", "Error", 0);
                System.exit(0);
            }
            RandomAccessFile raf_biffile = new RandomAccessFile(new File(biffilename), "r");
            raf_biffile.seek(8L);
            numfiles = 0;
            numfiles = Filereader.readInt(raf_biffile);
            Filereader.readInt(raf_biffile);
            resoff = 0;
            resoff = Filereader.readInt(raf_biffile);
            int resinfooffset = 0;
            resinfooffset = 16 * resfile.getBIFloc();
            raf_biffile.seek(resoff + resinfooffset);
            int resentry = 0;
            resentry = Filereader.readShort(raf_biffile);
            int resentrymult = Filereader.readShort(raf_biffile);
            resfileoffset = Filereader.readInt(raf_biffile);
            resfilesize = Filereader.readInt(raf_biffile);
            resfiletype = Filereader.readShort(raf_biffile);
            if(resfilesize > 0xf4240)
                blocker.setBlocked(true);
            raf_biffile.seek(resfileoffset);
            ResourceBuffer = new byte[resfilesize];
            raf_biffile.readFully(ResourceBuffer);
            blocker.setBlocked(false);
            raf_biffile.close();
            return true;
        }

		return false;
    }
    
    public byte[] getResBuffer() {
        return ResourceBuffer;
    }

	public File TempImageFile(String imageName) throws IOException {
		File retVal = null;
		String filename = fixFilename(imageName, ".tga");

		if (filename != null) {

			if (tempFiles == null)
				tempFiles = new HashMap();

			retVal = (File)icons.get(filename);
			if (retVal == null && SetToResource(filename)) {
				if (getResBuffer().length > 10) {
					retVal = File.createTempFile(filename, ".tga");
					retVal.deleteOnExit();
					FileOutputStream imageput = new FileOutputStream(retVal);
					imageput.write(getResBuffer());
					imageput.close();

					tempFiles.put(filename, retVal);
				}
			}
		}

		return retVal;
	}
    
	private String[] parse2DALine(String line) {
		String[] parsedLine = null;

		if (line != null && line.length() > 0) {
			// If this line doesn't contain quoted material
			if (line.indexOf('\"') == -1) {
				parsedLine = line.split("\\s+");

				for (int ii=0; ii<parsedLine.length; ++ii) {
					if (parsedLine[ii].startsWith("*"))
						parsedLine[ii] = null;
				}
			}
			else {
				String whitespace = " \t";
				char[] cline = line.toCharArray();
				int pos = 0;

				// Skip any whitespace
				while (pos < cline.length) {
					// When the current char isn't in the whitespace listing
					// We have found the beginning of a word or start token
					if (whitespace.indexOf(cline[pos]) == -1)
						break;

					++pos;
				}

				int epos = pos;
				String str = null;
				ArrayList al = new ArrayList();

				// Alternate between collecting entries and skipping white space
				while (pos < cline.length) {
					// Is this a quoted entry?
					if (cline[pos] == '\"') {
						// Locate the end marker (closing quote/eol)
						for (epos = pos + 1; epos < cline.length; ++epos)
							if (cline[epos] == '\"')
								break;

						// Discard the quotes
						pos++;
					}
					else {
						// Skip until a white space member is found
						for (epos = pos + 1; epos < cline.length; ++epos)
							if (whitespace.indexOf(cline[epos]) != -1)
									break;
					}

					// Create and canonicalize the string
					str = new String(cline, pos, epos - pos);
					if (str.length() == 0 || str.startsWith("*"))
						str = null;

					// Add string to array list
					al.add(str);

					// Update postions
					pos = epos;
					if (pos < cline.length && cline[pos] == '\"')
						++pos;

					// Skip any whitespace
					while (pos < cline.length) {
						// When the current char isn't in the whitespace listing
						// We have found the beginning of a word or start token
						if (whitespace.indexOf(cline[pos]) == -1)
							break;

						++pos;
					}
				}

				// Convert the ArrayList into an Array
				parsedLine = new String[al.size()];
				for (int ii=0; ii<al.size(); ++ii)
					parsedLine[ii] = (String)al.get(ii);
			}
		}

		return parsedLine;
	}

	public String fixFilename(String name, String extension) {
		String base = null;

		if (name != null) {
			// Extract the basefilename, truncate to 16 chars if required
			int pos = name.indexOf(".");
			base = (pos == -1) ? name : name.substring(0, pos);

			// Hardlimit of 16 chars in base filenames
			if (base.length() > 16)
				base = base.substring(0, 16);

			// Apply extension.
			if (extension != null)
				base = base.concat(extension);

			// Lowercase the name
			base = base.toLowerCase();
		}

		return base;
	}

	public void clearCache() {
		icons = null;
		resource2DAs = null;
		tempFiles = null;
	}

	public ImageIcon getIcon(String imageName) throws IOException {
		if (imageName == null)
			return null;

		String filename = fixFilename(imageName, ".tga");

		if (icons == null)
			icons = new HashMap();

		ImageIcon icon = (ImageIcon)icons.get(filename);
		if (icon != null)
			return icon;

		// Load the file from resources
		if (SetToResource(filename)) {
			try {
				icon = new ImageIcon(new TargaImage(getResBuffer()).getImage());
				icons.put(filename, icon);
			}
			catch (IOException e) {
				icon = null;
				System.out.println(
						"Invalid icon - " + e.getMessage() + ": " + filename
					);
				//e.printStackTrace();
			}
		}
		else
			System.out.println("Invalid icon: " + filename);

		return icon;
	}

    public String[][] getResourceAs2DA(String name) throws IOException {
		return getResourceAs2DA(name, true);
	}
    
    //This returns a hashmap of the 2da, each of them proper
    public String[][] getResourceAs2DA(String name, boolean cache) throws IOException {
		String filename = fixFilename(name, ".2da");

		// Determine if this file has already been loaded
		if (resource2DAs == null)
			resource2DAs = new HashMap();

		String[][] datamap = (String[][])resource2DAs.get(filename);
		if (datamap != null)
			return datamap;

		// Load the file
		if (!SetToResource(filename)) {
			System.out.println("Invalid 2da: " + filename);
			return null;
		}

		// Create the containing stream structure
		ByteArrayInputStream bais = new ByteArrayInputStream(getResBuffer());
		InputStreamReader ir = new InputStreamReader(bais);
		BufferedReader br = new BufferedReader(ir);

		// Skip Initial lines
		String currentLine = br.readLine();
		while (currentLine != null && !currentLine.startsWith("0"))
			currentLine = br.readLine();

		// Parse the remainder of the lines
		int columns = 0;
		String[] parsedLine;
		ArrayList parsedLines = new ArrayList();
		while (currentLine != null) {
			currentLine = currentLine.trim();
			if (currentLine.length() != 0) {
				parsedLine = parse2DALine(currentLine);
				parsedLines.add(parsedLine);

				if (parsedLines.size() == 1)
					columns = parsedLine.length;
				else if (parsedLine.length != columns)
					System.out.println("Columns don't match: "
							+ name + ":" + columns + ","
							+ parsedLine.length
						);
			}

			currentLine = br.readLine();
		}

		// Streams aren't needed any longer
		br.close();
		ir.close();
		bais.close();

		String[][] result = new String[parsedLines.size()][];
		for (int index = 0; index < parsedLines.size(); ++index)
			result[index] = (String[])parsedLines.get(index);
        
		if (cache)
			resource2DAs.put(filename, result);

        return result;
    }
    
    public boolean FileExists(String newdirec, String incres) {
        boolean filemore = false;
        String NewFullResource = newdirec + incres;
        String NewResource = incres.substring(0, incres.length() - 4);
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String FileDelim = prefs.get("FileDelim", null);
        String NWNDir = prefs.get("GameDir", null);

        for(int hh = 0; hh < hakFiles.length; hh++) {
            HakFile tmphak = hakFiles[hh];
            if(tmphak.HAKMap.containsKey(NewResource)) {
                if(filemore) System.out.println(NewFullResource + " exists in HakFile" + hh + ".");
                return true;
            } else {
                if(filemore) System.out.println(NewFullResource + " does not exist in HakFile" + hh + ".");
            }
        }
        
        //PORTRAITS STUFF
        try {
            if(NWNDir == null || !(new File(NWNDir + "portraits" + FileDelim + NewFullResource)).exists()) {
            } else {
                if(filemore) System.out.println(NewFullResource + " exists in the Portraits directory.");
                return true;
            }
        }
        catch(NullPointerException err) {
            if(filemore) System.out.println(NewFullResource + " does not exist in the Portraits directory.");
        }
        //Override
        try {
            if(NWNDir == null || !(new File(NWNDir + "override" + FileDelim + NewFullResource)).exists()) {
                if(filemore) System.out.println(NewFullResource + " does not exist in the Override directory.");
            } else {
                if(filemore) System.out.println(NewFullResource + " exists in the Override directory.");
                return true;
            }
        }
        catch(NullPointerException err) {
            if(filemore) System.out.println(NewFullResource + " does not exist in the Override directory.");
        }
        
        //Patch Key
        if(patchkey.testkey()) {
            if(!(PatchKeyFile.resourcemap.containsKey(NewResource))) {
                if(filemore) System.out.println(NewFullResource + " not found in the Patch folder.");
            } else {
                if(filemore) System.out.println(NewFullResource + " found in the Patch folder.");
                return true;
            }
        }
        
        //Expansion 2 patch key (HotU)
        if(xp2patch.testkey()) {
            if(!(XP2PatchKeyFile.resourcemap.containsKey(NewResource))) {
                if(filemore) System.out.println(NewFullResource + " not found in the XP2Patch folder.");
            } else {
                if(filemore) System.out.println(NewFullResource + " found in the XP2Patch folder.");
            }
        }
        
        //Expansion 2 key (HotU)
        if(xp1.testkey()) {
            if(!(XP2KeyFile.resourcemap.containsKey(NewResource))) {
                if(filemore) System.out.println(NewFullResource + " not found in the XP2 folder.");
            } else {
                if(filemore) System.out.println(NewFullResource + " found in the XP2 folder.");
                return true;
            }
        }        
        
        //Expansion 1 patch key (SoU)
        if(xp1patch.testkey()) {
            if(!(XP1PatchKeyFile.resourcemap.containsKey(NewResource))) {
                if(filemore) System.out.println(NewFullResource + " not found in the XP1Patch folder.");
            } else {
                if(filemore) System.out.println(NewFullResource + " found in the XP1Patch folder.");
            }
        }
        
        //Expansion 1 key (SoU)
        if(xp1.testkey()) {
            if(!(XP1KeyFile.resourcemap.containsKey(NewResource))) {
                if(filemore) System.out.println(NewFullResource + " not found in the XP1 folder.");
            } else {
                if(filemore) System.out.println(NewFullResource + " found in the XP1 folder.");
                return true;
            }
        }
        
        if(KeyFile.resourcemap.containsKey(NewResource)) {
            if(filemore) System.out.println(NewFullResource + " found in the Data folder.");
            return true;
        } else {
            if(filemore) System.out.println(NewFullResource + " not found in the Data folder.");
            if(filemore) System.out.println("I'm giving up, that file doesn't exist.");
        }

		return false;
    }
    
    private static WindowBlocker blocker = new WindowBlocker(MainMenu.getMainMenu());
    private int biffentryoff;
    private int numfiles;
    private int resoff;
    public byte ResourceBuffer[];
    ///private HakFile hak;
    private KeyFile key;
    private PatchKeyFile patchkey;
    private XP1KeyFile xp1;
    private XP1PatchKeyFile xp1patch;
    private XP2KeyFile xp2;
    private XP2PatchKeyFile xp2patch;    
    public int resfileoffset;
    public int resfilesize;
    public int resfiletype;
    private boolean moreoutput;
	private String FileDelim;
	private String NWNDir;

	// Resource Caches
	private HashMap resource2DAs;
	private HashMap icons;
	private HashMap tempFiles;
	private HakFile[] hakFiles;
}
