/*
 * PortraitMenu1.java
 *
 * Created on April 12, 2003, 1:06 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.LinkedList;
import java.util.prefs.Preferences;
import javax.swing.*;
import CharacterCreator.defs.*;
/**
 *
 * @author  James
 */
public class PortraitMenu extends javax.swing.JFrame {
    
    public class Portrait extends JPanel {
        
        public void CreateButton() {
            PicButton = new JButton();
            add(PicButton);
            setLayout(new BorderLayout());
            PicButton.setName("PicButton");
            setAutoscrolls(true);
            PicButton.setIcon(new ImageIcon("/resource/blank.jpg"));
            PicButton.setHorizontalAlignment(2);
            PicButton.setMargin(new Insets(0, 0, 0, 0));
            PicButton.setVerticalAlignment(1);
            PicButton.setVerticalTextPosition(1);
            PicButton.addActionListener(new ActionListener() {
                
                public void actionPerformed(ActionEvent evt) {
                    PicButtonActionPerformed(evt);
                }
                
            });
            int num = getComponentCount();
            String stuff = getComponent(0).getName();
        }
        
        private void PicButtonActionPerformed(ActionEvent evt) {
            OKButton.setEnabled(true);
            javax.swing.Icon test = PicButton.getIcon();
            if (test instanceof ImageIcon) {
				if (isBIFpic) {
					String BIFFILENAME = "po_" + tmpname + "l.tga";
					try {
						InfoText.setText(BIFFILENAME);

						File tempImage = RESFAC.TempImageFile(BIFFILENAME);
						if (tempImage != null) {
							TargaImage curtga = new TargaImage(tempImage);
							CurrentPortrait.setIcon(new ImageIcon(curtga.getImage()));
							BICPortraitname = "po_" + tmpname;
							CURRENTPORTRAIT = tempImage.getParent() + FileDelim + baseFilename;
							OKButton.setEnabled(true);
						}
					}
					catch(IOException err) {
						JOptionPane.showMessageDialog(null, "Fatal Error - " + BIFFILENAME + " not found. Your data files might be corrupt.", "Error", 0);
						System.exit(0);
					}
				}
				else {
                    String PORTRAIT = qualifiedName;
                    if(qualifiedName.toUpperCase().endsWith("M.TGA")) {
                        CURRENTPORTRAIT = PORTRAIT;
                        PORTRAIT = qualifiedName.substring(0, qualifiedName.length() - 5) + "l.tga";
                    }

					ImageIcon icon = null;
					try {
						icon = new ImageIcon(
								new TargaImage(new File(PORTRAIT)).getImage()
							);
					}
					catch (IOException e) {
						System.out.println("Invalid Icon: " + PORTRAIT);
						icon = null;
					}

					CurrentPortrait.setIcon(icon);
                    BICPortraitname = baseFilename.substring(0, baseFilename.length() - 4);
                    InfoText.setText(PORTRAIT.substring(PORTRAIT.lastIndexOf(FileDelim) + 1));
                    if(BICPortraitname.endsWith("m") || BICPortraitname.endsWith("l")
							|| BICPortraitname.endsWith("h") || BICPortraitname.endsWith("s")
							|| BICPortraitname.endsWith("t")) {
                        BICPortraitname = BICPortraitname.substring(0, BICPortraitname.length() - 1);
                    }
                    OKButton.setEnabled(true);
                }
			}
        }
        
        String baseFilename;
        String tmpname;
        boolean isBIFpic;
        public String qualifiedName;
        
        public Portrait(String dir, String imageFilename, boolean isBifpic, String pretmpname) {
            baseFilename = imageFilename;
            qualifiedName = dir + imageFilename;
            tmpname = pretmpname;
            isBIFpic = isBifpic;

            CreateButton();

			try {
                File targetfile = new File(qualifiedName);
                TargaImage tgapic = new TargaImage(targetfile);
                Dimension tgasize = tgapic.getSize();
                double tmpsize = (new Float(tgasize.height)).doubleValue() * (new Float(0.78125D)).doubleValue();
                tgapic.setHeight((int)tmpsize);
                PicButton.setIcon(new ImageIcon(tgapic.getImage()));
			}
			catch (IOException e) {
				System.out.println("Invalid image: " + qualifiedName);
				qualifiedName = "null";
			}
        }
    }
    
