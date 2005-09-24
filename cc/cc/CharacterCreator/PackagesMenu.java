/*
 * PackagesMenu.java
 *
 * Created on March 16, 2003, 9:29 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.EtchedBorder;
import CharacterCreator.defs.*;
import CharacterCreator.util.*;
/**
 *
 * @author  James
 */
public class PackagesMenu extends javax.swing.JFrame {
	private boolean dieJamesDie = false; // A marker - This is set when any valid package is selected
	
    public class PackageButton extends JPanel {

        private void initComponents() {
            PackageButton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            PackageButton.setBackground(new Color(0, 0, 0));
            PackageButton.setForeground(new Color(222, 200, 120));
            PackageButton.setText("Name Place Holder");
            PackageButton.setHorizontalAlignment(2);
            PackageButton.setPreferredSize(new Dimension(240, 52));
            PackageButton.addActionListener(new ActionListener() {

                public void actionPerformed(ActionEvent evt) {
                    PackageButtonActionPerformed(evt);
                }

            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(PackageButton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }

        private void PackageButtonActionPerformed(ActionEvent evt) {
            int tmp = (new Integer(InfoNum.getText())).intValue();
            String descstr = packagemap[tmp][packages.Description];
            int descnum = ChkHex.ChkHex(descstr);
            //int descnum = (new Integer((String)packagemap[tmp].get(new Integer(packages.Description)))).intValue();
            DescriptionText.setText(TLKFAC.getEntry(descnum));
            //DescriptionContainer.scrollRectToVisible(new Rectangle());
            PACKAGENUM = tmp;
            dieJamesDie = true;
        }

        public JButton PackageButton;
        public JLabel InfoNum;
        public String FILENAME;


        public PackageButton() {
            initComponents();
        }
    }

    /** Creates new form PackagesMenu */
    public PackagesMenu() {
        PACKAGENUM = 0;
        initComponents();
        DescriptionContainer.setViewportView(DescriptionText);
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }

        menucreate = TLKFactory.getCreateMenu();
        menucreate.BlockWindow(true);
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        String imagestring = "";


        try {
            packagemap = RESFAC.getResourceAs2DA("packages");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - packages.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        for(int i = 0; i < packagemap.length; i++) {
            String classnumber = packagemap[i][packages.ClassID];
            if(classnumber != null && classnumber.equalsIgnoreCase(menucreate.MainCharDataAux[3][0])) {
                //Added this for HotU, only show Player Class packages
                if(Integer.parseInt(packagemap[i][packages.PlayerClass]) == 1) {
                    PackageButton packagebutton = new PackageButton();
                    String descstr = packagemap[i][packages.Name];
                    int descnum = ChkHex.ChkHex(descstr);
                    //packagebutton.PackageButton.setText(TLKFAC.getEntry((new Integer((String)packagemap[i].get(new Integer(packages.Name)))).intValue()));
                    packagebutton.PackageButton.setText(TLKFAC.getEntry(descnum));
                    packagebutton.setSize(240, 52);
                    packagebutton.InfoNum.setText(Integer.toString(i));
                    PackageButtonList.add(packagebutton, -1);
                }
            }
        }
        doRecommended();
        DescriptionText.setText(TLKFAC.getEntry(487));
        pack();
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        PackageButtonContainer = new javax.swing.JScrollPane();
        PackageButtonBak = new javax.swing.JPanel();
        PackageButtonList = new javax.swing.JPanel();
        RecommendedButton = new javax.swing.JButton();
        ConfigurePackagesButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        DescriptionContainer = new javax.swing.JScrollPane();
        DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        PadPanel = new javax.swing.JPanel();
        PadPanel2 = new javax.swing.JPanel();
        PadPanel3 = new javax.swing.JPanel();
        PadPanel4 = new javax.swing.JPanel();
        jPanel16 = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Choose a Package");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        PackageButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        PackageButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        PackageButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        PackageButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        PackageButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        PackageButtonContainer.setAutoscrolls(true);
		PackageButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		PackageButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        PackageButtonBak.setLayout(new java.awt.GridBagLayout());

        PackageButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        PackageButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        PackageButtonBak.setAlignmentX(0.0F);
        PackageButtonBak.setAlignmentY(0.0F);
        PackageButtonBak.setAutoscrolls(true);
        PackageButtonList.setLayout(new java.awt.GridLayout(0, 1));

        PackageButtonList.setBackground(new java.awt.Color(0, 0, 0));
        PackageButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        PackageButtonBak.add(PackageButtonList, gridBagConstraints);

        PackageButtonContainer.setViewportView(PackageButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PackageButtonContainer, gridBagConstraints);

        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RecommendedButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(RecommendedButton, gridBagConstraints);

        ConfigurePackagesButton.setText("Configure Packages");
        ConfigurePackagesButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ConfigurePackagesButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(ConfigurePackagesButton, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 8;
        getContentPane().add(CancelButton, gridBagConstraints);

        DescriptionContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        DescriptionContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        DescriptionContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        DescriptionContainer.setPreferredSize(new java.awt.Dimension(400, 100));
        DescriptionContainer.setAutoscrolls(true);
        DescriptionPanel.setLayout(new java.awt.GridBagLayout());

        DescriptionText.setBackground(new java.awt.Color(0, 0, 0));
        DescriptionText.setForeground(new java.awt.Color(240, 216, 130));
        DescriptionText.setLineWrap(true);
        DescriptionText.setWrapStyleWord(true);
        DescriptionText.setPreferredSize(new java.awt.Dimension(400, 800));
        DescriptionText.setAutoscrolls(false);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 13;
        gridBagConstraints.gridheight = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(DescriptionText, gridBagConstraints);

        DescriptionContainer.setViewportView(DescriptionPanel);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DescriptionContainer, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PadPanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PadPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PadPanel3, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PadPanel4, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel16, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel17, gridBagConstraints);

        pack();
    }//GEN-END:initComponents

    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed

    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
    	if(!dieJamesDie)
        	doRecommended();
        menucreate.MainCharData[6] = new HashMap();
        menucreate.MainCharData[6].put(new Integer(0), Boolean.FALSE);
        menucreate.MainCharDataAux[7] = packagemap[PACKAGENUM];
        //menucreate.CustomizeButton.setEnabled(true);

        //HANDLING CODE FOR PACKAGE HANDLER GOES HERE
        SwingWorker worker2 = new SwingWorker() {

            public Object construct() {
                return new PackageHandler();
            }

        };
        worker2.start();
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed

    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RecommendedButtonActionPerformed
        // Add your handling code here:
        doRecommended();
    }//GEN-LAST:event_RecommendedButtonActionPerformed

    private void ConfigurePackagesButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ConfigurePackagesButtonActionPerformed
        // Add your handling code here:

        menucreate.MainCharData[6] = new HashMap();
        menucreate.MainCharData[6].put(new Integer(0), Boolean.FALSE);
        menucreate.MainCharDataAux[7] = packagemap[PACKAGENUM];
        (new SkillMenu()).show();
        //THIS IS TEMPORARY
        menucreate.BlockWindow(false);

        setVisible(false);
        dispose();
    }//GEN-LAST:event_ConfigurePackagesButtonActionPerformed

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm

