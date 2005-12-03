/*
 * ClassMenu.java
 *
 * Created on March 16, 2003, 8:48 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
//import java.util.HashMap;
//import java.util.Map;
import javax.swing.*;
//import javax.swing.border.EmptyBorder;
//import javax.swing.border.EtchedBorder;
import CharacterCreator.defs.*;
import CharacterCreator.util.*;
/**
 *
 * @author  James
 */
public class ClassMenu extends javax.swing.JFrame {
    /**
	 * An auto-generated ID.
	 */
	private static final long serialVersionUID = -3345719361604207528L;
	
	
	public class ClassButton extends JPanel {
        /**
		 * An auto-generated ID.
		 */
		private static final long serialVersionUID = -8372013590256286125L;


		private void initComponents() {
            ClassButton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            ClassButton.setBackground(new Color(0, 0, 0));
            ClassButton.setForeground(new Color(222, 200, 120));
            ClassButton.setIcon(new ImageIcon(getClass().getResource("/CharacterCreator/resource/folder.gif")));
            ClassButton.setText("Name Place Holder");
            ClassButton.setHorizontalAlignment(2);
            ClassButton.setIconTextGap(40);
            ClassButton.setPreferredSize(new Dimension(240, 52));
            ClassButton.addActionListener(new ActionListener() {

                public void actionPerformed(ActionEvent evt) {
                    ClassButtonActionPerformed(evt);
                }

            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(ClassButton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }

        private void ClassButtonActionPerformed(ActionEvent evt) {
            int tmp = 0;
            //try {
            //int radix;
            OKButton.setEnabled(true);
            tmp = (new Integer(InfoNum.getText())).intValue();
            String descstr = classmap[tmp][classes.Description];
            int descnum = ChkHex.ChkHex(descstr);
            String description = TLKFAC.getEntry(descnum);
            /* Hack to make the text area grow in size if necessary 
            int requiredrows = ((3 * description.length()) / DescriptionText.getColumns()) / 2;
            if(requiredrows > DescriptionText.getRows())
            	DescriptionText.setRows(requiredrows);*/
            
            DescriptionText.setText(description);
            //System.out.println(TLKFAC.getEntry(descnum));
            CLASSNUM = tmp;
            //}
            //catch(NumberFormatException err) {
            //    JOptionPane.showMessageDialog(null, "Parse Error - Line " + tmp + ". Error returned: " + err, "Error", 0);
            //    System.exit(0);
            //}
        }
        public JButton ClassButton;
        public JLabel InfoNum;
        public String FILENAME;


        public ClassButton(String imageName, String desc, String ctext) throws IOException {
            initComponents();

			ImageIcon icon = RESFAC.getIcon(imageName);
			if (icon != null)
                ClassButton.setIcon(icon);

			ClassButton.setText(desc);
			setSize(240, 52);
			InfoNum.setText(ctext);
        }
    }

    /** Creates new form ClassMenu1 */
    public ClassMenu() {
        CLASSNUM = 4;
        initComponents();
        OKButton.setEnabled(false);
        DescriptionContainer.setViewportView(DescriptionText);
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
        //String imagestring = "";
        DescriptionText.setText(TLKFAC.getEntry(484));
        try {
            classmap = RESFAC.getResourceAs2DA("classes");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - classes.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        try {
            for(int ii = 0; ii < classmap.length; ii++) {
                String tempispc = classmap[ii][classes.PlayerClass];

                if(tempispc != null && tempispc.equalsIgnoreCase("1")) {
                    String xpintstr = classmap[ii][classes.XPPenalty];
                    Integer xpint = new Integer(xpintstr);

                    if(xpint.intValue() == 1) {
                        String imageName = classmap[ii][classes.Icon];
                        ClassButton classbutton = new ClassButton(
								imageName,
								TLKFAC.getEntry(ChkHex.ChkHex(classmap[ii][classes.Name])),
								classmap[ii][0]
							);

                        ClassButtonList.add(classbutton, -1);
                    }
                }
            }

        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Error - Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "Parse Error - Error returned: " + err, "Error", 0);
            System.exit(0);
        }
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));

        pack();
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        ClassButtonContainer = new javax.swing.JScrollPane();
        ClassButtonBak = new javax.swing.JPanel();
        ClassButtonList = new javax.swing.JPanel();
        RecommendedButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        DescriptionContainer = new javax.swing.JScrollPane();
        //DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        PadPanel = new javax.swing.JPanel();
        PadPanel2 = new javax.swing.JPanel();
        PadPanel3 = new javax.swing.JPanel();
        PadPanel4 = new javax.swing.JPanel();
        jPanel16 = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Choose a class for your character.");
        setBackground(new java.awt.Color(0, 0, 0));
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        ClassButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        ClassButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        ClassButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        ClassButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        ClassButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        ClassButtonContainer.setAutoscrolls(true);
		ClassButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		ClassButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        ClassButtonBak.setLayout(new java.awt.GridBagLayout());

        ClassButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        ClassButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        ClassButtonBak.setAlignmentX(0.0F);
        ClassButtonBak.setAlignmentY(0.0F);
        ClassButtonBak.setAutoscrolls(true);
        ClassButtonList.setLayout(new java.awt.GridLayout(0, 1));

        ClassButtonList.setBackground(new java.awt.Color(0, 0, 0));
        ClassButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        ClassButtonBak.add(ClassButtonList, gridBagConstraints);

        ClassButtonContainer.setViewportView(ClassButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(ClassButtonContainer, gridBagConstraints);

        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RecommendedButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        getContentPane().add(RecommendedButton, gridBagConstraints);

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
        //DescriptionPanel.setLayout(new java.awt.GridBagLayout());

        //DescriptionPanel.setPreferredSize(new java.awt.Dimension(400, 900));
        DescriptionText.setBackground(new java.awt.Color(0, 0, 0));
        DescriptionText.setForeground(new java.awt.Color(240, 216, 130));
        DescriptionText.setLineWrap(true);
        DescriptionText.setWrapStyleWord(true);
        DescriptionText.setPreferredSize(new java.awt.Dimension(400, 6144));
        DescriptionText.setAutoscrolls(false);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 13;
        gridBagConstraints.gridheight = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        //DescriptionPanel.add(DescriptionText, gridBagConstraints);

        //DescriptionContainer.setViewportView(DescriptionPanel);
        DescriptionContainer.setViewportView(DescriptionText);

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
        try {
            CreateMenu menucreate = TLKFactory.getCreateMenu();
            menucreate.AlignmentButton.setEnabled(true);
            descstr = classmap[CLASSNUM][classes.Name];
            int tlkentry = ChkHex.ChkHex(descstr);
            menucreate.ClassName.setText(TLKFAC.getEntry(tlkentry));
            menucreate.MainCharDataAux[3] = classmap[CLASSNUM];
            menucreate.RedoAll();
            menucreate.BlockWindow(false);
            setVisible(false);
            dispose();
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "Parse Error - classes.2da, column " + classes.Name +". Error returned: " + err, "Error", 0);
            System.exit(0);
        }
    }//GEN-LAST:event_OKButtonActionPerformed

    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RecommendedButtonActionPerformed
        // Add your handling code here:
        try {
            CreateMenu menucreate = TLKFactory.getCreateMenu();
            int favored = 4;
            if(menucreate.MainCharDataAux[1] != null
					&& menucreate.MainCharDataAux[1][racialtypes.Favored] != null)
                favored = Integer.parseInt(menucreate.MainCharDataAux[1][racialtypes.Favored]);
            //int descnum2 = (new Integer((String)classmap[favored].get(new Integer(classes.Description)))).intValue();
            descstr = classmap[favored][classes.Description];
            int descnum2 = ChkHex.ChkHex(descstr);
            DescriptionText.setText(TLKFAC.getEntry(descnum2));
            CLASSNUM = favored;
            OKButton.setEnabled(true);
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "Parse Error - classes.2da, column " + classes.Description +". Error returned: " + err, "Error", 0);
            System.exit(0);
        }
    }//GEN-LAST:event_RecommendedButtonActionPerformed

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm

    private int CLASSNUM;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public String[][] classmap;
    private CreateMenu menucreate;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CancelButton;
    private javax.swing.JPanel ClassButtonBak;
    private javax.swing.JScrollPane ClassButtonContainer;
    private javax.swing.JPanel ClassButtonList;
    private javax.swing.JScrollPane DescriptionContainer;
    //private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JButton OKButton;
    private javax.swing.JPanel PadPanel;
    private javax.swing.JPanel PadPanel2;
    private javax.swing.JPanel PadPanel3;
    private javax.swing.JPanel PadPanel4;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    // End of variables declaration//GEN-END:variables
    private String descstr;
    //Variable declarations for CLASSES.2DA
    private int Label = classes.Label;
    private int Icon = classes.Icon;
    private int PlayerClass = classes.PlayerClass;
    private int XPPenalty = classes.XPPenalty;
}
