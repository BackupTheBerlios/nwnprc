/*
 * FamiliarMenu.java
 *
 * Created on March 31, 2003, 1:24 AM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.LinkedList;
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
public class FamiliarMenu extends javax.swing.JFrame {

    public class FamiliarButton extends JPanel {

        private void initComponents() {
            FamiliarButton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            FamiliarButton.setBackground(new Color(0, 0, 0));
            FamiliarButton.setForeground(new Color(222, 200, 120));
            FamiliarButton.setText("Name Place Holder");
            FamiliarButton.setHorizontalAlignment(2);
            FamiliarButton.setPreferredSize(new Dimension(240, 52));
            FamiliarButton.addActionListener(new ActionListener() {

                public void actionPerformed(ActionEvent evt) {
                    FamiliarButtonActionPerformed(evt);
                }

            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(FamiliarButton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }

        private void FamiliarButtonActionPerformed(ActionEvent evt) {
            int tmp = (new Integer(InfoNum.getText())).intValue();
            String descstr = familiarmap[tmp][4];
            int descnum = ChkHex.ChkHex(descstr);
            DescriptionText.setText(TLKFAC.getEntry(descnum));
            descstr = familiarmap[tmp][3];
            descnum = ChkHex.ChkHex(descstr);
            SelectedText.setText(TLKFAC.getEntry(descnum));
            selectedfamiliar = tmp;
        }

        public JButton FamiliarButton;
        public JLabel InfoNum;
        public String FILENAME;


        public FamiliarButton() {
            initComponents();
        }
    }

    /** Creates new form FamiliarMenu */
    public FamiliarMenu() {
        selectedfamiliar = 0;
        initComponents();

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }

        menucreate = TLKFactory.getCreateMenu();
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        try {
            familiarmap = RESFAC.getResourceAs2DA("hen_familiar");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - hen_familiar.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        String descstr = familiarmap[0][3];
        int descnum = ChkHex.ChkHex(descstr);
        SelectedText.setText(TLKFAC.getEntry(descnum));
        DescriptionText.setText(TLKFAC.getEntry(5607));
        for(int i = 0; i < familiarmap.length; i++) {
            String tempispc = familiarmap[i][3];
            if(tempispc != null) {
                FamiliarButton racebutton = new FamiliarButton();
                descstr = familiarmap[i][3];
                descnum = ChkHex.ChkHex(descstr);
                racebutton.FamiliarButton.setText(TLKFAC.getEntry(descnum));
                racebutton.setSize(240, 52);
                racebutton.InfoNum.setText(Integer.toString(i));
                FamiliarButtonList.add(racebutton, -1);
            }
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

        FamiliarButtonContainer = new javax.swing.JScrollPane();
        FamiliarButtonBak = new javax.swing.JPanel();
        FamiliarButtonList = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        NameLabel = new javax.swing.JLabel();
        NameText = new javax.swing.JTextField();
        SelectedLabel = new javax.swing.JLabel();
        SelectedText = new javax.swing.JTextField();
        jPanel9 = new javax.swing.JPanel();
        jPanel10 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        jPanel14 = new javax.swing.JPanel();
        jPanel15 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Select A Familiar");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        FamiliarButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        FamiliarButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        FamiliarButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        FamiliarButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        FamiliarButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        FamiliarButtonContainer.setAutoscrolls(true);
		FamiliarButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		FamiliarButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        FamiliarButtonBak.setLayout(new java.awt.GridBagLayout());

        FamiliarButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        FamiliarButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        FamiliarButtonBak.setAlignmentX(0.0F);
        FamiliarButtonBak.setAlignmentY(0.0F);
        FamiliarButtonBak.setAutoscrolls(true);
        FamiliarButtonList.setLayout(new java.awt.GridLayout(0, 1));

        FamiliarButtonList.setBackground(new java.awt.Color(0, 0, 0));
        FamiliarButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        FamiliarButtonBak.add(FamiliarButtonList, gridBagConstraints);

        FamiliarButtonContainer.setViewportView(FamiliarButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(FamiliarButtonContainer, gridBagConstraints);

        getContentPane().add(jPanel1, new java.awt.GridBagConstraints());

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 5;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel7, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 8;
        getContentPane().add(jPanel8, gridBagConstraints);

        NameLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        NameLabel.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        NameLabel.setText("Familiar Name");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(NameLabel, gridBagConstraints);

        NameText.setText("Merlin");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(NameText, gridBagConstraints);

        SelectedLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        SelectedLabel.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        SelectedLabel.setText("Familiar Selected");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(SelectedLabel, gridBagConstraints);

        SelectedText.setEditable(false);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(SelectedText, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel9, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel10, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 10;
        getContentPane().add(jPanel11, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
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
        gridBagConstraints.gridy = 9;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        DescriptionPanel.setLayout(new java.awt.GridBagLayout());

        DescriptionPanel.setBorder(new javax.swing.border.EtchedBorder());
        DescriptionText.setBackground(new java.awt.Color(0, 0, 0));
        DescriptionText.setForeground(new java.awt.Color(240, 216, 130));
        DescriptionText.setLineWrap(true);
        DescriptionText.setWrapStyleWord(true);
        DescriptionText.setPreferredSize(new java.awt.Dimension(400, 360));
        DescriptionText.setAutoscrolls(false);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 13;
        gridBagConstraints.gridheight = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(DescriptionText, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel12, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel13, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 14;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel14, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel15, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DescriptionPanel, gridBagConstraints);

        pack();
    }//GEN-END:initComponents

    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed

    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        menucreate.MainCharData[14].put(new Integer(1), new Integer(selectedfamiliar));
        menucreate.MainCharData[14].put(new Integer(0), NameText.getText());
        /*
        LinkedList featmap = new LinkedList();
        int numfeats = ((Integer)menucreate.MainCharData[9].get(new Integer(0))).intValue();
        for(int q = 0; q<numfeats; q++) {
            featmap.add(((Integer)menucreate.MainCharData[9].get(new Integer(1+q))));
        }
        //Animal Companion
        if(featmap.contains(new Integer(199))) {
            (new CompanionMenu()).show();
        }
        */
        menucreate.CustomizeButton.setEnabled(true);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CancelButton;
    private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JPanel FamiliarButtonBak;
    private javax.swing.JScrollPane FamiliarButtonContainer;
    private javax.swing.JPanel FamiliarButtonList;
    private javax.swing.JLabel NameLabel;
    private javax.swing.JTextField NameText;
    private javax.swing.JButton OKButton;
    private javax.swing.JLabel SelectedLabel;
    private javax.swing.JTextField SelectedText;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    // End of variables declaration//GEN-END:variables
    private int selectedfamiliar;
    //private LinkedList domainlist;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public String[][] familiarmap;
    private CreateMenu menucreate;
}