    private void doRecommended() {
        int classn = 0;
        try {
            PACKAGENUM = 0;
            classn = Integer.parseInt(menucreate.MainCharDataAux[3][0]);
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "Parse Error - classes.2da, column 0. Error returned: " + err, "Error", 0);
            System.exit(0);
        }
        int i = 0;
        try {
            for(i = 0; i < packagemap.length; i++) {
                String classstr = packagemap[i][packages.ClassID];
                if(classstr != null) {
                    int classnumber = Integer.parseInt(classstr);
                    if(classnumber == classn) {
                        String descstr = packagemap[i][3];
                        int descnum = ChkHex.ChkHex(descstr);
                        //DescriptionText.setText(TLKFAC.getEntry((new Integer((String)packagemap[i].get(new Integer(3)))).intValue()));
                        DescriptionText.setText(TLKFAC.getEntry(descnum));
                        PACKAGENUM = i;
                        dieJamesDie = true;
                        //DescriptionText.setText(TLKFAC.getEntry(i));
                        return;
                    }
                }
            }
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - packages.2da, line " + i + ".\nError returned: " + err, "Error", 0);
            System.exit(0);
        }
    }
    /**
     * @param args the command line arguments
     */
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public String[][] packagemap;
    private CreateMenu menucreate;
    private int PACKAGENUM;

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton ConfigurePackagesButton;
    private javax.swing.JScrollPane DescriptionContainer;
    private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JButton OKButton;
    private javax.swing.JPanel PackageButtonBak;
    private javax.swing.JScrollPane PackageButtonContainer;
    private javax.swing.JPanel PackageButtonList;
    private javax.swing.JPanel PadPanel;
    private javax.swing.JPanel PadPanel2;
    private javax.swing.JPanel PadPanel3;
    private javax.swing.JPanel PadPanel4;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    // End of variables declaration//GEN-END:variables

}
