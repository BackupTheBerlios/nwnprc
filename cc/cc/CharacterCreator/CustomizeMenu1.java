/*
 * CustomizeMenu1.java
 *
 * Created on March 17, 2003, 7:00 PM
 */

package CharacterCreator;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.LinkedList;
import javax.swing.JOptionPane;
import java.awt.*;
//import CharacterCreator.java3d.Display;
//import CharacterCreator.java3d.loader.AnimationBehavior;
//import CharacterCreator.java3d.loader.Model;
//import CharacterCreator.java3d.loader.NWNLoader;
//import CharacterCreator.java3d.loader.Walkmesh;
import javax.vecmath.Vector3d;
import java.io.File;
import java.net.*;
//import javax.media.j3d.*;
//import com.sun.j3d.loaders.Scene;
//import CharacterCreator.java3d.traverser.*;
import CharacterCreator.defs.*;
/**
 *
 * @author  James
 */
public class CustomizeMenu1 extends javax.swing.JFrame {
    
    /** Creates new form CustomizeMenu1 */
    public CustomizeMenu1() {
        isinitialized = false;
        initComponents();
        menucreate = TLKFactory.getCreateMenu();
        menucreate.BlockWindow(true);
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        
        
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        
        
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        menucreate.MainCharData[17] = new HashMap();
        menucreate.MainCharData[17].put(new Integer(0), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(1), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(2), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(3), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(4), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(5), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(6), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(7), new Integer(1));
        menucreate.MainCharData[17].put(new Integer(8), new Integer(1));
        try {
            appmap = RESFAC.getResourceAs2DA("appearance");
            wingmap = RESFAC.getResourceAs2DA("wingmodel");
            tailmap = RESFAC.getResourceAs2DA("tailmodel");            
            //}
        }
        catch (IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - appearance.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        head = 1;
        phenotype = 0;
        wing = 0;
        tail = 0;
        PhenotypeCombo.addItem(makeObj("Normal"));
        PhenotypeCombo.addItem(makeObj("Large"));
        int p;
        for(p = 0; p<wingmap.length; p++) {
            WingsCombo.addItem(makeObj(wingmap[p][1]));
        }
        for(p = 0; p<tailmap.length; p++) {
            TailCombo.addItem(makeObj(tailmap[p][1]));
        }        
        appearancelist = new LinkedList();
        race = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        String appearancestr = menucreate.MainCharDataAux[1][racialtypes.Appearance];
        //Integer appnum = new Integer(((String)menucreate.MainCharData[1].get(new Integer(racialtypes.Appearance))));
        appearance = Integer.parseInt(menucreate.MainCharDataAux[1][racialtypes.Appearance]);
        //System.out.println("Appearance: " + appearance);

        
        
        
        for(int j = 0; j<appmap.length; j++) {
            if(appmap[j][app.STRING_REF] != null) {
                String intnum = appmap[j][app.STRING_REF];
                String appnumber = appmap[j][0];
                appearancelist.add(appnumber);
                AppearanceCombo.addItem(makeObj(TLKFAC.getEntry(new Integer(intnum).intValue())));
            } else {
                if(appmap[j][1] != null) {
                    String intnum = appmap[j][app.LABEL];
                    String appnumber = appmap[j][0];
                    appearancelist.add(appnumber);
                    AppearanceCombo.addItem(makeObj(intnum));
                }
            }
        }
        //System.out.println("Appearance: " + appearance);
        AppearanceCombo.setSelectedIndex(appearancelist.indexOf(menucreate.MainCharDataAux[1][racialtypes.Appearance]));
        
        isinitialized = true;
        doheadcombobox();
        //race = appmap[appearance].get(new Integer(
        //THIS IS ALL CODE FOR FUTURE 3D STUFF
        /*try {
            display = new Display();
            //ModelPanel.add(display);
            display.setSize(300,400);
            java.awt.GridBagConstraints gridBagConstraints;
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 1;
            getContentPane().add(display, gridBagConstraints);
            //getContentPane().add(display);
            //display.addLoadingMessage();
            display.getModelGroup().removeAllChildren();
            nwn = new NWNLoader();
            nwn.enableModelCache(true);
         
            //String filename = "C:\\Character Creator\\CharacterCreator\\models\\Deer.mdl";
            //String filename = "C:\\Character Creator\\CharacterCreator\\models\\pmt0.mdl";
            //String filename = "C:\\Character Creator\\CharacterCreator\\tmprace\\a_ba.mdl";
            //String filename = "C:\\Character Creator\\CharacterCreator\\tmprace\\c_dabus.mdl";
            String filename = "c_dabus.mdl";
            File mdlFile = new File(filename);
            modelFile = mdlFile.toURL();
            Scene s = nwn.load(modelFile);
            javax.media.j3d.BranchGroup bg = s.getSceneGroup();
            setCapabilities(bg);
            bg.compile();
            //bg.addChild();
            display.getModelGroup().addChild(bg);
         
            this.setSize(600, 600);
            this.pack();
            //ModelPanel.setSize(600, 600);
         
            //getContentPane().setSize(600, 600);
         *
        }
        catch (Exception exc) {
            exc.printStackTrace();
            JOptionPane.showMessageDialog(CustomizeMenu1.this, exc, "Error during load " + modelFile, JOptionPane.ERROR_MESSAGE);
            display.removeLoadingMessage();
        }*/
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        SkinNum = new javax.swing.JLabel();
        HairNum = new javax.swing.JLabel();
        Tattoo1Num = new javax.swing.JLabel();
        Tattoo2Num = new javax.swing.JLabel();
        SkinButton = new javax.swing.JButton();
        HairButton = new javax.swing.JButton();
        Tattoo1Button = new javax.swing.JButton();
        Tattoo2Button = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        HeadPanel = new javax.swing.JPanel();
        HeadCombo = new javax.swing.JComboBox();
        HeadLabel = new javax.swing.JLabel();
        AppearancePanel = new javax.swing.JPanel();
        AppearanceCombo = new javax.swing.JComboBox();
        AppearanceLabel = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        jPanel7 = new javax.swing.JPanel();
        PhenotypePanel = new javax.swing.JPanel();
        PhenotypeCombo = new javax.swing.JComboBox();
        PhenotypeLabel = new javax.swing.JLabel();
        jPanel8 = new javax.swing.JPanel();
        TattooButton = new javax.swing.JButton();
        jPanel9 = new javax.swing.JPanel();
        WingsPanel = new javax.swing.JPanel();
        WingsLabel = new javax.swing.JLabel();
        WingsCombo = new javax.swing.JComboBox();
        TailPanel = new javax.swing.JPanel();
        TailLabel = new javax.swing.JLabel();
        TailCombo = new javax.swing.JComboBox();
        jPanel10 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Body Customize");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        SkinNum.setFont(new java.awt.Font("Dialog", 0, 14));
        SkinNum.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        SkinNum.setText("0");
        SkinNum.setBorder(new javax.swing.border.EtchedBorder());
        SkinNum.setPreferredSize(new java.awt.Dimension(26, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 30;
        getContentPane().add(SkinNum, gridBagConstraints);

        HairNum.setFont(new java.awt.Font("Dialog", 0, 14));
        HairNum.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        HairNum.setText("0");
        HairNum.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(HairNum, gridBagConstraints);

        Tattoo1Num.setFont(new java.awt.Font("Dialog", 0, 14));
        Tattoo1Num.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Tattoo1Num.setText("0");
        Tattoo1Num.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(Tattoo1Num, gridBagConstraints);

        Tattoo2Num.setFont(new java.awt.Font("Dialog", 0, 14));
        Tattoo2Num.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Tattoo2Num.setText("0");
        Tattoo2Num.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(Tattoo2Num, gridBagConstraints);

        SkinButton.setText("Skin");
        SkinButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SkinButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 60;
        getContentPane().add(SkinButton, gridBagConstraints);

        HairButton.setText("Hair");
        HairButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HairButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(HairButton, gridBagConstraints);

        Tattoo1Button.setText("Tattoo 1");
        Tattoo1Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Tattoo1ButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(Tattoo1Button, gridBagConstraints);

        Tattoo2Button.setText("Tattoo 2");
        Tattoo2Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Tattoo2ButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(Tattoo2Button, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 18;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel3, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel4, gridBagConstraints);

        HeadPanel.setLayout(new java.awt.BorderLayout());

        HeadCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HeadComboActionPerformed(evt);
            }
        });
        HeadCombo.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                HeadComboPropertyChange(evt);
            }
        });

        HeadPanel.add(HeadCombo, java.awt.BorderLayout.CENTER);

        HeadLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        HeadLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        HeadLabel.setText("Head");
        HeadPanel.add(HeadLabel, java.awt.BorderLayout.NORTH);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(HeadPanel, gridBagConstraints);

        AppearancePanel.setLayout(new java.awt.BorderLayout());

        AppearanceCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                AppearanceComboActionPerformed(evt);
            }
        });

        AppearancePanel.add(AppearanceCombo, java.awt.BorderLayout.CENTER);

        AppearanceLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        AppearanceLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        AppearanceLabel.setText("Appearance");
        AppearancePanel.add(AppearanceLabel, java.awt.BorderLayout.NORTH);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(AppearancePanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel5, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel6, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 19;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 19;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 20;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel7, gridBagConstraints);

        PhenotypePanel.setLayout(new java.awt.BorderLayout());

        PhenotypeCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                PhenotypeComboActionPerformed(evt);
            }
        });

        PhenotypePanel.add(PhenotypeCombo, java.awt.BorderLayout.CENTER);

        PhenotypeLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        PhenotypeLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        PhenotypeLabel.setText("Phenotype");
        PhenotypePanel.add(PhenotypeLabel, java.awt.BorderLayout.NORTH);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PhenotypePanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel8, gridBagConstraints);

        TattooButton.setFont(new java.awt.Font("Trebuchet MS", 1, 12));
        TattooButton.setText("Tattoo Customization");
        TattooButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                TattooButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 17;
        gridBagConstraints.gridwidth = 2;
        getContentPane().add(TattooButton, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 16;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel9, gridBagConstraints);

        WingsPanel.setLayout(new java.awt.BorderLayout());

        WingsLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        WingsLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        WingsLabel.setText("Wings");
        WingsPanel.add(WingsLabel, java.awt.BorderLayout.NORTH);

        WingsCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                WingsComboActionPerformed(evt);
            }
        });

        WingsPanel.add(WingsCombo, java.awt.BorderLayout.CENTER);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(WingsPanel, gridBagConstraints);

        TailPanel.setLayout(new java.awt.BorderLayout());

        TailLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        TailLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        TailLabel.setText("Tail");
        TailPanel.add(TailLabel, java.awt.BorderLayout.NORTH);

        TailCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                TailComboActionPerformed(evt);
            }
        });

        TailPanel.add(TailCombo, java.awt.BorderLayout.CENTER);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(TailPanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel10, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel11, gridBagConstraints);

        pack();
    }//GEN-END:initComponents

    private void TailComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TailComboActionPerformed
        // Add your handling code here:
        if("comboBoxChanged".equals(evt.getActionCommand())) {
            tail = TailCombo.getSelectedIndex();        
        }
    }//GEN-LAST:event_TailComboActionPerformed

    private void WingsComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_WingsComboActionPerformed
        // Add your handling code here:
        if("comboBoxChanged".equals(evt.getActionCommand())) {
            wing = WingsCombo.getSelectedIndex();
        }
    }//GEN-LAST:event_WingsComboActionPerformed
    
    private void TattooButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TattooButtonActionPerformed
        // Add your handling code here:
        (new TattooMenu()).show();
    }//GEN-LAST:event_TattooButtonActionPerformed
    
    private void PhenotypeComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_PhenotypeComboActionPerformed
        // Add your handling code here:
        if("comboBoxChanged".equals(evt.getActionCommand())) {
            int num = AppearanceCombo.getSelectedIndex();
            if(num == 0) phenotype = 0;
            if(num == 1) phenotype = 2;
            doheadcombobox();
        }
    }//GEN-LAST:event_PhenotypeComboActionPerformed
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        menucreate.BlockWindow(false);        
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        menucreate.MainCharData[15] = new HashMap();
        menucreate.MainCharData[15].put(new Integer(0), new Integer(SkinNum.getText()));
        menucreate.MainCharData[15].put(new Integer(1), new Integer(HairNum.getText()));
        menucreate.MainCharData[15].put(new Integer(2), new Integer(Tattoo1Num.getText()));
        menucreate.MainCharData[15].put(new Integer(3), new Integer(Tattoo2Num.getText()));
        menucreate.MainCharData[15].put(new Integer(4), new Integer(head));
        menucreate.MainCharData[15].put(new Integer(5), new Integer(appearance));
        //System.out.println("Appearance: " + appearance);
        menucreate.MainCharData[15].put(new Integer(6), new Integer(phenotype));
        menucreate.MainCharData[15].put(new Integer(14), new Integer(wing));
        menucreate.MainCharData[15].put(new Integer(15), new Integer(tail));
        (new CustomizeMenu2()).show();
        System.out.println("Wing: " + wing);
        System.out.println("Tail: " + tail);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed
    
    private void AppearanceComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AppearanceComboActionPerformed
        // Add your handling code here:
        if("comboBoxChanged".equals(evt.getActionCommand())) {
            //System.out.println("AppearanceComboActionPerformed");
            int num = AppearanceCombo.getSelectedIndex();
            if(num != -1) {
                appearance = new Integer(((String)appearancelist.get(num))).intValue();
            } else {
                appearance = 0;
            }
            doheadcombobox();
        }
    }//GEN-LAST:event_AppearanceComboActionPerformed
    
    private void HeadComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HeadComboActionPerformed
        // Add your handling code here:
        if("comboBoxChanged".equals(evt.getActionCommand())) {
            if(HeadCombo.getSelectedItem() == null) return;
            String num = HeadCombo.getSelectedItem().toString();
            String endnum;
            if(num.indexOf("head00") != -1) {
                endnum = num.substring(6);
                head = new Integer(endnum).intValue();
                //    System.out.println(endnum);
                return;
            }
            if(num.indexOf("head0") != -1) {
                endnum = num.substring(5);
                head = new Integer(endnum).intValue();
                //    System.out.println(endnum);
                return;
            }
            if(num.indexOf("head") != -1) {
                endnum = num.substring(4);
                head = new Integer(endnum).intValue();
                //    System.out.println(endnum);
                return;
            }
            //System.out.println(num);
            //System.out.println("HeadComboActionPerformed");
        }
    }//GEN-LAST:event_HeadComboActionPerformed
    
    private void HeadComboPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_HeadComboPropertyChange
        // Add your handling code here:
        //System.out.println("HeadComboPropertyChange");
    }//GEN-LAST:event_HeadComboPropertyChange
    
    private void Tattoo2ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Tattoo2ButtonActionPerformed
        // Add your handling code here:
        newcolor = new ColorSelect("tattoo", Tattoo2Num);
        newcolor.show();
    }//GEN-LAST:event_Tattoo2ButtonActionPerformed
    
    private void Tattoo1ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Tattoo1ButtonActionPerformed
        // Add your handling code here:
        newcolor = new ColorSelect("tattoo", Tattoo1Num);
        newcolor.show();
    }//GEN-LAST:event_Tattoo1ButtonActionPerformed
    
    private void HairButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HairButtonActionPerformed
        // Add your handling code here:
        newcolor = new ColorSelect("hair", HairNum);
        newcolor.show();
    }//GEN-LAST:event_HairButtonActionPerformed
    
    private void SkinButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SkinButtonActionPerformed
        // Add your handling code here:
        newcolor = new ColorSelect("skin", SkinNum);
        newcolor.show();
        //int tmp = newcolor.getColor();
        //jLabel1.setText(new Integer(tmp).toString());
    }//GEN-LAST:event_SkinButtonActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        //display.destroyEverything();
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm
    
   /* private static ProcessNodeInterface capabilityProcessor = new ProcessNodeInterface() {
        public void processNode(Node node) {
            if (node instanceof Group) {
                node.setCapability(Group.ALLOW_CHILDREN_READ);
                if (node instanceof TransformGroup) {
                    node.setCapability(TransformGroup.ALLOW_LOCAL_TO_VWORLD_READ);
                }
            }
            else if (node instanceof Shape3D) {
                Shape3D s = (Shape3D) node;
    
                s.setCapability(Shape3D.ALLOW_APPEARANCE_READ);
                s.getAppearance().setCapability(Appearance.ALLOW_TEXTURE_UNIT_STATE_READ);
                s.getAppearance().clearCapabilityIsFrequent(Appearance.ALLOW_TEXTURE_UNIT_STATE_READ);
                s.getAppearance().setCapability(Appearance.ALLOW_POLYGON_ATTRIBUTES_WRITE);
                s.getAppearance().clearCapabilityIsFrequent(Appearance.ALLOW_POLYGON_ATTRIBUTES_WRITE);
                s.getAppearance().setCapability(Appearance.ALLOW_RENDERING_ATTRIBUTES_WRITE);
                s.getAppearance().clearCapabilityIsFrequent(Appearance.ALLOW_RENDERING_ATTRIBUTES_WRITE);
    
                for (int i = 0; i < s.getAppearance().getTextureUnitCount(); i++) {
                    if (s.getAppearance().getTextureUnitState(i) != null) {
                        s.getAppearance().getTextureUnitState(i).setCapability(TextureUnitState.ALLOW_STATE_READ);
                        s.getAppearance().getTextureUnitState(i).getTexture().setCapability(Texture.ALLOW_ENABLE_WRITE);
                        s.getAppearance().getTextureUnitState(i).getTextureAttributes().setCapability(TextureAttributes.ALLOW_MODE_WRITE);
                        s.getAppearance().getTextureUnitState(i).getTexture().clearCapabilityIsFrequent(Texture.ALLOW_ENABLE_WRITE);
                        s.getAppearance().getTextureUnitState(i).getTextureAttributes().clearCapabilityIsFrequent(TextureAttributes.ALLOW_MODE_WRITE);
                    }
                }
            }
    
        }
    };
    
    public void setCapabilities(BranchGroup bg) {
        TreeScan.findNode(bg, new Class[]
        {Group.class, Shape3D.class}, capabilityProcessor,
        false, false);
    }
    
/*    public void setTextureUnitState(final int unit, final boolean enabled)
    {
        treeScan(new AppearanceChangeProcessor()
            {
                public void changeAppearance(javax.media.j3d.Shape3D shape,
                    javax.media.j3d.Appearance app)
                {
                    if (shape instanceof ParticleCollection || shape instanceof Walkmesh)
                        return;
    
                    if (unit == TEX_METAL && app.getTextureUnitCount() == 1)
                        return;
    
                    TextureUnitState tus = app.getTextureUnitState(unit);
    
                    if (tus != null)
                    {
                        tus.getTexture().setEnable(enabled);
                    }
    
                }
            }, display.getModelGroup());
    }    */
    
    private Object makeObj(final String item)  {
        return new Object() { public String toString() { return item; } };
    }
    
    /*
    private void dowingcombobox() {
        if(isinitialized) {        
            PhenotypeCombo.setEnabled(true);
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
            
            HeadCombo.setEnabled(true);
            HeadCombo.removeAllItems();
            //String racestr = (String)menucreate.MainCharData[1].get(new Integer(0));
            //int race = new Integer(racestr).intValue();
            if(!isdynamic(race)) {
                HeadCombo.addItem(makeObj("Non Dynamic"));
                HeadCombo.setEnabled(false);
                PhenotypeCombo.setSelectedIndex(0);
                PhenotypeCombo.setEnabled(false);
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));                
                return;
            }
            String prestring;
            prestring = "p" + getsex() + getrace() + getphenotype() + "_head";
            //CHANGE ABOVE FOR PHENOTYPE
            for(int i = 0; i < 256; i++) {
                String num = Integer.toString(i);
                num = num.trim();
                if(i > 9) {
                    if(i > 99) {
                    } else {
                        num = "0" + num;
                    }
                } else {
                    num = "00" + num;
                }
                String file = prestring + num + ".mdl";
                //String file = prestring + num;
                //System.out.println(file);
                if(RESFAC.FileExists("",file)) {
                    HeadCombo.addItem(makeObj("head"+num));
                }
            }
            if(HeadCombo.getSelectedIndex() != -1 && HeadCombo.getItemAt(1) != null) {
                HeadCombo.setSelectedIndex(1);
            }
            
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        }        
    }
     */
    
    private void dotailcombobox() {
        
    }
    private void doheadcombobox() {
        if(isinitialized) {
            PhenotypeCombo.setEnabled(true);
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
            WingsCombo.setEnabled(true);
            TailCombo.setEnabled(true);             
            HeadCombo.setEnabled(true);
            HeadCombo.removeAllItems();
            //String racestr = (String)menucreate.MainCharData[1].get(new Integer(0));
            //int race = new Integer(racestr).intValue();
            if(!isdynamic(race)) {
                HeadCombo.addItem(makeObj("Non Dynamic"));
                HeadCombo.setEnabled(false);
                PhenotypeCombo.setSelectedIndex(0);
                PhenotypeCombo.setEnabled(false);
                WingsCombo.setSelectedIndex(0);
                WingsCombo.setEnabled(false);
                TailCombo.setSelectedIndex(0);
                TailCombo.setEnabled(false);                
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));                
                return;
            }
            String prestring;
            prestring = "p" + getsex() + getrace() + getphenotype() + "_head";
            //CHANGE ABOVE FOR PHENOTYPE
            for(int i = 0; i < 256; i++) {
                String num = Integer.toString(i);
                num = num.trim();
                if(i > 9) {
                    if(i > 99) {
                    } else {
                        num = "0" + num;
                    }
                } else {
                    num = "00" + num;
                }
                String file = prestring + num + ".mdl";
                //String file = prestring + num;
                //System.out.println(file);
                if(RESFAC.FileExists("",file)) {
                    HeadCombo.addItem(makeObj("head"+num));
                }
            }
            if(HeadCombo.getSelectedIndex() != -1 && HeadCombo.getItemAt(1) != null) {
                HeadCombo.setSelectedIndex(1);
            }
            
            setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
            menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        }
    }
    
    private String getsex() {
        Integer sexinteger = (Integer)menucreate.MainCharData[0].get(new Integer(0));
        int sex = sexinteger.intValue();
        switch(sex) {
            case 0:
                return "m";
            case 1:
                return "f";
            case 2:
                return "b";
            case 3:
                return "o";
            case 4:
                return "n";
            default:
                return "m";
        }
    }
    
    private String getrace() {
        //String racestr = (String)menucreate.MainCharData[1].get(new Integer(0));
        //int race = new Integer(racestr).intValue();
        if(isdynamic(race)) {
            /*try {
                if(appmap == null) {
                    appmap = RESFAC.getResourceAs2DA("appearance.2da");
                }
            }
            catch (IOException err) {
                JOptionPane.showMessageDialog(null, "Fatal Error - appearance.2da not found. Your data files might be corrupt.", "Error", 0);
                System.exit(0);
            }*/
            //String appearancestr = (String)menucreate.MainCharData[1].get(new Integer(8));
            //Integer appnum = new Integer(appearancestr);
            //String letter = ((String)appmap[appnum.intValue()].get(new Integer(4)));
            String letter = appmap[appearance][4];
            return letter.toLowerCase();
        } else {
            return null;
        }
    }
    
    private int getphenotype() {
        return phenotype;
    }
    
    private boolean isdynamic(int race) {
        /*try {
            if(appmap == null) {
                appmap = RESFAC.getResourceAs2DA("appearance.2da");
            }
        }
        catch (IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - appearance.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }*/
        //String appearancestr = (String)menucreate.MainCharData[1].get(new Integer(8));
        //Integer appnum = new Integer(appearancestr);
        return appmap[appearance][3].equalsIgnoreCase("Character_model");
    }
    /**
     * @param args the command line arguments
     */
    //public static void main(String args[]) {
    //    new CustomizeMenu1().show();
    //}
    /*
    public static NWNLoader getNWNLoader() {
        return nwn;
    }
     */
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox AppearanceCombo;
    private javax.swing.JLabel AppearanceLabel;
    private javax.swing.JPanel AppearancePanel;
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton HairButton;
    private javax.swing.JLabel HairNum;
    private javax.swing.JComboBox HeadCombo;
    private javax.swing.JLabel HeadLabel;
    private javax.swing.JPanel HeadPanel;
    private javax.swing.JButton OKButton;
    private javax.swing.JComboBox PhenotypeCombo;
    private javax.swing.JLabel PhenotypeLabel;
    private javax.swing.JPanel PhenotypePanel;
    private javax.swing.JButton SkinButton;
    private javax.swing.JLabel SkinNum;
    private javax.swing.JComboBox TailCombo;
    private javax.swing.JLabel TailLabel;
    private javax.swing.JPanel TailPanel;
    private javax.swing.JButton Tattoo1Button;
    private javax.swing.JLabel Tattoo1Num;
    private javax.swing.JButton Tattoo2Button;
    private javax.swing.JLabel Tattoo2Num;
    private javax.swing.JButton TattooButton;
    private javax.swing.JComboBox WingsCombo;
    private javax.swing.JLabel WingsLabel;
    private javax.swing.JPanel WingsPanel;
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
    //private static NWNLoader nwn;
    //Display display;
    //URL modelFile;
    boolean isinitialized;
    int head;
    int race;
    int appearance;
    int wing;
    int tail;
    String[][] appmap;
    String[][] wingmap;
    String[][] tailmap;
    private LinkedList appearancelist;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private CreateMenu menucreate;
    ColorSelect newcolor;
    int phenotype;
}
