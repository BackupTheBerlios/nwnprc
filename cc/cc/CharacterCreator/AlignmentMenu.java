/*
 * AlignmentMenu1.java
 *
 * Created on April 4, 2003, 3:40 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.PrintStream;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
import CharacterCreator.defs.*;

/**
 *
 * @author  James
 */
public class AlignmentMenu extends javax.swing.JFrame {

    /** Creates new form AlignmentMenu1 */
    public AlignmentMenu() throws Exception {
        GoodEvil = 50;
        LawfulChaotic = 50;
        menucreate = TLKFactory.getCreateMenu();
        alignlabel = menucreate.AlignmentName;
        //alignlabel = parent;
        menucreate.BlockWindow(true);
        initComponents();

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }

        String restricted = menucreate.MainCharDataAux[3][classes.AlignRestrict];
        String type = menucreate.MainCharDataAux[3][classes.AlignRstrctType];
		String invert = menucreate.MainCharDataAux[3][classes.InvertRestrict];
		// We are going to decode the alignment masks
		boolean evil = false;
		boolean good = false;
		boolean chaotic = false;
		boolean lawful = false;
		boolean neutral = false;
		boolean moral = false;
		boolean ethical = false;
		boolean inverted = false;

		// Handle Inversion
		if (invert.equalsIgnoreCase("1"))
			inverted = true;

		// Handle Types
		if (type.equalsIgnoreCase("0x01") || type.equalsIgnoreCase("0x1"))
			ethical = true;
		else if (type.equalsIgnoreCase("0x02") || type.equalsIgnoreCase("0x2"))
			moral = true;
		else if (type.equalsIgnoreCase("0x03")
				|| type.equalsIgnoreCase("0x3")) {
			ethical = true;
			moral = true;
		}
		// This isn't complete as it should throw an error for an illformed
		// type (this assumes the other value is some form of 0).
		else if (!restricted.equalsIgnoreCase("0x0")
				&& !restricted.equalsIgnoreCase("0x00")
				&& !restricted.equalsIgnoreCase("0")
				&& !restricted.equalsIgnoreCase("****")) {
			throw new Exception("Invalid Restriction Type in classes.2da.");
		}

		if (restricted.equalsIgnoreCase("0x01"))
			neutral = true;
		else if (restricted.equalsIgnoreCase("0x02"))
			lawful = true;
		else if (restricted.equalsIgnoreCase("0x03")) {
			neutral = true;
			lawful = true;
		}
		else if (restricted.equalsIgnoreCase("0x04"))
			chaotic = true;
		else if (restricted.equalsIgnoreCase("0x05")) {
			neutral = true;
			chaotic = true;
		}
		else if (restricted.equalsIgnoreCase("0x06")) {
			lawful = true;
			chaotic = true;
		}
		else if (restricted.equalsIgnoreCase("0x07")) {
			neutral = true;
			chaotic = true;
			lawful = true;
		}
		else if (restricted.equalsIgnoreCase("0x08"))
			good = true;
		else if (restricted.equalsIgnoreCase("0x09")) {
			neutral = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0A")) {
			lawful = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0B")) {
			neutral = true;
			lawful = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0C")) {
			chaotic = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0D")) {
			neutral = true;
			chaotic = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0E")) {
			lawful = true;
			chaotic = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x0F")) {
			neutral = true;
			lawful = true;
			chaotic = true;
			good = true;
		}
		else if (restricted.equalsIgnoreCase("0x10"))
			evil = true;
		else if (restricted.equalsIgnoreCase("0x11")) {
			neutral = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x12")) {
			lawful = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x13")) {
			neutral = true;
			lawful = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x14")) {
			chaotic = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x15")) {
			neutral = true;
			chaotic = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x16")) {
			lawful = true;
			chaotic = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x17")) {
			neutral = true;
			lawful = true;
			chaotic = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x18")) {
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x19")) {
			neutral = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1A")) {
			lawful = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1B")) {
			neutral = true;
			lawful = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1C")) {
			chaotic = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1D")) {
			neutral = true;
			chaotic = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1E")) {
			lawful = true;
			chaotic = true;
			good = true;
			evil = true;
		}
		else if (restricted.equalsIgnoreCase("0x1F")) {
			neutral = true;
			lawful = true;
			chaotic = true;
			good = true;
			evil = true;
		}
		// why is this code in here twice?
		else if (!restricted.equalsIgnoreCase("0x00")
				&& !restricted.equalsIgnoreCase("0x0")
				&& !restricted.equalsIgnoreCase("0")
				&& !restricted.equalsIgnoreCase("****")) {
			throw new Exception("Invalid Alignment Restriction in classes.2da.");
		}

