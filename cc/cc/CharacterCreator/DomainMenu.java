/*
 * DomainMenu.java
 *
 * Created on March 28, 2003, 10:17 PM
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
/**
 *
 * @author  James
 */
public class DomainMenu extends javax.swing.JFrame {
    
    public class DomainButton extends JPanel {
        private void initComponents() {
            domainbutton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            domainbutton.setBackground(new Color(0, 0, 0));
            domainbutton.setForeground(new Color(204, 204, 0));
            domainbutton.setIcon(new ImageIcon(getClass().getResource("/CharacterCreator/resource/folder.gif")));
            domainbutton.setText("Name Place Holder");
            domainbutton.setHorizontalAlignment(2);
            domainbutton.setIconTextGap(40);
            domainbutton.setPreferredSize(new Dimension(240, 52));
            domainbutton.addActionListener(new ActionListener() {
                
                public void actionPerformed(ActionEvent evt) {
                    DomainButtonActionPerformed(evt);
                }
                
            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(domainbutton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }
        
        private void DomainButtonActionPerformed(ActionEvent evt) {
            int tmp = Integer.parseInt(InfoNum.getText());
            int descnum = Integer.parseInt(domainmap[tmp][3]);
            DescriptionText.setText(TLKFAC.getEntry(descnum));
            domainlist.add(new Integer(tmp));
            numdomains--;
            if(numdomains == 0) OKButton.setEnabled(true);
            RefreshDomains();
            RefreshSelectedDomains();
            //CLASSNUM = tmp;
        }
        
        public JButton domainbutton;
        public JLabel InfoNum;
        
        public DomainButton(String imageName, String desc, String dText) {
            initComponents();

			try {
				ImageIcon icon = RESFAC.getIcon(imageName);
				if (icon != null)
					domainbutton.setIcon(icon);
			}
			catch (IOException e) {
				System.out.println("Invalid icon: " + imageName);
			}

			domainbutton.setText(desc);
			setSize(240, 52);
			InfoNum.setText(dText);
        }
    }
    
    public class DomainSelectedButton extends JPanel {
        private void initComponents() {
            domainbutton = new JButton();
            InfoNum = new JLabel();
            setLayout(new GridBagLayout());
            domainbutton.setBackground(new Color(0, 0, 0));
            domainbutton.setForeground(new Color(204, 204, 0));
            domainbutton.setIcon(new ImageIcon(getClass().getResource("/CharacterCreator/resource/folder.gif")));
            domainbutton.setText("Name Place Holder");
            domainbutton.setHorizontalAlignment(2);
            domainbutton.setIconTextGap(40);
            domainbutton.setPreferredSize(new Dimension(240, 52));
            domainbutton.addActionListener(new ActionListener() {
                
                public void actionPerformed(ActionEvent evt) {
                    DomainSelectedButtonActionPerformed(evt);
                }
                
            });
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(domainbutton, gridBagConstraints);
            InfoNum.setText("Num");
            gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            add(InfoNum, gridBagConstraints);
        }
        
        private void DomainSelectedButtonActionPerformed(ActionEvent evt) {
            int tmp = Integer.parseInt(InfoNum.getText());
            int descnum = Integer.parseInt(domainmap[tmp][3]);
            DescriptionText.setText(TLKFAC.getEntry(descnum));
            
            int indexof = domainlist.indexOf(new Integer(tmp));
            domainlist.remove(indexof);
            numdomains++;
            RefreshDomains();
            RefreshSelectedDomains();
            OKButton.setEnabled(false);
        }
        
        public JButton domainbutton;
        public JLabel InfoNum;
        
        
        public DomainSelectedButton(String imageName, String desc, String dText) {
            initComponents();

			try {
				ImageIcon icon = RESFAC.getIcon(imageName);
				if (icon != null)
					domainbutton.setIcon(icon);
			}
			catch (IOException e) {
				System.out.println("Invalid icon: " + imageName);
			}

			domainbutton.setText(desc);
			setSize(240, 52);
			InfoNum.setText(dText);
        }
    }
    /** Creates new form DomainMenu */
    public DomainMenu() {
        initComponents();
        
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();            
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        
        OKButton.setEnabled(false);
        numdomains = 2;
        menucreate = TLKFactory.getCreateMenu();
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        domainlist = new LinkedList();
        try {
            domainmap = RESFAC.getResourceAs2DA("domains");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - domains.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        RefreshDomains();
        pack();
    }
    
    private void RefreshDomains() {
        String imagestring = "";
        DomainButtonList.removeAll();
		if(numdomains > 0) {
			for(int i = 0; i < domainmap.length; i++) {
				if(domainmap[i][2] != null) {
					if(!domainlist.contains(new Integer(i))) {
						DomainButton domainbutton = new DomainButton(
								domainmap[i][4],
								TLKFAC.getEntry(Integer.parseInt(domainmap[i][2])),
								domainmap[i][0]
							);

						DomainButtonList.add(domainbutton, -1);
					}
				}
			}
		}
        pack();
    }
    
    private void RefreshSelectedDomains() {
        String imagestring = "";
        SelectedDomainList.removeAll();
		for(int i = 0; i < domainlist.size(); i++) {
			int domainnum = ((Integer)domainlist.get(i)).intValue();
			if(domainmap[domainnum][2] != null) {
				DomainSelectedButton domainbutton = new DomainSelectedButton(
						domainmap[domainnum][4],
						TLKFAC.getEntry(Integer.parseInt(domainmap[domainnum][2])),
						domainmap[domainnum][0]
					);

				SelectedDomainList.add(domainbutton, -1);
			}
		}
        pack();
        SelectedDomainList.repaint();
    }
    
    private void DoReset() {
        numdomains = 2;
        domainlist.clear();
        RefreshDomains();
        RefreshSelectedDomains();
        OKButton.setEnabled(false);
    }
    
    
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        DomainButtonContainer = new javax.swing.JScrollPane();
        DomainButtonBak = new javax.swing.JPanel();
        DomainButtonList = new javax.swing.JPanel();
        RecommendedButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        jPanel8 = new javax.swing.JPanel();
        jPanel9 = new javax.swing.JPanel();
        jPanel10 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();
        PadPanel = new javax.swing.JPanel();
        PadPanel2 = new javax.swing.JPanel();
        PadPanel3 = new javax.swing.JPanel();
        PadPanel4 = new javax.swing.JPanel();
        jPanel16 = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        SelectedDomainPanel = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        SelectedDomainList = new javax.swing.JPanel();
        ResetButton = new javax.swing.JButton();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Select your Domains");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        DomainButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        DomainButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        DomainButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(153, 153, 0)));
        DomainButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        DomainButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        DomainButtonContainer.setAutoscrolls(true);
		DomainButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		DomainButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        DomainButtonBak.setLayout(new java.awt.GridBagLayout());

        DomainButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        DomainButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        DomainButtonBak.setAlignmentX(0.0F);
        DomainButtonBak.setAlignmentY(0.0F);
        DomainButtonBak.setAutoscrolls(true);
        DomainButtonList.setLayout(new java.awt.GridLayout(0, 1));

        DomainButtonList.setBackground(new java.awt.Color(0, 0, 0));
        DomainButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DomainButtonBak.add(DomainButtonList, gridBagConstraints);

        DomainButtonContainer.setViewportView(DomainButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DomainButtonContainer, gridBagConstraints);

        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RecommendedButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(RecommendedButton, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 9;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 9;
        getContentPane().add(CancelButton, gridBagConstraints);

        DescriptionPanel.setLayout(new java.awt.GridBagLayout());

        DescriptionPanel.setBorder(new javax.swing.border.EtchedBorder());
        DescriptionText.setBackground(new java.awt.Color(0, 0, 0));
        DescriptionText.setForeground(new java.awt.Color(255, 255, 153));
        DescriptionText.setLineWrap(true);
        DescriptionText.setWrapStyleWord(true);
        DescriptionText.setPreferredSize(new java.awt.Dimension(400, 300));
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
        DescriptionPanel.add(jPanel8, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel9, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 14;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel10, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        DescriptionPanel.add(jPanel11, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DescriptionPanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 10;
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
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel17, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel1, gridBagConstraints);

        SelectedDomainPanel.setLayout(new java.awt.GridBagLayout());

        SelectedDomainPanel.setBorder(new javax.swing.border.EtchedBorder());
        SelectedDomainPanel.setPreferredSize(new java.awt.Dimension(300, 150));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        SelectedDomainPanel.add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        SelectedDomainPanel.add(jPanel7, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        SelectedDomainPanel.add(jPanel12, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        SelectedDomainPanel.add(jPanel13, gridBagConstraints);

        SelectedDomainList.setLayout(new java.awt.GridLayout(0, 1));

        SelectedDomainList.setBackground(new java.awt.Color(0, 0, 0));
        SelectedDomainList.setPreferredSize(new java.awt.Dimension(400, 125));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SelectedDomainPanel.add(SelectedDomainList, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(SelectedDomainPanel, gridBagConstraints);

        ResetButton.setText("Reset");
        ResetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResetButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(ResetButton, gridBagConstraints);

        pack();
    }//GEN-END:initComponents
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        int numfeats = (((Integer)menucreate.MainCharData[9].get(new Integer(0)))).intValue();
        int feat1 = Integer.parseInt(domainmap[((Integer)domainlist.get(0)).intValue()][14]);
        int feat2 = Integer.parseInt(domainmap[((Integer)domainlist.get(1)).intValue()][14]);
        menucreate.MainCharData[9].put(new Integer(numfeats + 1), new Integer(feat1));
        menucreate.MainCharData[9].put(new Integer(numfeats + 2), new Integer(feat2));
        numfeats += 2;
        menucreate.MainCharData[9].put(new Integer(0),new Integer(numfeats));
        
        menucreate.MainCharData[16].put(new Integer(1),(Integer)domainlist.get(0));
        menucreate.MainCharData[16].put(new Integer(2),(Integer)domainlist.get(1));
        
        menucreate.CustomizeButton.setEnabled(true);
		menucreate.RedoAll();
        setVisible(false);
        dispose();
    }//GEN-LAST:event_OKButtonActionPerformed
    
    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RecommendedButtonActionPerformed
        // Add your handling code here:
        DoReset();
        domainlist.add(new Integer(menucreate.MainCharDataAux[7][8]));
        domainlist.add(new Integer(menucreate.MainCharDataAux[7][9]));
        numdomains = 0;
        RefreshDomains();
        RefreshSelectedDomains();
        OKButton.setEnabled(true);
    }//GEN-LAST:event_RecommendedButtonActionPerformed
    
    private void ResetButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ResetButtonActionPerformed
        // Add your handling code here:
        DoReset();
    }//GEN-LAST:event_ResetButtonActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CancelButton;
    private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JPanel DomainButtonBak;
    private javax.swing.JScrollPane DomainButtonContainer;
    private javax.swing.JPanel DomainButtonList;
    private javax.swing.JButton OKButton;
    private javax.swing.JPanel PadPanel;
    private javax.swing.JPanel PadPanel2;
    private javax.swing.JPanel PadPanel3;
    private javax.swing.JPanel PadPanel4;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JButton ResetButton;
    private javax.swing.JPanel SelectedDomainList;
    private javax.swing.JPanel SelectedDomainPanel;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    // End of variables declaration//GEN-END:variables
    private int numdomains;
    private LinkedList domainlist;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public String[][] domainmap;
    private CreateMenu menucreate;
}