    public class ImageFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            String upperCaseName = name.toUpperCase();
            return upperCaseName.endsWith("M.TGA");
        }
    }
    
    /** Creates new form PortraitMenu1 */
    public PortraitMenu() {
        menucreate = TLKFactory.getCreateMenu();
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String NWNDir = prefs.get("GameDir", null);
		FileDelim = prefs.get("FileDelim", null);
        directory = NWNDir + "portraits" + FileDelim;
        menucreate.BlockWindow(true);
        initComponents();
        PortraitScrollPane.setViewportView(PortraitsWindow);
        OKButton.setEnabled(false);
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        
        try {
            portraitmap = RESFAC.getResourceAs2DA("portraits");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - portraits.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }

        CURRENTPORTRAIT = "resource/portrait.jpg";
        java.net.URL targurl = getClass().getResource(CURRENTPORTRAIT);
        CurrentPortrait.setIcon(new ImageIcon(targurl));
        menucreate = TLKFactory.getCreateMenu();
        sexlock = true;
        racelock = true;
        
        RedoPortraits(-1);
        
        
        pack();
    }
    
    public void RedoPortraits(int screen) {
        //PortraitObjects = new LinkedList();
        if(screen == -1) {
            ScreenNum = 1;
            TotalPortrait = CalculateValidPortraits();
            screen = 1;
        }
        int CurrentNum = 0;
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        PortraitsWindow.removeAll();
        PortraitsWindow.repaint();
        String filenames[] = (new File(directory)).list(new ImageFilter());
        String sexstr = "";
        int sex = ((Integer)menucreate.MainCharData[0].get(new Integer(0))).intValue();
        int race = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        int numbif = 0;
        for(int p = 0; p < portraitmap.length; p++) {
            String basepicfilename = portraitmap[p][1];
            if(basepicfilename != null && portraitmap[p][2] != null && portraitmap[p][3] != null) {
				basepicfilename = basepicfilename.toLowerCase();
                if(!basepicfilename.startsWith("plc")
						&& !basepicfilename.equalsIgnoreCase("door01_")
						&& (Integer.parseInt(portraitmap[p][2]) == sex && sexlock || !sexlock)
						&& (Integer.parseInt(portraitmap[p][3]) == race && racelock || !racelock)
						&& CheckPortrait(directory, "po_" + basepicfilename)) {
                    String picFilename = "po_" + basepicfilename + "m.tga";
                    CurrentNum++;
                    if((CurrentNum < ((50*screen)+1)) && CurrentNum > ((50*screen)-50)) {
                        try {
							File tempImage = RESFAC.TempImageFile(picFilename);
							if (tempImage != null) {
                                Portrait port = new Portrait(tempImage.getParent() + FileDelim, tempImage.getName(), true, basepicfilename);
                                port.getComponent(0).setSize(64, 100);
                                PortraitsWindow.add(port, -1);
                                numbif++;
							}
                        }
                        catch(IOException err) {
                            JOptionPane.showMessageDialog(null, "Error reading " + picFilename + ". Out of Memory. Error: "+err, "Error", 0);
                            System.exit(0);
                        }
                    }
                }
            }
        }
        for(int i = 0; i < filenames.length; i++) {
            CurrentNum++;
            if((CurrentNum < (50*screen)) && CurrentNum > ((50*screen)-50)) {
                Portrait port = new Portrait(directory, filenames[i], false, "");
                port.getComponent(0).setSize(64, 100);
                PortraitsWindow.add(port, -1);
            }
        }
        ForwardButton.setEnabled(true);
        BackButton.setEnabled(true);
        if(screen == 1) {
            BackButton.setEnabled(false);
        }
        if(screen == TotalScreen) {
            ForwardButton.setEnabled(false);
        }
        //int totalpics = filenames.length + numbif;
        //if(totalpics < 51) {
        //    for(int o = 0; o < 50 - totalpics; o++) {
        //        JPanel blankframe = new JPanel();
        //       blankframe.setSize(64, 128);
        //        PortraitsWindow.add(blankframe, -1);
        //    }
        //
        //}
        /*int GridRows = roundup(new Integer(totalpics), new Integer(10));
        if(GridRows == 0)
            GridRows = 1;
        //PortraitsWindow.setPreferredSize(new Dimension(640, GridRows * 100));
        Dimension area = PortraitsWindow.getSize();
        double num3 = area.getHeight();
        double num4 = area.getWidth();*/
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        Runtime r = Runtime.getRuntime();
        r.gc();
    }
    public int CalculateValidPortraits() {
        int portraitnum = 0;
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        File tmpfile = new File(directory);
        if(!tmpfile.exists()) {
            JOptionPane.showMessageDialog(null, "Fatal Error - No portraits directory. Please create a new portraits directory in your NWN directory.", "Error", 0);
            System.exit(0);
        }
        String filenames[] = (tmpfile.list(new ImageFilter()));
        String sexstr = "";
        int sex = ((Integer)menucreate.MainCharData[0].get(new Integer(0))).intValue();
        int race = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        int numbif = 0;
        for(int p = 0; p < portraitmap.length; p++) {
            String basepicfilename = portraitmap[p][1];
            if(basepicfilename != null && portraitmap[p][2] != null && portraitmap[p][3] != null) {
				basepicfilename = basepicfilename.toLowerCase();
                if (!basepicfilename.startsWith("plc")
						&& !basepicfilename.equalsIgnoreCase("door01_")
						&& (Integer.parseInt(portraitmap[p][2]) == sex && sexlock || !sexlock)
						&& (Integer.parseInt(portraitmap[p][3]) == race && racelock || !racelock)
						&& CheckPortrait(directory, "po_" + basepicfilename)) {
                    portraitnum++;
                }
            }
        }
        for(int i = 0; i < filenames.length; i++) {
            portraitnum++;
        }
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        TotalScreen = roundup(new Integer(portraitnum), new Integer(50));
        return portraitnum;
    }
    
    public void ChangeCurrentPortrait() {
		try {
			TargaImage deftga = new TargaImage(new File(CURRENTPORTRAIT));
			CurrentPortrait.setIcon(new ImageIcon(deftga.getImage()));
		}
		catch (IOException e) {
			System.out.println("Invalid image: " + CURRENTPORTRAIT);
		}
    }
    
	// TODO: More case twiddling
    public boolean CheckPortrait(String resdir, String basepicname) {
        return RESFAC.FileExists(resdir, basepicname.toLowerCase() + "h.tga") && RESFAC.FileExists(resdir, basepicname.toLowerCase() + "l.tga") && RESFAC.FileExists(resdir, basepicname.toLowerCase() + "m.tga") && RESFAC.FileExists(resdir, basepicname.toLowerCase() + "s.tga") && RESFAC.FileExists(resdir, basepicname.toLowerCase() + "t.tga");
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        CurrentPortrait = new javax.swing.JLabel();
        RaceCheck = new javax.swing.JCheckBox();
        SexCheck = new javax.swing.JCheckBox();
        PortraitScrollPane = new javax.swing.JScrollPane();
        PortraitsWindow = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        InfoText = new javax.swing.JTextField();
        FirstButton = new javax.swing.JButton();
        BackButton = new javax.swing.JButton();
        ForwardButton = new javax.swing.JButton();
        LastButton = new javax.swing.JButton();
        jPanel8 = new javax.swing.JPanel();
        jPanel9 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Portraits");
        setName("PortFrame");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        CurrentPortrait.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/portrait.jpg")));
        CurrentPortrait.setVerticalAlignment(javax.swing.SwingConstants.TOP);
        CurrentPortrait.setMaximumSize(new java.awt.Dimension(128, 200));
        CurrentPortrait.setMinimumSize(new java.awt.Dimension(128, 200));
        CurrentPortrait.setPreferredSize(new java.awt.Dimension(128, 200));
        CurrentPortrait.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        getContentPane().add(CurrentPortrait, gridBagConstraints);

        RaceCheck.setSelected(true);
        RaceCheck.setText("Lock To Race");
        RaceCheck.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RaceCheckActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        getContentPane().add(RaceCheck, gridBagConstraints);

        SexCheck.setSelected(true);
        SexCheck.setText("Lock to Gender");
        SexCheck.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SexCheckActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        getContentPane().add(SexCheck, gridBagConstraints);

        PortraitScrollPane.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        PortraitScrollPane.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_NEVER);
        PortraitScrollPane.setMinimumSize(new java.awt.Dimension(640, 500));
        PortraitScrollPane.setPreferredSize(new java.awt.Dimension(658, 500));
        PortraitScrollPane.setAutoscrolls(true);
        PortraitsWindow.setLayout(new java.awt.GridLayout(0, 10));

        PortraitsWindow.setMaximumSize(new java.awt.Dimension(640, 500));
        PortraitsWindow.setMinimumSize(new java.awt.Dimension(640, 500));
        PortraitScrollPane.setViewportView(PortraitsWindow);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 6;
        gridBagConstraints.gridheight = 9;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PortraitScrollPane, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.SOUTH;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(CancelButton, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 12;
        getContentPane().add(jPanel3, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel4, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        getContentPane().add(jPanel5, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel6, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        getContentPane().add(jPanel7, gridBagConstraints);

        InfoText.setBackground(new java.awt.Color(204, 204, 204));
        InfoText.setFont(new java.awt.Font("Dialog", 0, 10));
        InfoText.setForeground(new java.awt.Color(255, 0, 0));
        InfoText.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        InfoText.setBorder(null);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.SOUTH;
        getContentPane().add(InfoText, gridBagConstraints);

        FirstButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/first.gif")));
        FirstButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                FirstButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 11;
        getContentPane().add(FirstButton, gridBagConstraints);

        BackButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/back.gif")));
        BackButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BackButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 11;
        getContentPane().add(BackButton, gridBagConstraints);

        ForwardButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/forward.gif")));
        ForwardButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ForwardButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(ForwardButton, gridBagConstraints);

        LastButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/last.gif")));
        LastButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LastButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 8;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(LastButton, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.ipadx = 4;
        gridBagConstraints.insets = new java.awt.Insets(0, 85, 0, 85);
        getContentPane().add(jPanel8, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.insets = new java.awt.Insets(0, 25, 0, 25);
        getContentPane().add(jPanel9, gridBagConstraints);

        pack();
    }//GEN-END:initComponents
    
    private void LastButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LastButtonActionPerformed
        // Add your handling code here:
        RedoPortraits(TotalScreen);
        pack();
    }//GEN-LAST:event_LastButtonActionPerformed
    
    private void ForwardButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ForwardButtonActionPerformed
        // Add your handling code here:
        RedoPortraits(++ScreenNum);
        pack();
    }//GEN-LAST:event_ForwardButtonActionPerformed
    
    private void BackButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BackButtonActionPerformed
        // Add your handling code here:
        RedoPortraits(--ScreenNum);
        pack();
    }//GEN-LAST:event_BackButtonActionPerformed
    
    private void FirstButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_FirstButtonActionPerformed
        // Add your handling code here:
        RedoPortraits(1);
        pack();
    }//GEN-LAST:event_FirstButtonActionPerformed
    
    private void RaceCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RaceCheckActionPerformed
        // Add your handling code here:
        if(racelock)
            racelock = false;
        else
            if(!racelock)
                racelock = true;
        RedoPortraits(-1);
        pack();
    }//GEN-LAST:event_RaceCheckActionPerformed
    
    private void SexCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SexCheckActionPerformed
        // Add your handling code here:
        if(sexlock)
            sexlock = false;
        else
            if(!sexlock)
                sexlock = true;
        RedoPortraits(-1);
        pack();
    }//GEN-LAST:event_SexCheckActionPerformed
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
		try {
			TargaImage deftg = new TargaImage(new File(CURRENTPORTRAIT));
			System.out.println("Filename according to the bic: " + BICPortraitname);
			Dimension tgasize = deftg.getSize();
			double tmpsize = (new Float(tgasize.height)).doubleValue() * (new Float(0.78125D)).doubleValue();
			deftg.setHeight((int)tmpsize);
			java.awt.Image tempportimage = deftg.getImage();
			menucreate.CharPortrait.setIcon(new ImageIcon(tempportimage));
			menucreate.MainCharData[2] = new HashMap();
			menucreate.MainCharData[2].put(new Integer(0), BICPortraitname);
			menucreate.BlockWindow(false);
			setVisible(false);
			dispose();

			// Add your handling code here:
			CreateMenu menucreate = TLKFactory.getCreateMenu();
			menucreate.ClassButton.setEnabled(true);
		}
		catch (IOException e) {
			System.out.println("Invalid Image: " + CURRENTPORTRAIT);
		}
    }//GEN-LAST:event_OKButtonActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm
    
    public int roundup(Integer numerator, Integer denominator) {
        int result = 0;
        float xvar = numerator.floatValue() / denominator.floatValue();
        if(xvar - (float)Math.round(xvar) > 0.0F)
            result = Math.round(xvar) + 1;
        else
            if(xvar - (float)Math.round(xvar) < 0.0F)
                result = Math.round(xvar);
            else
                if(xvar - (float)Math.round(xvar) == 0.0F)
                    result = (int)xvar;
        return result;
    }
    //This number indicates the current screen number
    private int ScreenNum;
    //This number indicates the total number of screens
    private int TotalScreen;
    //This number indicates the current total of portraits
    private int TotalPortrait;
    
    private LinkedList PortraitObjects;
    public String BICPortraitname;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private CreateMenu menucreate;
    public String[][] portraitmap;
    Component TargPortrait;
    String directory;
    boolean sexlock;
    boolean racelock;
    private JButton PicButton;
    public String CURRENTPORTRAIT;
    public String FILENAME;
	public String FileDelim;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton BackButton;
    private javax.swing.JButton CancelButton;
    private javax.swing.JLabel CurrentPortrait;
    private javax.swing.JButton FirstButton;
    private javax.swing.JButton ForwardButton;
    private javax.swing.JTextField InfoText;
    private javax.swing.JButton LastButton;
    private javax.swing.JButton OKButton;
    private javax.swing.JScrollPane PortraitScrollPane;
    private javax.swing.JPanel PortraitsWindow;
    private javax.swing.JCheckBox RaceCheck;
    private javax.swing.JCheckBox SexCheck;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    // End of variables declaration//GEN-END:variables
    
}
