/*
 * SettingsMenu.java
 *
 * Created on March 9, 2003, 9:44 AM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.filechooser.FileFilter;
import java.util.Vector;

/**
 *
 * @author  James
 */
public class SettingsMenu extends javax.swing.JFrame {
    
    /** Creates new form SettingsMenu */
    public SettingsMenu() {
        TLKEnabled = false;
        AltTLKEnabled = true;
        HakVectorList = new Vector();
        Preferences prefs = Preferences.userNodeForPackage(getClass());
        initComponents();
        
        
		FileDelim = prefs.get("FileDelim", null);
        String TLKPref = prefs.get("TLKDefault", null);
        String TLKFilePref = prefs.get("TLKFile", null);
        if(TLKPref != null && TLKPref.equalsIgnoreCase("FALSE")) {
            TLKEnabled = true;
            TLKCheck.setSelected(false);
            resettlkstuff();
            if(TLKFilePref != null) TLKText.setText(TLKFilePref);
        } else {
            resettlkstuff();
        }

        String AltTLKPref = prefs.get("AltTLKDefault", null);
        String AltTLKFilePref = prefs.get("AltTLKFile", null);                
        if(AltTLKPref != null && AltTLKPref.equalsIgnoreCase("TRUE")) {
            AltTLKEnabled = false;
            AltTLKCheck.setSelected(true);
            AltTLKName = prefs.get("AltTLKName", null);
            resetalttlkstuff();
            if(AltTLKFilePref != null) AltTLKText.setText(AltTLKFilePref);
        } else {
            resetalttlkstuff();
        }        
        
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        
        //HAKLIST INITIALIZATION
        java.awt.GridBagConstraints gridBagConstraints;
        HakList = new javax.swing.JList(HakVectorList);
        HakList.setSelectedIndex(0);
        HakList.setModel(new DefaultListModel());
        HakList.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        HakScroll.setViewportView(HakList);
        
        String GameDir = prefs.get("GameDir", null);
        if(GameDir != null && (new File(GameDir)).exists()) {
            NWNDirText.setText(GameDir);
        } else {
            NWNDirText.setText("C:\\NeverwinterNights\\NWN\\");
            prefs.put("GameDir", "C:\\NeverwinterNights\\NWN\\");
        }
        String HakNumStr = prefs.get("HakNum", null);
        
        if(HakNumStr != null) {
            System.out.println("Number of haks: " + HakNumStr);
            int HakNum = new Integer(HakNumStr).intValue();
            for(int i = 0; i < HakNum; i++) {
                String hakstr = "HakFile" + i;
                String newhak = prefs.get(hakstr, null);
                if(newhak != null) {
                    System.out.println("Hak " + i + " is " + newhak);
                } else {
                    System.out.println("Hak " + i + " missing data");
                }
                HakVectorList.add(prefs.get(hakstr, null));
            }
            HakList.setListData(HakVectorList);
        } else {
            System.out.println("No haks");
        }
        
        pack();
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        NWNDirLabel = new javax.swing.JLabel();
        NWNDirText = new javax.swing.JTextField();
        DefNWNDirBtn = new javax.swing.JButton();
        NWNDirFile = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        HakLabel = new javax.swing.JLabel();
        AddButton = new javax.swing.JButton();
        RemoveButton = new javax.swing.JButton();
        MoveUpButton = new javax.swing.JButton();
        MoveDownButton = new javax.swing.JButton();
        HakScroll = new javax.swing.JScrollPane();
        TLKLabel = new javax.swing.JLabel();
        TLKText = new javax.swing.JTextField();
        TLKCheck = new javax.swing.JCheckBox();
        DefTLKBtn = new javax.swing.JButton();
        TLKFile = new javax.swing.JButton();
        jPanel8 = new javax.swing.JPanel();
        jPanel9 = new javax.swing.JPanel();
        AltTLKLabel = new javax.swing.JLabel();
        AltTLKText = new javax.swing.JTextField();
        AltTLKCheck = new javax.swing.JCheckBox();
        AltTLKFile = new javax.swing.JButton();
        jPanel10 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        NWNDirLabel.setText("NWN Directory");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(NWNDirLabel, gridBagConstraints);

        NWNDirText.setText("C:\\NeverwinterNights\\NWN\\");
            NWNDirText.setPreferredSize(new java.awt.Dimension(350, 20));
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 2;
            gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
            getContentPane().add(NWNDirText, gridBagConstraints);

            DefNWNDirBtn.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/Undo16.gif")));
            DefNWNDirBtn.setMargin(new java.awt.Insets(0, 0, 0, 0));
            DefNWNDirBtn.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    DefNWNDirBtnActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 4;
            gridBagConstraints.gridy = 2;
            getContentPane().add(DefNWNDirBtn, gridBagConstraints);

            NWNDirFile.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/Save16.gif")));
            NWNDirFile.setMargin(new java.awt.Insets(0, 0, 0, 0));
            NWNDirFile.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    NWNDirFileActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 2;
            getContentPane().add(NWNDirFile, gridBagConstraints);

            OKButton.setText("OK");
            OKButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    OKButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 20;
            gridBagConstraints.ipadx = 20;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(OKButton, gridBagConstraints);

            CancelButton.setText("Cancel");
            CancelButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    CancelButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 20;
            gridBagConstraints.gridwidth = 3;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
            getContentPane().add(CancelButton, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            getContentPane().add(jPanel1, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            getContentPane().add(jPanel2, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 21;
            getContentPane().add(jPanel3, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 6;
            gridBagConstraints.gridy = 0;
            getContentPane().add(jPanel4, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 2;
            gridBagConstraints.gridy = 0;
            getContentPane().add(jPanel5, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 3;
            getContentPane().add(jPanel6, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 9;
            getContentPane().add(jPanel7, gridBagConstraints);

            HakLabel.setText("Hak Files (If any)");
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 4;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(HakLabel, gridBagConstraints);

            AddButton.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
            AddButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/plus1.gif")));
            AddButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
            AddButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    AddButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 5;
            gridBagConstraints.gridwidth = 2;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(AddButton, gridBagConstraints);

            RemoveButton.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
            RemoveButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/minus1.gif")));
            RemoveButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
            RemoveButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    RemoveButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 6;
            gridBagConstraints.gridwidth = 2;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(RemoveButton, gridBagConstraints);

            MoveUpButton.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
            MoveUpButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/up.gif")));
            MoveUpButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
            MoveUpButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    MoveUpButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 7;
            gridBagConstraints.gridwidth = 2;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(MoveUpButton, gridBagConstraints);

            MoveDownButton.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
            MoveDownButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/down.gif")));
            MoveDownButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
            MoveDownButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    MoveDownButtonActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 8;
            gridBagConstraints.gridwidth = 2;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
            getContentPane().add(MoveDownButton, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 5;
            gridBagConstraints.gridheight = 4;
            gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
            getContentPane().add(HakScroll, gridBagConstraints);

            TLKLabel.setText("TLK File");
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 17;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(TLKLabel, gridBagConstraints);

            TLKText.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    TLKTextActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 18;
            gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
            getContentPane().add(TLKText, gridBagConstraints);

            TLKCheck.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
            TLKCheck.setSelected(true);
            TLKCheck.setText("Use Default TLK?");
            TLKCheck.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    TLKCheckActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 15;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(TLKCheck, gridBagConstraints);

            DefTLKBtn.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/Undo16.gif")));
            DefTLKBtn.setMargin(new java.awt.Insets(0, 0, 0, 0));
            DefTLKBtn.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    DefTLKBtnActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 4;
            gridBagConstraints.gridy = 18;
            getContentPane().add(DefTLKBtn, gridBagConstraints);

            TLKFile.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/Save16.gif")));
            TLKFile.setMargin(new java.awt.Insets(0, 0, 0, 0));
            TLKFile.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    TLKFileActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 18;
            getContentPane().add(TLKFile, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 11;
            getContentPane().add(jPanel8, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 16;
            getContentPane().add(jPanel9, gridBagConstraints);

            AltTLKLabel.setText("Custom TLK");
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 12;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(AltTLKLabel, gridBagConstraints);

            AltTLKText.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    AltTLKTextActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 13;
            gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
            getContentPane().add(AltTLKText, gridBagConstraints);

            AltTLKCheck.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
            AltTLKCheck.setText("Use Custom TLK?");
            AltTLKCheck.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    AltTLKCheckActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 10;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            getContentPane().add(AltTLKCheck, gridBagConstraints);

            AltTLKFile.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/Save16.gif")));
            AltTLKFile.setMargin(new java.awt.Insets(0, 0, 0, 0));
            AltTLKFile.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    AltTLKFileActionPerformed(evt);
                }
            });

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 3;
            gridBagConstraints.gridy = 13;
            getContentPane().add(AltTLKFile, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 19;
            getContentPane().add(jPanel10, gridBagConstraints);

            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 14;
            getContentPane().add(jPanel11, gridBagConstraints);

            pack();
        }//GEN-END:initComponents

    private void AltTLKCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AltTLKCheckActionPerformed
        // Add your handling code here:
        if(AltTLKEnabled) {
            AltTLKEnabled = false;
        } else
            if(!AltTLKEnabled) {
                AltTLKEnabled = true;
            }
        resetalttlkstuff();
        pack();        
    }//GEN-LAST:event_AltTLKCheckActionPerformed

    private void AltTLKTextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AltTLKTextActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_AltTLKTextActionPerformed

    private void AltTLKFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AltTLKFileActionPerformed
        // Add your handling code here:
        JFileChooser fc = new JFileChooser();
        
        fc.setFileFilter(new FileFilter() {
            
            public boolean accept(File pathname) {
                if(pathname.isDirectory()) {
                    return true;
                }
                if(pathname.isFile() && pathname.getName().endsWith(".tlk")) {
                    return true;
                }
                else {
                    return false;
                }
            }
            
            public String getDescription() {
                return "TLK File";
            }
            
        });
        //        fc.setFileSelectionMode(1);
        if(!NWNDirText.getText().equalsIgnoreCase("") && NWNDirText.getText() != null) {
            if(new File(NWNDirText.getText() + FileDelim + "tlk").exists()) {
                //if(new File(NWNDirText.getText()).exists()) {
                fc.setCurrentDirectory(new File(NWNDirText.getText() + FileDelim + "tlk"));
                //} else {
                //    fc.setCurrentDirectory(new File("C:\\"));
                //}
            } else {
                fc.setCurrentDirectory(new File("C:\\"));
            }
        }
        
        int returnVal = fc.showOpenDialog(this);
        if(returnVal == 0) {
            File hakfile = fc.getSelectedFile();
            AltTLKText.setText(hakfile.getAbsolutePath());
            AltTLKName = hakfile.getName();
            //HakVectorList.add(hakfile.getAbsolutePath());
        }
        //HakList.setListData(HakVectorList);
        pack();        
    }//GEN-LAST:event_AltTLKFileActionPerformed
    
    private void TLKFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TLKFileActionPerformed
        // Add your handling code here:
        JFileChooser fc = new JFileChooser();
        
        fc.setFileFilter(new FileFilter() {
            
            public boolean accept(File pathname) {
                if(pathname.isDirectory()) {
                    return true;
                }
                if(pathname.isFile() && pathname.getName().endsWith(".tlk")) {
                    return true;
                }
                else {
                    return false;
                }
            }
            
            public String getDescription() {
                return "TLK File";
            }
            
        });
        //        fc.setFileSelectionMode(1);
        if(!NWNDirText.getText().equalsIgnoreCase("") && NWNDirText.getText() != null) {
            if(new File(NWNDirText.getText()).exists()) {
                //if(new File(NWNDirText.getText()).exists()) {
                fc.setCurrentDirectory(new File(NWNDirText.getText()));
                //} else {
                //    fc.setCurrentDirectory(new File("C:\\"));
                //}
            } else {
                fc.setCurrentDirectory(new File("C:\\"));
            }
        }
        
        int returnVal = fc.showOpenDialog(this);
        if(returnVal == 0) {
            File hakfile = fc.getSelectedFile();
            TLKText.setText(hakfile.getAbsolutePath());
            //HakVectorList.add(hakfile.getAbsolutePath());
        }
        //HakList.setListData(HakVectorList);
        pack();
    }//GEN-LAST:event_TLKFileActionPerformed
    
    private void DefTLKBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_DefTLKBtnActionPerformed
        // Add your handling code here:
        DoDefTLK();
    }//GEN-LAST:event_DefTLKBtnActionPerformed
    
    private void TLKTextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TLKTextActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_TLKTextActionPerformed
    
    private void TLKCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TLKCheckActionPerformed
        // Add your handling code here:
        if(TLKEnabled) {
            TLKEnabled = false;
        } else
            if(!TLKEnabled) {
                TLKEnabled = true;
            }
        resettlkstuff();
        pack();
    }//GEN-LAST:event_TLKCheckActionPerformed
    
    private void MoveDownButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MoveDownButtonActionPerformed
        // Add your handling code here:
        int currentindex = HakList.getSelectedIndex();
        if(currentindex < HakVectorList.size() - 1) {
            int numindices = HakVectorList.size();
            Object item = HakVectorList.get(currentindex);
            HakVectorList.remove(currentindex);
            HakVectorList.insertElementAt(item, currentindex + 1);
        }
        HakList.setListData(HakVectorList);
        HakList.setSelectedIndex(currentindex + 1);
        HakList.ensureIndexIsVisible(currentindex + 1);
        pack();
    }//GEN-LAST:event_MoveDownButtonActionPerformed
    
    private void MoveUpButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MoveUpButtonActionPerformed
        // Add your handling code here:
        int currentindex = HakList.getSelectedIndex();
        if(currentindex > 0) {
            int numindices = HakVectorList.size();
            Object item = HakVectorList.get(currentindex);
            HakVectorList.remove(currentindex);
            HakVectorList.insertElementAt(item, currentindex - 1);
        }
        HakList.setListData(HakVectorList);
        HakList.setSelectedIndex(currentindex - 1);
        HakList.ensureIndexIsVisible(currentindex - 1);
        pack();
    }//GEN-LAST:event_MoveUpButtonActionPerformed
    
    private void RemoveButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RemoveButtonActionPerformed
        // Add your handling code here:
        int selectedindex = HakList.getSelectedIndex();
        //if(!(selectedindex == null)) {
        if(selectedindex != -1) {
            if(HakVectorList != null) {
                if(HakVectorList.elementAt(selectedindex) != null) {
                    HakVectorList.remove(selectedindex);
                }
            }
        }
        HakList.setListData(HakVectorList);
        pack();
    }//GEN-LAST:event_RemoveButtonActionPerformed
    