		if ((good || evil) && !moral)
			throw new Exception("Invalid Alignment Restriction Type in classes.2da.");

		if ((lawful || chaotic) && !ethical)
			throw new Exception("Invalid Alignment Restriction Type in classes.2da.");

		// In normal case, set the button enables to match !inverted.
		// Then as the restrictions are applied, set them equal to inverted.
		// Sets then all enables if InvertRestric != 1
		LGButton.setEnabled(!inverted);
		LNButton.setEnabled(!inverted);
		LEButton.setEnabled(!inverted);
		NGButton.setEnabled(!inverted);
		TNButton.setEnabled(!inverted);
		NEButton.setEnabled(!inverted);
		CGButton.setEnabled(!inverted);
		CNButton.setEnabled(!inverted);
		CEButton.setEnabled(!inverted);

        // if InvertRestric != 1, then this code disables the buttons
        // based on if that type of alignment is restricted.
		if (evil && moral) {
			LEButton.setEnabled(inverted);
			NEButton.setEnabled(inverted);
			CEButton.setEnabled(inverted);
		}
		if (good && moral) {
			LGButton.setEnabled(inverted);
			NGButton.setEnabled(inverted);
			CGButton.setEnabled(inverted);
		}
		if (chaotic && ethical) {
			CGButton.setEnabled(inverted);
			CNButton.setEnabled(inverted);
			CEButton.setEnabled(inverted);
		}
		if (lawful && ethical) {
			LGButton.setEnabled(inverted);
			LNButton.setEnabled(inverted);
			LEButton.setEnabled(inverted);
		}
		if (neutral) {
			if (moral) {
				LNButton.setEnabled(inverted);
				TNButton.setEnabled(inverted);
				CNButton.setEnabled(inverted);
			}
			if (ethical) {
				NGButton.setEnabled(inverted);
				TNButton.setEnabled(inverted);
				NEButton.setEnabled(inverted);
			}
	}

        OKButton.setEnabled(false);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        AlignmentButtons = new javax.swing.ButtonGroup();
        LGButton = new javax.swing.JToggleButton();
        LNButton = new javax.swing.JToggleButton();
        LEButton = new javax.swing.JToggleButton();
        NGButton = new javax.swing.JToggleButton();
        TNButton = new javax.swing.JToggleButton();
        NEButton = new javax.swing.JToggleButton();
        CGButton = new javax.swing.JToggleButton();
        CNButton = new javax.swing.JToggleButton();
        CEButton = new javax.swing.JToggleButton();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Select Alignment");
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        LGButton.setText("Lawful Good");
        AlignmentButtons.add(LGButton);
        LGButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LGButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(LGButton, gridBagConstraints);

        LNButton.setText("Lawful Neutral");
        AlignmentButtons.add(LNButton);
        LNButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LNButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(LNButton, gridBagConstraints);

        LEButton.setText("Lawful Evil");
        AlignmentButtons.add(LEButton);
        LEButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LEButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(LEButton, gridBagConstraints);

        NGButton.setText("Neutral Good");
        AlignmentButtons.add(NGButton);
        NGButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                NGButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(NGButton, gridBagConstraints);

        TNButton.setText("True Neutral");
        AlignmentButtons.add(TNButton);
        TNButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                TNButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(TNButton, gridBagConstraints);

        NEButton.setText("Neutral Evil");
        AlignmentButtons.add(NEButton);
        NEButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                NEButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(NEButton, gridBagConstraints);

