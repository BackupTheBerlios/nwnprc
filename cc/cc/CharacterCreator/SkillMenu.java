/*
 * SkillMenu.java
 *
 * Created on March 16, 2003, 11:57 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.HashMap;
import java.util.LinkedList;
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
public class SkillMenu extends javax.swing.JFrame {
    
    // Start New
    // Garad Moonbeam
    // Attempting dynamic skill menu
    public class SkillButton extends JPanel {
        
        private void initComponents() {
            java.awt.GridBagConstraints gridBagConstraints;
            SkillButton = new JButton();        // Main part of SkillButton, has text and icon
            SkillSpinner = new JSpinner();      // Spinner for adjusting skill points
            InfoNum = new JLabel();             // Stores the index of the skill in skills.2da
            
            this.setLayout(new java.awt.GridBagLayout());
            this.setBackground(new java.awt.Color(0, 0, 0));
            this.setBorder(new javax.swing.border.BevelBorder(javax.swing.border.BevelBorder.RAISED, java.awt.Color.gray, java.awt.Color.lightGray, java.awt.Color.gray, java.awt.Color.lightGray));
            this.setPreferredSize(new java.awt.Dimension(264, 36));
            
            SkillButton.setBackground(new java.awt.Color(0, 0, 0));
            SkillButton.setForeground(new java.awt.Color(153, 153, 0));
            SkillButton.setText("Name Place Holder");
            SkillButton.setBorder(null);
            SkillButton.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
            SkillButton.setIconTextGap(10);
            SkillButton.setPreferredSize(new java.awt.Dimension(212, 32));
            SkillButton.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    SkillButtonActionPerformed(evt);
                }
            });
            
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
            gridBagConstraints.weightx = 1.0;
            this.add(SkillButton, gridBagConstraints);
            
            InfoNum.setText("Num");
            /*gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            this.add(InfoNum, gridBagConstraints);
             */
            
            SkillSpinner.setBorder(null);
            SkillSpinner.addChangeListener(new javax.swing.event.ChangeListener() {
                public void stateChanged(javax.swing.event.ChangeEvent evt) {
                    SkillSpinnerStateChanged(evt);
                }
            });
            
            gridBagConstraints = new java.awt.GridBagConstraints();
            gridBagConstraints.gridx = 1;
            gridBagConstraints.gridy = 0;
            gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
            gridBagConstraints.ipadx = 10;
            gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
            gridBagConstraints.insets = new java.awt.Insets(0, 11, 0, 0);
            this.add(SkillSpinner, gridBagConstraints);
        }
        
        private void SkillButtonActionPerformed(ActionEvent evt) {
            int tmp = Integer.parseInt(InfoNum.getText());
            DescriptionText.setText(skillmap[tmp].Description);
            DescriptionContainer.scrollRectToVisible(new Rectangle());
        }
        
        private void SkillSpinnerStateChanged(javax.swing.event.ChangeEvent evt) {
            int skillptsleft;
            int currentskill;
            int skillindex;
            JSpinner source = (JSpinner)evt.getSource();
            SkillButton parent = (SkillButton)source.getParent();
            
            skillindex = (new Integer(parent.InfoNum.getText())).intValue();
            DescriptionText.setText(skillmap[skillindex].Description);

            skillptsleft = new Integer(SkillPointText.getText()).intValue();
            if(skillptsleft > 3) {
                currentskill = new Integer(source.getValue().toString()).intValue();
                if(((Integer)skillnums.get(skillindex)).intValue() < currentskill) {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        --skillptsleft;
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        return;
                    }
                }
                else {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        ++skillptsleft;
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                }
            }
            else if(skillptsleft == 3) {
                currentskill = new Integer(source.getValue().toString()).intValue();
                if(((Integer)skillnums.get(skillindex)).intValue() < currentskill) {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        --skillptsleft;
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        LockCCSpinners();
                        return;
                    }
                }
                else {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        ++skillptsleft;
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                }
            }
            else if(skillptsleft == 2) {
                currentskill = new Integer(source.getValue().toString()).intValue();
                if(((Integer)skillnums.get(skillindex)).intValue() < currentskill) {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        LockCCSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        --skillptsleft;
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        LockSpinners();
                        return;
                    }
                }
                else {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        ++skillptsleft;
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                }
            }
            else if(skillptsleft == 1) {
                currentskill = new Integer(source.getValue().toString()).intValue();
                if(((Integer)skillnums.get(skillindex)).intValue() < currentskill) {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        skillnums.set(skillindex, new Integer(currentskill));
                        SkillPointText.setText(""  + (--skillptsleft));
                        LockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        --skillptsleft;
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        //System.out.println("Warning, this is causing a negative point value!");
                        LockSpinners();
                        return;
                    }
                }
                else {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        ++skillptsleft;
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                }
            }
            else if(skillptsleft == 0) {
                currentskill = new Integer(source.getValue().toString()).intValue();
                if(((Integer)skillnums.get(skillindex)).intValue() < currentskill) {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        //System.out.println("Warning, this is causing a negative point value!");
                        LockSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        --skillptsleft;
                        SkillPointText.setText(""  + (--skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        //System.out.println("Warning, this is causing a negative point value!");
                        LockSpinners();
                        return;
                    }
                }
                else {
                    if(((Integer)ccskill.get(skillindex)).intValue() == 1) {
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        LockCCSpinners();
                        return;
                    }
                    else if(((Integer)ccskill.get(skillindex)).intValue() == 0) {
                        ++skillptsleft;
                        SkillPointText.setText(""  + (++skillptsleft));
                        skillnums.set(skillindex, new Integer(currentskill));
                        UnlockSpinners();
                        return;
                    }
                }
            }
        }
        
        public JButton SkillButton;
        public JSpinner SkillSpinner;
        public JLabel InfoNum;
        
        public SkillButton(Skill skill) throws IOException {
            initComponents();

			SkillButton.setIcon(skill.Icon());
			SkillButton.setDisabledIcon(skill.Icon());
			SkillButton.setText(skill.Skill);

			setSize(240, 52);
			InfoNum.setText(skill.Index().toString());
			SkillSpinner.setModel(new CCSkillModel(0));
        }
    }
    // End New
    
    public class CCSkillModel extends javax.swing.SpinnerNumberModel {
        
        public CCSkillModel(int value) {
            setValue(new Integer(value));
            setMaximum(new Integer(2));
            setMinimum(new Integer(0));
            setStepSize(new Integer(1));
        }
        
    }
    
    public class ClassSkillModel extends javax.swing.SpinnerNumberModel {
        
        public ClassSkillModel(int value) {
            setValue(new Integer(value));
            setMaximum(new Integer(4));
            setMinimum(new Integer(0));
            setStepSize(new Integer(1));
        }
        
    }
    
    public class LockedSkillModel extends javax.swing.SpinnerNumberModel {
        
        public LockedSkillModel(int value, int maxvalue) {
            setValue(new Integer(value));
            setMaximum(new Integer(maxvalue));
            setMinimum(new Integer(0));
            setStepSize(new Integer(1));
        }
        
    }
    
    
    /** Creates new form SkillMenu */
    public SkillMenu() {
        // Start New
        // Garad Moonbeam
        // Attempting to add dynamic skill menu
        
        int baseskillpoints;
        int intmod;
        int racenumber;
        int skillindex;
        String racefeat2da;
        String classsk2da;
        SkillButton skillbutton;
        LinkedList featlist;
        
        ccskill = new LinkedList();
        skillnums = new LinkedList();
        
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
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        
        DescriptionText.setText(TLKFAC.getEntry(485));
		skillmap = SkillMap.GetSkillMap();
        
        // Set the size of SkillButtonList
        SkillButtonList = new SkillButton[skillmap.length];
        
        // Loop through the skills in skills.2da and create buttons for all valid ones
        try {
            for(int ii = 0; ii < skillmap.length; ii++) {
                if (skillmap[ii].Skill != null)
					skillbutton = new SkillButton(skillmap[ii]);
				else
					skillbutton = null;

                // Store the SkillButton in the SkillButtonList array for easy access later
                // Add an entry to ccskill and skillnums to represent this skill
                SkillButtonList[ii] = skillbutton;
                ccskill.add(null);
                skillnums.add(new Integer(0));
            }
        }
        catch (IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        
        // Get racial feats
        featlist = new LinkedList();
        racefeat2da = menucreate.MainCharDataAux[1][racialtypes.FeatsTable];
        
        classsk2da = menucreate.MainCharDataAux[3][classes.SkillsTable];
        String[][] classsk2damap = null;
        baseskillpoints = Integer.parseInt(menucreate.MainCharDataAux[3][classes.SkillPointBase]);
        try {
            classsk2damap = RESFAC.getResourceAs2DA(classsk2da);
            if(racefeat2da != null) {
                String[][] racefeat2damap = RESFAC.getResourceAs2DA(racefeat2da);

				for(int i = 0; i < racefeat2damap.length; i++)
					if(racefeat2damap[i][racefeat.FeatIndex] != null)
						featlist.add(new Integer(racefeat2damap[i][racefeat.FeatIndex]));
            }
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + classsk2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        
        // Determine starting skill points
        intmod = new Integer(((String)menucreate.MainCharData[5].get(new Integer(15)))).intValue();
        startskillpoints = 4 * (baseskillpoints + intmod);
        
        racenumber = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        //CHANGED due to the fact that Bioware HARD CODES the skill points to HUMANS.
        if(racenumber == 6) {
            //if(featlist.contains(new Integer(258))) {
            startskillpoints += 4;
        }
        SkillPointText.setText("" + startskillpoints);
        int i = 0;
        try{
            for(i=0; i < classsk2damap.length; i++) {
                if(classsk2damap[i][clsskill.SkillIndex] != null) {
                    skillindex = Integer.parseInt(classsk2damap[i][clsskill.SkillIndex]);
                    String tmpstr = classsk2damap[i][clsskill.ClassSkill];
                    int clssk;
                    if(tmpstr == null) {
                        clssk = 0;
                    } else {
                        clssk = Integer.parseInt(tmpstr);
                    }
                    if(clssk == 0)
                        ccskill.set(skillindex, new Integer(clssk));
                    else {
                        SkillButtonList[skillindex].SkillSpinner.setModel(new ClassSkillModel(0));
                        SkillButtonList[skillindex].SkillButton.setText(SkillButtonList[skillindex].SkillButton.getText() + " (Class Skill)");
                        ccskill.set(skillindex, (new Integer(classsk2damap[i][clsskill.ClassSkill])));
                    }
                    // Add the SkillButton to the interface (SkillSetButtonList)
                    SkillSetButtonList.add(SkillButtonList[skillindex], -1);
                }
            }
        }
        catch(NumberFormatException err) {
            JOptionPane.showMessageDialog(null, "2da Parse Error - " + classsk2da + ", line " + i + ".\nError returned: " + err, "Error", 0);
            System.exit(0);
        }
        
        pack();
        // End New
    }
    
    private void LockSpinners() {
        int currentvalue1;
        
        for(int i=0; i < SkillButtonList.length; i++) {
            if(ccskill.get(i) == null) {
                SkillButtonList[i].setVisible(false);
            } else {
                currentvalue1 = ((Integer)(SkillButtonList[i].SkillSpinner.getValue())).intValue();
                SkillButtonList[i].SkillSpinner.setModel(new LockedSkillModel(currentvalue1,currentvalue1));
            }
        }
    }
    
    private void LockCCSpinners() {
        int currentvalue1;
        
        for(int i = 0;i < SkillButtonList.length; i++) {
            if(ccskill.get(i) == null) {
                SkillButtonList[i].setVisible(false);
            } else {
                if(((Integer)ccskill.get(i)).intValue() == 0) {
                    currentvalue1 = ((Integer)(SkillButtonList[i].SkillSpinner.getValue())).intValue();
                    SkillButtonList[i].SkillSpinner.setModel(new LockedSkillModel(currentvalue1,currentvalue1));
                }
            }
        }
    }
    
    private void UnlockSpinners() {
        int currentvalue1;
        
        for(int i = 0;i < SkillButtonList.length; i++) {
            if(ccskill.get(i) == null) {
                SkillButtonList[i].setVisible(false);
            } else {
                if(((Integer)ccskill.get(i)).intValue() == 1) {
                    SkillButtonList[i].SkillSpinner.setModel(new ClassSkillModel(((Integer)SkillButtonList[i].SkillSpinner.getValue()).intValue()));
                }
                if(((Integer)ccskill.get(i)).intValue() == 0) {
                    SkillButtonList[i].SkillSpinner.setModel(new CCSkillModel(((Integer)SkillButtonList[i].SkillSpinner.getValue()).intValue()));
                }
            }
        }
    }
    
    private void ResetSpinners() {
        SkillPointText.setText("" + startskillpoints);
        for(int i = 0;i < SkillButtonList.length; i++) {
            skillnums.set(i,new Integer(0));
            if(ccskill.get(i) == null) {
                SkillButtonList[i].setVisible(false);
            } else {
                if(((Integer)ccskill.get(i)).intValue() == 1) {
                    SkillButtonList[i].SkillSpinner.setModel(new ClassSkillModel(0));
                }
                if(((Integer)ccskill.get(i)).intValue() == 0) {
                    SkillButtonList[i].SkillSpinner.setModel(new CCSkillModel(0));
                }
            }
        }
    }
    
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    
    //  TODO it appears that all of the skill listing is static, this needs to be changed to be dynamic in order to accomodate custom skills
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;
        
        SkillButtonContainer = new javax.swing.JScrollPane();
        SkillSetButtonBak = new javax.swing.JPanel();
        SkillSetButtonList = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        RecommendedButton = new javax.swing.JButton();
        jPanel9 = new javax.swing.JPanel();
        DescriptionContainer = new javax.swing.JScrollPane();
        DescriptionPanel = new javax.swing.JPanel();
        DescriptionText = new javax.swing.JTextArea();
        ResetButton = new javax.swing.JButton();
        SkillPointLabel = new javax.swing.JLabel();
        SkillPointText = new javax.swing.JTextField();
        jPanel14 = new javax.swing.JPanel();
        
        getContentPane().setLayout(new java.awt.GridBagLayout());
        
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });
        
        SkillButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        SkillButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        SkillButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        SkillButtonContainer.setPreferredSize(new java.awt.Dimension(308, 300));
        SkillButtonContainer.setAutoscrolls(true);
		SkillButtonContainer.getVerticalScrollBar().setUnitIncrement(36);
		SkillButtonContainer.getVerticalScrollBar().setBlockIncrement(36);
        SkillSetButtonBak.setLayout(new java.awt.GridBagLayout());
        
        SkillSetButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        SkillSetButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        SkillSetButtonBak.setAlignmentX(0.0F);
        SkillSetButtonBak.setAlignmentY(0.0F);
        SkillSetButtonBak.setAutoscrolls(true);
        SkillSetButtonList.setLayout(new java.awt.GridLayout(0, 1));
        
        SkillSetButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(SkillSetButtonList, gridBagConstraints);
        
        jPanel3.setBackground(new java.awt.Color(153, 153, 0));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(jPanel3, gridBagConstraints);
        
        jPanel4.setBackground(new java.awt.Color(153, 153, 0));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(jPanel4, gridBagConstraints);
        
        jPanel5.setBackground(new java.awt.Color(153, 153, 0));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(jPanel5, gridBagConstraints);
        
        jPanel6.setBackground(new java.awt.Color(153, 153, 0));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(jPanel6, gridBagConstraints);
        
        SkillButtonContainer.setViewportView(SkillSetButtonBak);
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(SkillButtonContainer, gridBagConstraints);
        
        getContentPane().add(jPanel1, new java.awt.GridBagConstraints());
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        getContentPane().add(jPanel2, gridBagConstraints);
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel7, gridBagConstraints);
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel8, gridBagConstraints);
        
        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        gridBagConstraints.insets = new java.awt.Insets(0, 50, 0, 0);
        getContentPane().add(OKButton, gridBagConstraints);
        
        CancelButton.setText("Cancel");
        CancelButton.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(CancelButton, gridBagConstraints);
        
        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RecommendedButtonActionPerformed(evt);
            }
        });
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(RecommendedButton, gridBagConstraints);
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 6;
        getContentPane().add(jPanel9, gridBagConstraints);
        
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
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 3;
        gridBagConstraints.gridheight = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(DescriptionContainer, gridBagConstraints);
        
        ResetButton.setText("Reset");
        ResetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResetButtonActionPerformed(evt);
            }
        });
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        getContentPane().add(ResetButton, gridBagConstraints);
        
        SkillPointLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        SkillPointLabel.setText("Skill Points Remaining:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        gridBagConstraints.insets = new java.awt.Insets(0, 0, 0, 25);
        getContentPane().add(SkillPointLabel, gridBagConstraints);
        
        SkillPointText.setEditable(false);
        SkillPointText.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        SkillPointText.setText("0");
        SkillPointText.setBorder(null);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.VERTICAL;
        gridBagConstraints.ipadx = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(SkillPointText, gridBagConstraints);
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel14, gridBagConstraints);
        
        pack();
    }
    
    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        
        String skill2da = menucreate.MainCharDataAux[7][packages.SkillPref2DA];
        String[][] skill2damap = null;
        try {
            skill2damap = RESFAC.getResourceAs2DA(skill2da);
        }
        catch (IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + skill2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        ResetSpinners();
        int skillentry = 0;
        for(int i = startskillpoints; i > 0; i--) {
            int entrynum = Integer.parseInt(skill2damap[skillentry][1]);
            //System.out.println("Entrynum: " + entrynum);
            //System.out.println("Current skill ranks: " + ((Integer)skilllist.get(entrynum)).intValue());
            if(
            (((Integer)SkillButtonList[entrynum].SkillSpinner.getValue()).intValue() < 4 && ((Integer)ccskill.get(entrynum)).intValue() == 1)
            ||
            (((Integer)SkillButtonList[entrynum].SkillSpinner.getValue()).intValue() < 2 && ((Integer)ccskill.get(entrynum)).intValue() == 0)
            ) {
                int oldnum = ((Integer)SkillButtonList[entrynum].SkillSpinner.getValue()).intValue();
                if(((Integer)ccskill.get(entrynum)).intValue() == 1) {
                    int val = new Integer(SkillButtonList[entrynum].SkillSpinner.getValue().toString()).intValue();
                    SkillButtonList[entrynum].SkillSpinner.setValue(new Integer(++val));
                }
                if(((Integer)ccskill.get(entrynum)).intValue() == 0) {
                    int val = new Integer(SkillButtonList[entrynum].SkillSpinner.getValue().toString()).intValue();
                    SkillButtonList[entrynum].SkillSpinner.setValue(new Integer(++val));
                    i--;
                }
            } else {
                skillentry++;
                i++;
            }
            SkillPointText.setText("0");
            LockSpinners();
			menucreate.skillPointsLeft = Integer.parseInt(SkillPointText.getText());
            //System.out.println("Current points: " + i);
        }
        
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
    }
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        setVisible(false);
        dispose();
    }
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        menucreate.MainCharData[8] = new HashMap();
        //  Start New
        //  Garad Moonbeam
        //  Trying to make skill menu dynamic
        for( int i=0; i < SkillButtonList.length; i++) {
            menucreate.MainCharData[8].put(new Integer(i), SkillButtonList[i].SkillSpinner.getValue());
        }

		menucreate.skillPointsLeft = Integer.parseInt(SkillPointText.getText());
		menucreate.RedoAll();
        
        //Put stuff in here to open feat menu
        (new FeatMenu()).show();
        
        setVisible(false);
        dispose();
    }
    
    private void ResetButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        ResetSpinners();
    }
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {
        setVisible(false);
        dispose();
    }
    
/*    /**
 * @param args the command line arguments
 */
/*    public static void main(String args[]) {
        new SkillMenu().show();
    }
 */
    
    // Variables declaration - do not modify
    private javax.swing.JButton CancelButton;
    private javax.swing.JScrollPane DescriptionContainer;
    private javax.swing.JPanel DescriptionPanel;
    private javax.swing.JTextArea DescriptionText;
    private javax.swing.JButton OKButton;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JButton ResetButton;
    private javax.swing.JScrollPane SkillButtonContainer;
    private javax.swing.JLabel SkillPointLabel;
    private javax.swing.JTextField SkillPointText;
    private javax.swing.JPanel SkillSetButtonBak;
    private javax.swing.JPanel SkillSetButtonList;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    // End of variables declaration
    private int startskillpoints;
    private LinkedList ccskill;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public Skill[] skillmap;
    private CreateMenu menucreate;
    private LinkedList skillnums;
    public int numskills = 0;
    private SkillButton[] SkillButtonList;
}
