/*
 * TLKFactory.java
 *
 * Created on February 23, 2003, 6:22 PM
 */

package CharacterCreator;

import CharacterCreator.io.Filereader;
import CharacterCreator.util.ChkHex;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.prefs.Preferences;
import javax.swing.*;
import java.lang.Exception;

// Referenced classes of package CharacterCreator:
//            ProgressBar, CreateMenu

public class TLKFactory {
    
    public TLKFactory() {
        
        TLKMap = new ArrayList();
        //TLKMap = new HashMap();
        progressbar = new ProgressBar();
        progressbar.ProgressText.setText("Loading Dialog.TLK...");
        progressbar.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        progressbar.ProgressBar.setStringPainted(true);
        progressbar.ProgressBar.setIndeterminate(false);
        progressbar.show();
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String NWNDir = prefs.get("GameDir", null);
        boolean extratlk = false;
        boolean alttlk = false;
        String tlkonoff = prefs.get("TLKDefault", null);
        if(tlkonoff != null && tlkonoff.equalsIgnoreCase("FALSE")) {
            NEWTLKFILE = prefs.get("TLKFile", null);
            if(new File(NEWTLKFILE).exists()) {
                extratlk = true;
                System.out.println("TLKFile " + NEWTLKFILE + " exists.");
            }
        }
        
        String alttlkonoff = prefs.get("AltTLKDefault", null);
        if(alttlkonoff != null && alttlkonoff.equalsIgnoreCase("TRUE")) {
            ALTTLKFILE = prefs.get("AltTLKFile", null);
            if(new File(ALTTLKFILE).exists()) {
                alttlk = true;
                System.out.println("AltTLKFile " + ALTTLKFILE + " exists.");
                AltTLKName = prefs.get("AltTLKName", null);
            }
        }
        
        try {
            if(extratlk) {
                TLKFile = new RandomAccessFile(new File(NEWTLKFILE), "r");
            } else {
                TLKFile = new RandomAccessFile(new File(NWNDir, "dialog.tlk"), "r");
            }
            String signature = Filereader.readString(TLKFile, 4);
            String version = Filereader.readString(TLKFile, 4);
            if(!signature.equalsIgnoreCase("TLK ") || !version.equalsIgnoreCase("V3.0")) {
                JOptionPane.showMessageDialog(null, "Fatal Error - Incorrect dialog.tlk version. This program is only for Neverwinter Nights.", "Error", 0);
                System.exit(0);
            }
            Filereader.readInt(TLKFile);
            numentries = Filereader.readInt(TLKFile);
            progressbar.ProgressBar.setMinimum(0);
            progressbar.ProgressBar.setMaximum(numentries);
            progressbar.ProgressBar.setValue(0);
            entryoffset = Filereader.readInt(TLKFile);
            for(int i = 0; i < numentries; i++) {
                progressbar.ProgressBar.setValue(i);
                TLKFile.seek(20 + i * 40);
                TLKFile.skipBytes(28);
                int offset = Filereader.readInt(TLKFile);
                int datasize = Filereader.readInt(TLKFile);
                TLKFile.seek(offset + entryoffset);
                String tempdatastring = Filereader.readString(TLKFile, datasize);
                TLKMap.add(i, tempdatastring);
            }
            TLKFile.close();
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - Error reading dialog.tlk.", "Error", 0);
            System.exit(0);
        }
        if(alttlk) {
            AddCustomTLK();
        }
        TLKMap.trimToSize();
        progressbar.setVisible(false);
        progressbar.dispose();

		bad_string = (String)TLKMap.get(0);

		ResourceFactory resFactory = new ResourceFactory();
		FeatMap.InitializeStatics(this, resFactory);
		SkillMap.InitializeStatics(this, resFactory);
		SpellMap.InitializeStatics(this, resFactory);
        createmenu = new CreateMenu(this, resFactory);

		try {
			resFactory.getResourceAs2DA("classes");
			resFactory.getResourceAs2DA("racialtypes");
		}
		catch (IOException ioe) {}

        createmenu.show();
    }

	public String getEntry(String numStr) {
		return getEntry(ChkHex.ChkHex(numStr));
	}
    
    public String getEntry(int num) {
		String tlkString = null;

		try {
			if (num > 0x00999999) {
				num -= 0x01000000;
				tlkString = (String)AltTLKMap.get(num);
			}
		}
		catch (Exception e) {}

		if (tlkString == null) {
			try {
				tlkString = (String)TLKMap.get(num);
			}
			catch (Exception e) {}

			if (tlkString == null)
				tlkString = bad_string;
		}

		return tlkString;
    }
    
    public void close()
    throws IOException {
        if(TLKFile != null)
            TLKFile.close();
    }
    
    private void AddCustomTLK() {
        progressbar.ProgressText.setText("Loading " + AltTLKName + "...");
        AltTLKMap = new ArrayList();
        try {
            TLKFile = new RandomAccessFile(new File(ALTTLKFILE), "r");
            String signature = Filereader.readString(TLKFile, 4);
            String version = Filereader.readString(TLKFile, 4);
            if(!signature.equalsIgnoreCase("TLK ") || !version.equalsIgnoreCase("V3.0")) {
                JOptionPane.showMessageDialog(null, "Fatal Error - Incorrect tlk version in " +AltTLKName+". This program is only for Neverwinter Nights.", "Error", 0);
                System.exit(0);
            }
            Filereader.readInt(TLKFile);
            numentries = Filereader.readInt(TLKFile);
            progressbar.ProgressBar.setMinimum(0);
            progressbar.ProgressBar.setMaximum(numentries);
            progressbar.ProgressBar.setValue(0);
            entryoffset = Filereader.readInt(TLKFile);
            //int q = 0x01000000;
            for(int i = 0; i < numentries; i++) {
                progressbar.ProgressBar.setValue(i);
                TLKFile.seek(20 + i * 40);
                TLKFile.skipBytes(28);
                int offset = Filereader.readInt(TLKFile);
                int datasize = Filereader.readInt(TLKFile);
                TLKFile.seek(offset + entryoffset);
                String tempdatastring = Filereader.readString(TLKFile, datasize);
                //TLKMap.put(new Integer(i+q), tempdatastring);
                AltTLKMap.add(i, tempdatastring);
            }
            TLKFile.close();
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - Error reading "+AltTLKName+".", "Error", 0);
            System.exit(0);
        }
        
    }
    
    public static CreateMenu getCreateMenu() {
        return createmenu;
    }
    
    private String AltTLKName;
    private String NEWTLKFILE;
    private String ALTTLKFILE;
    private RandomAccessFile TLKFile;
    private RandomAccessFile AltTLKFile;
    public int numentries;
    private int entryoffset;
    ProgressBar progressbar;
    //public Map TLKMap;
    public ArrayList TLKMap;
    public ArrayList AltTLKMap;
	private String bad_string;
    //public Map TLKMap;
    private static CreateMenu createmenu;
}