        CGButton.setText("Chaotic Good");
        AlignmentButtons.add(CGButton);
        CGButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CGButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(CGButton, gridBagConstraints);

        CNButton.setText("Chaotic Neutral");
        AlignmentButtons.add(CNButton);
        CNButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CNButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(CNButton, gridBagConstraints);

        CEButton.setText("Chaotic Evil");
        AlignmentButtons.add(CEButton);
        CEButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CEButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(CEButton, gridBagConstraints);

        jPanel1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jPanel1MouseClicked(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel3, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 6;
        getContentPane().add(jPanel4, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
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
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        pack();
    }//GEN-END:initComponents

    private void jPanel1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel1MouseClicked
        // Add your handling code here:
    }//GEN-LAST:event_jPanel1MouseClicked

    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed

    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        if(GoodEvil == 15)
            if(LawfulChaotic == 15)
                alignlabel.setText("Chaotic Evil");
            else
            if(LawfulChaotic == 50)
                alignlabel.setText("Neutral Evil");
            else
            if(LawfulChaotic == 85)
                alignlabel.setText("Lawful Evil");
        if(GoodEvil == 50)
            if(LawfulChaotic == 15)
                alignlabel.setText("Chaotic Neutral");
            else
            if(LawfulChaotic == 50)
                alignlabel.setText("True Neutral");
            else
            if(LawfulChaotic == 85)
                alignlabel.setText("Lawful Neutral");
        if(GoodEvil == 85)
            if(LawfulChaotic == 15)
                alignlabel.setText("Chaotic Good");
            else
            if(LawfulChaotic == 50)
                alignlabel.setText("Neutral Good");
            else
            if(LawfulChaotic == 85)
                alignlabel.setText("Lawful Good");
        menucreate.MainCharData[4] = new HashMap();
        menucreate.MainCharData[4].put(new Integer(0), new Integer(LawfulChaotic));
        menucreate.MainCharData[4].put(new Integer(1), new Integer(GoodEvil));
        //System.out.println("LawfulChaotic: " + LawfulChaotic + " GoodEvil: " + GoodEvil);
        menucreate.AbilitiesButton.setEnabled(true);
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed

    private void CEButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CEButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 15;
        LawfulChaotic = 15;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_CEButtonActionPerformed

    private void CNButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CNButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 50;
        LawfulChaotic = 15;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_CNButtonActionPerformed

    private void CGButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CGButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 85;
        LawfulChaotic = 15;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_CGButtonActionPerformed

    private void NEButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_NEButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 15;
        LawfulChaotic = 50;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_NEButtonActionPerformed

    private void TNButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TNButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 50;
        LawfulChaotic = 50;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_TNButtonActionPerformed

    private void NGButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_NGButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 85;
        LawfulChaotic = 50;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_NGButtonActionPerformed

    private void LEButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LEButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 15;
        LawfulChaotic = 85;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_LEButtonActionPerformed

    private void LNButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LNButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 50;
        LawfulChaotic = 85;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_LNButtonActionPerformed

    private void LGButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LGButtonActionPerformed
        // Add your handling code here:
        GoodEvil = 85;
        LawfulChaotic = 85;
        OKButton.setEnabled(true);
    }//GEN-LAST:event_LGButtonActionPerformed

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        menucreate.BlockWindow(false);
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm



    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup AlignmentButtons;
    private javax.swing.JToggleButton CEButton;
    private javax.swing.JToggleButton CGButton;
    private javax.swing.JToggleButton CNButton;
    private javax.swing.JButton CancelButton;
    private javax.swing.JToggleButton LEButton;
    private javax.swing.JToggleButton LGButton;
    private javax.swing.JToggleButton LNButton;
    private javax.swing.JToggleButton NEButton;
    private javax.swing.JToggleButton NGButton;
    private javax.swing.JButton OKButton;
    private javax.swing.JToggleButton TNButton;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    // End of variables declaration//GEN-END:variables
    public int GoodEvil;
    public int LawfulChaotic;
    private JLabel alignlabel;
    private CreateMenu menucreate;
}