    private void AddButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AddButtonActionPerformed
        // Add your handling code here:
        JFileChooser fc = new JFileChooser();

		fc.setMultiSelectionEnabled(true);
        
        fc.setFileFilter(new FileFilter() {
            
            public boolean accept(File pathname) {
                if(pathname.isDirectory()) {
                    return true;
                }
                if(pathname.isFile() && pathname.getName().endsWith(".hak")) {
                    return true;
                }
                else {
                    return false;
                }
            }
            
            public String getDescription() {
                return "HAK File";
            }
            
        });
        //        fc.setFileSelectionMode(1);
        if(!NWNDirText.getText().equalsIgnoreCase("") && NWNDirText.getText() != null) {
            if(new File(NWNDirText.getText()).exists()) {
                if(new File(NWNDirText.getText() + "hak" + FileDelim).exists()) {
                    fc.setCurrentDirectory(new File(NWNDirText.getText() + "hak" + FileDelim));
                } else {
                    fc.setCurrentDirectory(new File(NWNDirText.getText()));
                }
            } else {
                fc.setCurrentDirectory(new File("C:\\"));
            }
        }
        
        int returnVal = fc.showOpenDialog(this);
        if(returnVal == 0) {
            File[] hakfiles = fc.getSelectedFiles();
			for (int ii=0; ii < hakfiles.length; ++ii)
				HakVectorList.add(hakfiles[ii].getAbsolutePath());
        }
        HakList.setListData(HakVectorList);
        pack();
        //System.out.println(HakVectorList.toString());
    }//GEN-LAST:event_AddButtonActionPerformed
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        setVisible(false);
        dispose();
        (new MainMenu()).show();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        Preferences prefs = Preferences.userNodeForPackage(getClass());
        String NWNDIR = NWNDirText.getText();
        String filedelim = prefs.get("FileDelim", null);
        if(!NWNDIR.endsWith(filedelim)) {
            NWNDIR += filedelim;
        }
        prefs.put("GameDir", NWNDIR);
        //prefs.put("HakFile", HakText.getText());
        if(HakVectorList.size() > 0) {
            prefs.put("HakNum", Integer.toString(HakVectorList.size()));
            for(int i = 0; i < HakVectorList.size(); i++) {
                String hakstring = "HakFile" + i;
                prefs.put(hakstring, HakVectorList.get(i).toString());
            }
        } else {
            prefs.put("HakNum", "0");
        }
        
        if(!TLKCheck.isSelected()) {
            prefs.put("TLKDefault", "FALSE");
            prefs.put("TLKFile", TLKText.getText());
        } else {
            prefs.put("TLKDefault", "TRUE");
            prefs.put("TLKFile", "");
        }
        
        if(AltTLKCheck.isSelected()) {
            prefs.put("AltTLKDefault", "TRUE");
            prefs.put("AltTLKFile", AltTLKText.getText());
            //if(AltTLKName != null) {
                prefs.put("AltTLKName", AltTLKName);
            //}
        } else {
            prefs.put("AltTLKDefault", "FALSE");
            prefs.put("AltTLKFile", "");
            prefs.put("AltTLKName", "");
        }
        
        setVisible(false);
        dispose();
        (new MainMenu()).show();
    }//GEN-LAST:event_OKButtonActionPerformed
    
    private void DefNWNDirBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_DefNWNDirBtnActionPerformed
        // Add your handling code here:
        Preferences prefs = Preferences.userNodeForPackage(getClass());
        String filedelim = prefs.get("FileDelim", null);
        NWNDirText.setText(Win32.findNwnRoot().getAbsolutePath() + filedelim);
    }//GEN-LAST:event_DefNWNDirBtnActionPerformed
    
    private void NWNDirFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_NWNDirFileActionPerformed
        // Add your handling code here:
        JFileChooser fc = new JFileChooser();
        fc.setFileFilter(new FileFilter() {
            
            public boolean accept(File pathname) {
                return pathname.isDirectory();
            }
            
            public String getDescription() {
                return "NWN Directory";
            }
            
        });
        fc.setFileSelectionMode(1);
        int returnVal = fc.showOpenDialog(this);
        if(returnVal == 0) {
            File directoryfile = fc.getSelectedFile();
            NWNDirText.setText(directoryfile.getAbsolutePath() + FileDelim);
        }
    }//GEN-LAST:event_NWNDirFileActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
        (new MainMenu()).show();
    }//GEN-LAST:event_exitForm
    
    private void DoDefTLK() {
        if(TLKFilePref != null && new File(TLKFilePref).exists()) {
            TLKText.setText(TLKFilePref);
        } else {
            if(!NWNDirText.getText().equalsIgnoreCase("") && NWNDirText.getText() != null) {
                if(new File(NWNDirText.getText()).exists()) {
                    if(new File(NWNDirText.getText() + "dialog.tlk").exists()) {
                        TLKText.setText(NWNDirText.getText() + "dialog.tlk");
                    } else {
                        TLKText.setText("");
                    }
                }
            }
        }
    }
    
    private void resettlkstuff() {
        if(TLKEnabled) {
            TLKText.setEnabled(true);
            TLKLabel.setEnabled(true);
            TLKFile.setEnabled(true);
            DefTLKBtn.setEnabled(true);
            DoDefTLK();
            pack();
        } else {
            TLKText.setEnabled(false);
            TLKLabel.setEnabled(false);
            TLKFile.setEnabled(false);
            DefTLKBtn.setEnabled(false);
            TLKText.setText("");
            pack();
        }
    }
    
    private void resetalttlkstuff() {
        if(!AltTLKEnabled) {
            AltTLKText.setEnabled(true);
            AltTLKLabel.setEnabled(true);
            AltTLKFile.setEnabled(true);
            //AltDefTLKBtn.setEnabled(true);
            //DoDefTLK();
            pack();
        } else {
            AltTLKText.setEnabled(false);
            AltTLKLabel.setEnabled(false);
            AltTLKFile.setEnabled(false);
            //AltDefTLKBtn.setEnabled(false);
            AltTLKText.setText("");
            pack();
        }
    }    
    /**
     * @param args the command line arguments
     */
    
    //    public static void main(String args[]) {
    //        (new SettingsMenu_1()).show();
    //    }
    
	private String FileDelim;
    private String TLKFilePref;
    private boolean TLKEnabled;
    private String AltTLKFilePref;
    private boolean AltTLKEnabled;
    private final Vector HakVectorList;
    private javax.swing.JList HakList;
    private String AltTLKName;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton AddButton;
    private javax.swing.JCheckBox AltTLKCheck;
    private javax.swing.JButton AltTLKFile;
    private javax.swing.JLabel AltTLKLabel;
    private javax.swing.JTextField AltTLKText;
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton DefNWNDirBtn;
    private javax.swing.JButton DefTLKBtn;
    private javax.swing.JLabel HakLabel;
    private javax.swing.JScrollPane HakScroll;
    private javax.swing.JButton MoveDownButton;
    private javax.swing.JButton MoveUpButton;
    private javax.swing.JButton NWNDirFile;
    private javax.swing.JLabel NWNDirLabel;
    private javax.swing.JTextField NWNDirText;
    private javax.swing.JButton OKButton;
    private javax.swing.JButton RemoveButton;
    private javax.swing.JCheckBox TLKCheck;
    private javax.swing.JButton TLKFile;
    private javax.swing.JLabel TLKLabel;
    private javax.swing.JTextField TLKText;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
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
