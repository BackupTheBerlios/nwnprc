/*
 * CustomizeMenu2.java
 *
 * Created on March 16, 2003, 11:33 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
/**
 *
 * @author  James
 */
public class CustomizeMenu2 extends javax.swing.JFrame {
    
    public class SoundButton extends JPanel {
        
        private void initComponents() {
            SoundButton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            SoundButton.setBackground(new Color(0, 0, 0));
            SoundButton.setForeground(new Color(204, 204, 0));
            SoundButton.setText("Name Place Holder");
            SoundButton.setHorizontalAlignment(2);
            SoundButton.setPreferredSize(new Dimension(240, 52));
            SoundButton.addActionListener(new ActionListener() {
                
                public void actionPerformed(ActionEvent evt) {
                    SoundButtonActionPerformed(evt);
                }
                
            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(SoundButton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }
        
        private void SoundButtonActionPerformed(ActionEvent evt) {
            int tmp = (new Integer(InfoNum.getText())).intValue();
            //int descnum = (new Integer((String)racialmap[tmp].get(new Integer(7)))).intValue();
            //DescriptionText.setText(TLKFAC.getEntry(descnum));
            //DescriptionContainer.scrollRectToVisible(new Rectangle());
            SOUNDNUM = tmp;
        }
        
        public JButton SoundButton;
        public JLabel InfoNum;
        public String FILENAME;
        
        
        public SoundButton() {
            initComponents();
        }
    }
    
    /** Creates new form CustomizeMenu2 */
    public CustomizeMenu2() {
        SOUNDNUM = 216;
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
        
        DeityLabel.setVisible(false);
        sexlock = true;
        standardlock = true;
        menucreate = TLKFactory.getCreateMenu();
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        
        
        int desc = Integer.parseInt(menucreate.MainCharDataAux[1][18]);
        DescriptionText.setText(TLKFAC.getEntry(desc));
        
        AgeText.setText(menucreate.MainCharDataAux[1][21]);
        //String imagestring = "";
        //DescriptionText.setText(TLKFAC.getEntry(485));
        try {
            soundsetmap = RESFAC.getResourceAs2DA("soundset");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - soundset.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        doSoundSet();
        pack();
        
    }
    
    private void doSoundSet() {
        SoundSetButtonList.removeAll();
        for(int i = 0; i < soundsetmap.length; i++) {
            String tempisstandard = soundsetmap[i][5];
            if(tempisstandard != null) {
                if(tempisstandard.equalsIgnoreCase("0") || !standardlock) {
                    String gender = ((Integer)menucreate.MainCharData[0].get(new Integer(0))).toString();
                    String tmpsex = soundsetmap[i][4];
                    if(tmpsex != null && (tmpsex.equalsIgnoreCase(gender) || !sexlock)) {
                        String resref = soundsetmap[i][2];
                        if(resref != null) {
                            SoundButton soundbutton = new SoundButton();
                            soundbutton.SoundButton.setText(TLKFAC.getEntry(Integer.parseInt(soundsetmap[i][3])));
                            soundbutton.setSize(240, 52);
                            soundbutton.InfoNum.setText(Integer.toString(i));
                            SoundSetButtonList.add(soundbutton, -1);
                        }
                    }
                }
            }
        }
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        FirstNameText = new javax.swing.JTextField();
        LastNameText = new javax.swing.JTextField();
        FirstNameLabel = new javax.swing.JLabel();
        LastNameLabel = new javax.swing.JLabel();
        AgeLabel = new javax.swing.JLabel();
        AgeText = new javax.swing.JTextField();
        PackageButtonContainer = new javax.swing.JScrollPane();
        SoundSetButtonBak = new javax.swing.JPanel();
        SoundSetButtonList = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        jPanel9 = new javax.swing.JPanel();
        jPanel10 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();
        DeityButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        GenderLock = new javax.swing.JCheckBox();
        StandardLock = new javax.swing.JCheckBox();
        DeityLabel = new javax.swing.JLabel();
        SubraceLabel = new javax.swing.JLabel();
        SubraceText = new javax.swing.JTextField();
        DescriptionContainer = new javax.swing.JScrollPane();
        DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        jPanel12 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        DescLabel = new javax.swing.JLabel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Select Additional Information");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        FirstNameText.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FirstNameText.setText("Joe");
        FirstNameText.setPreferredSize(new java.awt.Dimension(140, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(FirstNameText, gridBagConstraints);

        LastNameText.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        LastNameText.setText("Genero");
        LastNameText.setPreferredSize(new java.awt.Dimension(160, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.gridwidth = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(LastNameText, gridBagConstraints);

        FirstNameLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FirstNameLabel.setText("First Name");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.weightx = 1.0;
        getContentPane().add(FirstNameLabel, gridBagConstraints);

        LastNameLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        LastNameLabel.setText("Last Name");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(LastNameLabel, gridBagConstraints);

        AgeLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        AgeLabel.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        AgeLabel.setText("Age");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(AgeLabel, gridBagConstraints);

        AgeText.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(AgeText, gridBagConstraints);

        PackageButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        PackageButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        PackageButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(153, 153, 0)));
        PackageButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        PackageButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        PackageButtonContainer.setAutoscrolls(true);
		PackageButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		PackageButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        SoundSetButtonBak.setLayout(new java.awt.GridBagLayout());

        SoundSetButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        SoundSetButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        SoundSetButtonBak.setAlignmentX(0.0F);
        SoundSetButtonBak.setAlignmentY(0.0F);
        SoundSetButtonBak.setAutoscrolls(true);
        SoundSetButtonList.setLayout(new java.awt.GridLayout(0, 1));

        SoundSetButtonList.setBackground(new java.awt.Color(0, 0, 0));
        SoundSetButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SoundSetButtonBak.add(SoundSetButtonList, gridBagConstraints);

        PackageButtonContainer.setViewportView(SoundSetButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 11;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(PackageButtonContainer, gridBagConstraints);

        getContentPane().add(jPanel1, new java.awt.GridBagConstraints());

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 14;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel7, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel8, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 12;
        getContentPane().add(jPanel9, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 6;
        getContentPane().add(jPanel10, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 3;
        getContentPane().add(jPanel11, gridBagConstraints);

        DeityButton.setText("Deity");
        DeityButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DeityButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(DeityButton, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.gridwidth = 2;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        GenderLock.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        GenderLock.setSelected(true);
        GenderLock.setText("Lock to Gender?");
        GenderLock.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        GenderLock.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GenderLockActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHEAST;
        getContentPane().add(GenderLock, gridBagConstraints);

        StandardLock.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        StandardLock.setSelected(true);
        StandardLock.setText("Lock to Standard Sets?");
        StandardLock.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        StandardLock.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                StandardLockActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.SOUTHEAST;
        getContentPane().add(StandardLock, gridBagConstraints);

        DeityLabel.setFocusable(false);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 13;
        getContentPane().add(DeityLabel, gridBagConstraints);

        SubraceLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        SubraceLabel.setText("Subrace");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(SubraceLabel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(SubraceText, gridBagConstraints);

        DescriptionContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        DescriptionContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        DescriptionContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(204, 204, 204)));
        DescriptionContainer.setPreferredSize(new java.awt.Dimension(400, 100));
        DescriptionContainer.setAutoscrolls(true);
        DescriptionPanel.setLayout(new java.awt.GridBagLayout());

        DescriptionText.setBackground(new java.awt.Color(0, 0, 0));
        DescriptionText.setForeground(new java.awt.Color(255, 255, 153));
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
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.gridwidth = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DescriptionContainer, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        getContentPane().add(jPanel12, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel3, gridBagConstraints);

        DescLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        DescLabel.setText("Description");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(DescLabel, gridBagConstraints);

        pack();
    }//GEN-END:initComponents
    
    private void StandardLockActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_StandardLockActionPerformed
        // Add your handling code here:
        if(standardlock)
            standardlock = false;
        else
            if(!standardlock)
                standardlock = true;
        doSoundSet();
        pack();
    }//GEN-LAST:event_StandardLockActionPerformed
    
    private void GenderLockActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_GenderLockActionPerformed
        // Add your handling code here:
        if(sexlock)
            sexlock = false;
        else
            if(!sexlock)
                sexlock = true;
        doSoundSet();
        pack();
    }//GEN-LAST:event_GenderLockActionPerformed
    
    private void DeityButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_DeityButtonActionPerformed
        // Add your handling code here:
        DeityMenu dialog = new DeityMenu(this, true, DeityLabel);
        dialog.show();
    }//GEN-LAST:event_DeityButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        //menucreate.MainCharData[15] = new HashMap();
        menucreate.MainCharData[15].put(new Integer(7), FirstNameText.getText());
        menucreate.MainCharData[15].put(new Integer(8), LastNameText.getText());
        menucreate.MainCharData[15].put(new Integer(9), new Integer(AgeText.getText()));
        menucreate.MainCharData[15].put(new Integer(10), DeityLabel.getText());
        menucreate.MainCharData[15].put(new Integer(11), new Integer(SOUNDNUM));
        menucreate.MainCharData[15].put(new Integer(12), SubraceText.getText());
        menucreate.MainCharData[15].put(new Integer(13), DescriptionText.getText());
        menucreate.FinalizeButton.setEnabled(true);
        menucreate.BlockWindow(false);        
        menucreate.RedoAll();
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm
    
    /**
     * @param args the command line arguments
     */
    //public static void main(String args[]) {
    //    new CustomizeMenu2().show();
    //}
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel AgeLabel;
    private javax.swing.JTextField AgeText;
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton DeityButton;
    private javax.swing.JLabel DeityLabel;
    private javax.swing.JLabel DescLabel;
    private javax.swing.JScrollPane DescriptionContainer;
    private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JLabel FirstNameLabel;
    private javax.swing.JTextField FirstNameText;
    private javax.swing.JCheckBox GenderLock;
    private javax.swing.JLabel LastNameLabel;
    private javax.swing.JTextField LastNameText;
    private javax.swing.JButton OKButton;
    private javax.swing.JScrollPane PackageButtonContainer;
    private javax.swing.JPanel SoundSetButtonBak;
    private javax.swing.JPanel SoundSetButtonList;
    private javax.swing.JCheckBox StandardLock;
    private javax.swing.JLabel SubraceLabel;
    private javax.swing.JTextField SubraceText;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    // End of variables declaration//GEN-END:variables
    boolean sexlock;
    boolean standardlock;
    private int SOUNDNUM;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private CreateMenu menucreate;
    public String[][] soundsetmap;
}
