/*
 * SpellMenu.java
 *
 * Created on March 16, 2003, 11:58 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.EtchedBorder;
import javax.swing.JOptionPane;
import CharacterCreator.defs.*;
import CharacterCreator.util.*;
/**
 *
 * @author  James
 */
public class SpellMenu extends javax.swing.JFrame {
    
    public class Spell0AvailButton extends JPanel {
        private void initComponents() {
            setLayout(new GridBagLayout());

            spellButton = new JButton();
            spellButton.setBackground(new Color(0, 0, 0));
            spellButton.setForeground(new Color(204, 204, 0));
            spellButton.setHorizontalAlignment(2);
            spellButton.setIconTextGap(15);
            spellButton.setPreferredSize(new Dimension(240, 52));

            spellButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent evt) {
                    Spell0AvailActionPerformed(evt);
                }
            });

            spellButton.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    Spell0AvailButtonMouseClicked(evt);
                }
            });

            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(spellButton, gridBagConstraints);
        }
        
        private void Spell0AvailActionPerformed(ActionEvent evt) {
            Spells0List.add(spell.Index());
            Spells0Left--;

            if(Spells1Left == 0 && Spells0Left == 0)
				OKButton.setEnabled(true);

            RefreshSpell0Available();
            RefreshSpell0Selected();
        }
        
        private void Spell0AvailButtonMouseClicked(java.awt.event.MouseEvent evt) {
            // Add your handling code here:
            if(evt.getButton() == 3) {
                JOptionPane.showMessageDialog(
						null,
						WordWrap.wrap(spell.Description, 80),
						spell.Spell,
						JOptionPane.PLAIN_MESSAGE,
						spell.Icon()
					);
            }
        }
        
		private JButton spellButton;
		private Spell spell;

		public Spell0AvailButton(Spell _spell) throws IOException {
			spell = _spell;
            initComponents();

			spellButton.setIcon(spell.Icon());
			spellButton.setDisabledIcon(spell.Icon());
			spellButton.setText(spell.Spell);
        }
    }
    
    public class Spell0SelectedButton extends JPanel {
        private void initComponents() {
            setLayout(new GridBagLayout());

            spellButton = new JButton();
            spellButton.setBackground(new Color(0, 0, 0));
            spellButton.setForeground(new Color(204, 204, 0));
            spellButton.setHorizontalAlignment(2);
            spellButton.setIconTextGap(15);
            spellButton.setPreferredSize(new Dimension(240, 52));

            spellButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent evt) {
                    Spell0SelectedButtonActionPerformed(evt);
                }
            });

            spellButton.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    Spell0SelectedButtonMouseClicked(evt);
                }
            });

            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(spellButton, gridBagConstraints);
        }
        
        private void Spell0SelectedButtonActionPerformed(ActionEvent evt) {
            Spells0List.remove(spell.Index());
            Spells0Left++;

            OKButton.setEnabled(false);

            RefreshSpell0Available();
            RefreshSpell0Selected();
        }
        
        private void Spell0SelectedButtonMouseClicked(java.awt.event.MouseEvent evt) {
            // Add your handling code here:
            if(evt.getButton() == 3) {
                JOptionPane.showMessageDialog(
						null,
						WordWrap.wrap(spell.Description, 80),
						spell.Spell,
						JOptionPane.PLAIN_MESSAGE,
						spell.Icon()
					);
            }
        }
        
		private JButton spellButton;
		private Spell spell;
        
        public Spell0SelectedButton(Spell _spell, boolean enabled) throws IOException {
			spell = _spell;
            initComponents();

			spellButton.setEnabled(enabled);
			spellButton.setIcon(spell.Icon());
			spellButton.setDisabledIcon(spell.Icon());
			spellButton.setText(spell.Spell);
        }
    }
    
    public class Spell1AvailButton extends JPanel {
        private void initComponents() {
            setLayout(new GridBagLayout());

            spellButton = new JButton();
            spellButton.setBackground(new Color(0, 0, 0));
            spellButton.setForeground(new Color(204, 204, 0));
            spellButton.setHorizontalAlignment(2);
            spellButton.setIconTextGap(15);
            spellButton.setPreferredSize(new Dimension(240, 52));

            spellButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent evt) {
                    Spell1AvailActionPerformed(evt);
                }
            });

            spellButton.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    Spell1AvailButtonMouseClicked(evt);
                }
            });

            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(spellButton, gridBagConstraints);
        }
        
        private void Spell1AvailActionPerformed(ActionEvent evt) {
            Spells1List.add(spell.Index());
            Spells1Left--;

            if(Spells1Left == 0 && Spells0Left == 0)
				OKButton.setEnabled(true);

            RefreshSpell1Available();
            RefreshSpell1Selected();
        }
        
        private void Spell1AvailButtonMouseClicked(java.awt.event.MouseEvent evt) {
            // Add your handling code here:
            if(evt.getButton() == 3) {
                JOptionPane.showMessageDialog(
						null,
						WordWrap.wrap(spell.Description, 80),
						spell.Spell,
						JOptionPane.PLAIN_MESSAGE,
						spell.Icon()
					);
            }
        }
        
		private JButton spellButton;
		private Spell spell;

		public Spell1AvailButton(Spell _spell) throws IOException {
			spell = _spell;
            initComponents();

			spellButton.setIcon(spell.Icon());
			spellButton.setDisabledIcon(spell.Icon());
			spellButton.setText(spell.Spell);
        }
    }
    
    public class Spell1SelectedButton extends JPanel {
        private void initComponents() {
            setLayout(new GridBagLayout());

            spellButton = new JButton();
            spellButton.setBackground(new Color(0, 0, 0));
            spellButton.setForeground(new Color(204, 204, 0));
            spellButton.setHorizontalAlignment(2);
            spellButton.setIconTextGap(15);
            spellButton.setPreferredSize(new Dimension(240, 52));
                
            spellButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent evt) {
                    Spell1SelectedButtonActionPerformed(evt);
                }
            });

            spellButton.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    Spell1SelectedButtonMouseClicked(evt);
                }
            });

            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(spellButton, gridBagConstraints);
        }
        
        private void Spell1SelectedButtonActionPerformed(ActionEvent evt) {
            Spells1List.remove(spell.Index());
            Spells1Left++;

            OKButton.setEnabled(false);

            RefreshSpell1Available();
            RefreshSpell1Selected();
        }
        
        private void Spell1SelectedButtonMouseClicked(java.awt.event.MouseEvent evt) {
            // Add your handling code here:
            if(evt.getButton() == 3) {
                JOptionPane.showMessageDialog(
						null,
						WordWrap.wrap(spell.Description, 80),
						spell.Spell,
						JOptionPane.PLAIN_MESSAGE,
						spell.Icon()
					);
            }
        }
        
		private JButton spellButton;
		private Spell spell;
        
		public Spell1SelectedButton(Spell _spell) throws IOException {
			spell = _spell;
            initComponents();

			spellButton.setIcon(spell.Icon());
			spellButton.setDisabledIcon(spell.Icon());
			spellButton.setText(spell.Spell);
        }
    }

    /** Creates new form SpellMenu */
    public SpellMenu() {
        initialized = false;
        oppletter = "";
        Spells0List = new LinkedList();
        Spells1List = new LinkedList();
        Spells0AvailList = new LinkedList();
        Spells1AvailList = new LinkedList();
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
        menucreate = TLKFactory.getCreateMenu();
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
		spellmap = SpellMap.GetSpellMap();
        try {
            SpellSelectedTabs.setIconAt(0, RESFAC.getIcon("ir_cantrips"));
            SpellSelectedTabs.setIconAt(1, RESFAC.getIcon("ir_level1"));
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Error - Your data files might be corrupt.", "Error", 0);
			err.printStackTrace();
            System.exit(0);
        }
        try {
            schoolmap = RESFAC.getResourceAs2DA("spellschools");
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - spellschools.2da not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        int i;
        classn = Integer.parseInt(menucreate.MainCharDataAux[3][0]);
        
        if(classn == 10) {
            int school = ((Integer)menucreate.MainCharData[16].get(new Integer(0))).intValue();
            if(school != 0) {
                int opposition = Integer.parseInt(schoolmap[school][4]);
                oppletter = schoolmap[opposition][2];
            }
        }
        
        
        for (int ii = 0; ii < spellmap.length; ++ii) {
			if (spellmap[ii] != null) {
				//BARD SPELL CHECK
				if (classn == 1) {
					if (spellmap[ii].Bard == 0)
						Spells0AvailList.add(spellmap[ii].Index());
					if (spellmap[ii].Bard == 1)
						Spells1AvailList.add(spellmap[ii].Index());
				}
				else if (classn == 9 || classn == 10) {
					//SORC/WIZ SPELL CHECK
					if (spellmap[ii].Wiz_Sorc == 0)
						Spells0AvailList.add(spellmap[ii].Index());
					if (spellmap[ii].Wiz_Sorc == 1) {
						if (classn == 10 && !spellmap[ii].School.equalsIgnoreCase(oppletter))
							Spells1AvailList.add(spellmap[ii].Index());
						if (classn == 9)
							Spells1AvailList.add(spellmap[ii].Index());
					}
				}
			}
        }
        
        if(classn == 10) {
            Spells0List = Spells0AvailList;
        }
        intmod = new Integer(((String)menucreate.MainCharData[5].get(new Integer(15)))).intValue();
        if(classn == 10) {
            Spells0Left = 0;
            Spells1Left = 3 + intmod;
        } else {
            
            String spknowntable = menucreate.MainCharDataAux[3][classes.SpellKnownTable];
            try {
                spknownmap = RESFAC.getResourceAs2DA(spknowntable);
            }
            catch(IOException err) {
                JOptionPane.showMessageDialog(null, "Fatal Error - " + spknowntable + " not found. Your data files might be corrupt.", "Error", 0);
                System.exit(0);
            }
            if(classn == 9) {
                Spells0Left = Integer.parseInt(spknownmap[0][2]);
                Spells1Left = Integer.parseInt(spknownmap[0][3]);
            }
            if(classn == 1) {
                Spells0Left = Integer.parseInt(spknownmap[0][2]);
                Spells1Left = 0;
            }
        }
        
        
        initialized = true;
        
        RefreshSpell0Available();
        RefreshSpell1Available();
        RefreshSpell0Selected();
        pack();
    }
    
    private void RefreshSpell0Available() {
        String imagestring = "";
        Spell0ButtonList.removeAll();
		if (Spells0Left > 0) {
			try {
				ArrayList al = new ArrayList();
				for (int ii = 0; ii < spellmap.length; ++ii)
					if (spellmap[ii] != null)
						if (Spells0AvailList.contains(spellmap[ii].Index()))
							if (!Spells0List.contains(spellmap[ii].Index()))
								al.add(spellmap[ii]);

				Collections.sort(al);
				for (int ii=0; ii<al.size(); ++ii)
					Spell0ButtonList.add(new Spell0AvailButton((Spell)al.get(ii)), -1);
			}
			catch(IOException err) {
				JOptionPane.showMessageDialog(null, "2Error - " + imagestring + " not found. Your data files might be corrupt.", "Error", 0);
				err.printStackTrace();
				System.exit(0);
			}
		}
        pack();
    }
    
    
    private void RefreshSpell1Available() {
        String imagestring = "";
        Spell1ButtonList.removeAll();
		if (Spells1Left > 0) {
			try {
				ArrayList al = new ArrayList();
				for (int ii = 0; ii < spellmap.length; ++ii)
					if (spellmap[ii] != null)
						if (Spells1AvailList.contains(spellmap[ii].Index()))
							if (!Spells1List.contains(spellmap[ii].Index()))
								al.add(spellmap[ii]);

				Collections.sort(al);
				for (int ii=0; ii<al.size(); ++ii)
					Spell1ButtonList.add(new Spell1AvailButton((Spell)al.get(ii)), -1);
			}
			catch(IOException err) {
				JOptionPane.showMessageDialog(null, "3Error - " + imagestring + " not found. Your data files might be corrupt.", "Error", 0);
				err.printStackTrace();
				System.exit(0);
			}
		}
        pack();
    }
    
    private void RefreshSpell0Selected() {
        String imagestring = "";
        SpellSelectedButtonList.removeAll();
        SpellsRemainingText.setText(Integer.toString(Spells0Left));

        try {
			ArrayList al = new ArrayList();
            for (int ii = 0; ii < spellmap.length; ++ii)
                if (spellmap[ii] != null)
                    if (Spells0List.contains(spellmap[ii].Index()))
						al.add(spellmap[ii]);

			Collections.sort(al);
			for (int ii=0; ii<al.size(); ++ii)
				SpellSelectedButtonList.add(new Spell0SelectedButton((Spell)al.get(ii), classn != 10), -1);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "4Error - " + imagestring + " not found. Your data files might be corrupt.", "Error", 0);
			err.printStackTrace();
            System.exit(0);
        }
        pack();
    }
    
    private void RefreshSpell1Selected() {
        String imagestring = "";
        SpellSelectedButtonList.removeAll();
        SpellsRemainingText.setText(Integer.toString(Spells1Left));

        try {
			ArrayList al = new ArrayList();
            for (int ii = 0; ii < spellmap.length; ++ii)
                if (spellmap[ii] != null)
                    if (Spells1List.contains(spellmap[ii].Index()))
						al.add(spellmap[ii]);

			Collections.sort(al);
			for (int ii=0; ii<al.size(); ++ii)
				SpellSelectedButtonList.add(new Spell1SelectedButton((Spell)al.get(ii)), -1);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "5Error - " + imagestring + " not found. Your data files might be corrupt.", "Error", 0);
			err.printStackTrace();
            System.exit(0);
        }
        pack();
    }
    
    private void DoReset() {
        if(classn == 10) {
            Spells0Left = 0;
            Spells1Left = 3 + intmod;
        } else {
            if(classn == 9) {
                Spells0Left = Integer.parseInt(spknownmap[0][2]);
                Spells1Left = Integer.parseInt(spknownmap[0][3]);
            }
            if(classn == 1) {
                Spells0Left = Integer.parseInt(spknownmap[0][2]);
                Spells1Left = 0;
            }
        }
        
        Spells1List.clear();
        if(classn != 10) {
            Spells0List.clear();
        }
        OKButton.setEnabled(false);
        SpellSelectedTabs.setSelectedIndex(0);
        RefreshSpell0Available();
        RefreshSpell1Available();
        RefreshSpell0Selected();
        pack();
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        SpellSelectedTabs = new javax.swing.JTabbedPane();
        Spell0ButtonContainer = new javax.swing.JScrollPane();
        Spell0ButtonBak = new javax.swing.JPanel();
        Spell0ButtonList = new javax.swing.JPanel();
        Spell1ButtonContainer = new javax.swing.JScrollPane();
        Spell1ButtonBak = new javax.swing.JPanel();
        Spell1ButtonList = new javax.swing.JPanel();
        SpellSelectedButtonContainer = new javax.swing.JScrollPane();
        SpellSelectedButtonBak = new javax.swing.JPanel();
        SpellSelectedButtonList = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();
        SpellsRemainingLabel = new javax.swing.JLabel();
        SpellsRemainingText = new javax.swing.JTextField();
        jPanel18 = new javax.swing.JPanel();
        RecommendedButton = new javax.swing.JButton();
        ResetButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();

        getContentPane().setLayout(new java.awt.GridBagLayout());

	   setTitle("Spell Menu"); 
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        getContentPane().add(jPanel1, new java.awt.GridBagConstraints());

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        getContentPane().add(jPanel7, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel8, gridBagConstraints);

        SpellSelectedTabs.setBackground(new java.awt.Color(0, 0, 0));
        SpellSelectedTabs.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        SpellSelectedTabs.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                SpellSelectedTabsStateChanged(evt);
            }
        });

        Spell0ButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        Spell0ButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        Spell0ButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(153, 153, 0)));
        Spell0ButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        Spell0ButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        Spell0ButtonContainer.setAutoscrolls(true);
		Spell0ButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		Spell0ButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        Spell0ButtonBak.setLayout(new java.awt.GridBagLayout());

        Spell0ButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        Spell0ButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        Spell0ButtonBak.setAlignmentX(0.0F);
        Spell0ButtonBak.setAlignmentY(0.0F);
        Spell0ButtonBak.setAutoscrolls(true);
        Spell0ButtonList.setLayout(new java.awt.GridLayout(0, 1));

        Spell0ButtonList.setBackground(new java.awt.Color(0, 0, 0));
        Spell0ButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        Spell0ButtonBak.add(Spell0ButtonList, gridBagConstraints);

        Spell0ButtonContainer.setViewportView(Spell0ButtonBak);

        SpellSelectedTabs.addTab("", Spell0ButtonContainer);

        Spell1ButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        Spell1ButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        Spell1ButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(153, 153, 0)));
        Spell1ButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        Spell1ButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        Spell1ButtonContainer.setAutoscrolls(true);
		Spell1ButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		Spell1ButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        Spell1ButtonBak.setLayout(new java.awt.GridBagLayout());

        Spell1ButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        Spell1ButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        Spell1ButtonBak.setAlignmentX(0.0F);
        Spell1ButtonBak.setAlignmentY(0.0F);
        Spell1ButtonBak.setAutoscrolls(true);
        Spell1ButtonList.setLayout(new java.awt.GridLayout(0, 1));

        Spell1ButtonList.setBackground(new java.awt.Color(0, 0, 0));
        Spell1ButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        Spell1ButtonBak.add(Spell1ButtonList, gridBagConstraints);

        Spell1ButtonContainer.setViewportView(Spell1ButtonBak);

        SpellSelectedTabs.addTab("", Spell1ButtonContainer);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(SpellSelectedTabs, gridBagConstraints);

        SpellSelectedButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        SpellSelectedButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        SpellSelectedButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(153, 153, 0)));
        SpellSelectedButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        SpellSelectedButtonContainer.setPreferredSize(new java.awt.Dimension(283, 300));
        SpellSelectedButtonContainer.setAutoscrolls(true);
		SpellSelectedButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		SpellSelectedButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        SpellSelectedButtonBak.setLayout(new java.awt.GridBagLayout());

        SpellSelectedButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        SpellSelectedButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        SpellSelectedButtonBak.setAlignmentX(0.0F);
        SpellSelectedButtonBak.setAlignmentY(0.0F);
        SpellSelectedButtonBak.setAutoscrolls(true);
        SpellSelectedButtonList.setLayout(new java.awt.GridLayout(0, 1));

        SpellSelectedButtonList.setBackground(new java.awt.Color(0, 0, 0));
        SpellSelectedButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SpellSelectedButtonBak.add(SpellSelectedButtonList, gridBagConstraints);

        SpellSelectedButtonContainer.setViewportView(SpellSelectedButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(SpellSelectedButtonContainer, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 6;
        getContentPane().add(jPanel17, gridBagConstraints);

        SpellsRemainingLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        SpellsRemainingLabel.setText("Remaining Spells");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(SpellsRemainingLabel, gridBagConstraints);

        SpellsRemainingText.setEditable(false);
        SpellsRemainingText.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        SpellsRemainingText.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        SpellsRemainingText.setText("0");
        SpellsRemainingText.setBorder(null);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 20;
        getContentPane().add(SpellsRemainingText, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel18, gridBagConstraints);

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

        ResetButton.setText("Reset");
        ResetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResetButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(ResetButton, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
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
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        pack();
    }//GEN-END:initComponents
    
    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        try{
            menucreate.MainCharData[10] = new HashMap();
            menucreate.MainCharData[10].put(new Integer(0),new Integer(Spells0List.size()));
            for(int i = 0; i < Spells0List.size(); i++) {
                menucreate.MainCharData[10].put(new Integer(i+1),Spells0List.get(i));
            }
            menucreate.MainCharData[11] = new HashMap();
            menucreate.MainCharData[11].put(new Integer(0),new Integer(Spells1List.size()));
            for(int i = 0; i < Spells1List.size(); i++) {
                menucreate.MainCharData[11].put(new Integer(i+1),Spells1List.get(i));
            }
            
            LinkedList featmap = new LinkedList();
            int numfeats = ((Integer)menucreate.MainCharData[9].get(new Integer(0))).intValue();
            for(int q = 0; q<numfeats; q++) {
                featmap.add(((Integer)menucreate.MainCharData[9].get(new Integer(1+q))));
            }
            menucreate.MainCharData[14] = new HashMap();
            //Animal Companion
            if(featmap.contains(new Integer(199)) && !featmap.contains(new Integer(303))) {
                (new CompanionMenu()).show();
                menucreate.RedoAll();
                setVisible(false);
                dispose();
                return;
            }
            //Familiar
            if(featmap.contains(new Integer(303)) && !featmap.contains(new Integer(199))) {
                (new FamiliarMenu()).show();
                menucreate.RedoAll();
                setVisible(false);
                dispose();
                return;
            }
            //BOTH
            if(featmap.contains(new Integer(303)) && featmap.contains(new Integer(199))) {
                //Companion first
                (new CompanionMenu()).show();
                menucreate.RedoAll();
                setVisible(false);
                dispose();
                return;
            }
            menucreate.CustomizeButton.setEnabled(true);
            menucreate.RedoAll();
            setVisible(false);
            dispose();
        }
        catch(Exception err) {
            JOptionPane.showMessageDialog(null, "Error: " + err, "Error", 0);
            System.exit(0);
        }
    }//GEN-LAST:event_OKButtonActionPerformed
    
    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RecommendedButtonActionPerformed
        // Add your handling code here:
        String spellpref2da = ((String)menucreate.MainCharData[7].get(new Integer(packages.SpellPref2DA)));
        //System.out.println("Spell Pref 2da: " + spellpref2da);
        String[][] spellpref2damap = null;
        try {
            spellpref2damap = RESFAC.getResourceAs2DA(spellpref2da);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + spellpref2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        int i;
        String spknowntable = menucreate.MainCharDataAux[3][classes.SpellKnownTable];
        DoReset();
        
        if(spknowntable == null) {
            //Wizard stuff
            //int sk0 = 4; //Make this all 0 level spells?
            //int sk1 = 3 + intmod;
            //spellsknown0 = wiz0lvl;
            int entrynumber = 0;
            for(i = 0; i < Spells1Left; i++) {
                if(Spells1AvailList.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                    Spells1List.add(new Integer(spellpref2damap[entrynumber][1]));
                    entrynumber++;
                } else {
                    i--;
                    entrynumber++;
                }
            }
            Spells1Left = 0;
            Spells0Left = 0;
            SpellSelectedTabs.setSelectedIndex(0);
            RefreshSpell0Available();
            RefreshSpell1Available();
            RefreshSpell0Selected();
            OKButton.setEnabled(true);
            pack();
        } else {
            //Bard and sorc stuff
            //HAVE to determine, hard coded, whether class is bard or sorc
            try {
                spknownmap = RESFAC.getResourceAs2DA(spknowntable);
            }
            catch(IOException err) {
                JOptionPane.showMessageDialog(null, "Fatal Error - " + spknowntable + " not found. Your data files might be corrupt.", "Error", 0);
                System.exit(0);
            }
            
            if(classn == 9) { // Sorcerer
                int sk0 = Integer.parseInt(spknownmap[0][2]);
                int sk1 = Integer.parseInt(spknownmap[0][3]);
                //spellsknown0 = wiz0lvl;
                int entrynumber = 0;
                for(i = 0; i < sk0; i++) {
                    if(Spells0AvailList.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                        Spells0List.add(new Integer(spellpref2damap[entrynumber][1]));
                        entrynumber++;
                    } else {
                        i--;
                        entrynumber++;
                    }
                }
                entrynumber = 0;
                for(i = 0; i < sk1; i++) {
                    if(Spells1AvailList.contains(new Integer(spellpref2damap[entrynumber][1]))) {
                        Spells1List.add(new Integer(spellpref2damap[entrynumber][1]));
                        entrynumber++;
                    } else {
                        i--;
                        entrynumber++;
                    }
                }
                Spells1Left = 0;
                Spells0Left = 0;
                SpellSelectedTabs.setSelectedIndex(0);
                RefreshSpell0Available();
                RefreshSpell1Available();
                RefreshSpell0Selected();
                OKButton.setEnabled(true);
                pack();
            }
            if(classn == 1) { // Bard
                int sk0 = Integer.parseInt(spknownmap[0][2]);
                int entrythings = 0;
                for(i = 0; i < sk0; i++) {
                    if(Spells0AvailList.contains(new Integer(spellpref2damap[entrythings][1]))) {
                        Spells0List.add(new Integer(spellpref2damap[entrythings][1]));
                        entrythings++;
                    } else {
                        i--;
                        entrythings++;
                    }
                }
                Spells1Left = 0;
                Spells0Left = 0;
                SpellSelectedTabs.setSelectedIndex(0);
                RefreshSpell0Available();
                RefreshSpell1Available();
                RefreshSpell0Selected();
                OKButton.setEnabled(true);
                pack();
            }
        }
        
        System.out.println("Lv0: " + Spells0List.toString());
        System.out.println("Lv1: " + Spells1List.toString());
    }//GEN-LAST:event_RecommendedButtonActionPerformed
    
    private void ResetButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ResetButtonActionPerformed
        // Add your handling code here:
        DoReset();
    }//GEN-LAST:event_ResetButtonActionPerformed
    
    private void SpellSelectedTabsStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_SpellSelectedTabsStateChanged
        // Add your handling code here:
        if(initialized) {
            int selected = SpellSelectedTabs.getSelectedIndex();
            if(selected == 0) {
                RefreshSpell0Selected();
            }
            if(selected == 1) {
                RefreshSpell1Selected();
            }
        }
    }//GEN-LAST:event_SpellSelectedTabsStateChanged
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton OKButton;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JButton ResetButton;
    private javax.swing.JPanel Spell0ButtonBak;
    private javax.swing.JScrollPane Spell0ButtonContainer;
    private javax.swing.JPanel Spell0ButtonList;
    private javax.swing.JPanel Spell1ButtonBak;
    private javax.swing.JScrollPane Spell1ButtonContainer;
    private javax.swing.JPanel Spell1ButtonList;
    private javax.swing.JPanel SpellSelectedButtonBak;
    private javax.swing.JScrollPane SpellSelectedButtonContainer;
    private javax.swing.JPanel SpellSelectedButtonList;
    private javax.swing.JTabbedPane SpellSelectedTabs;
    private javax.swing.JLabel SpellsRemainingLabel;
    private javax.swing.JTextField SpellsRemainingText;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel17;
    private javax.swing.JPanel jPanel18;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    // End of variables declaration//GEN-END:variables
    private String oppletter;
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    public Spell[] spellmap;
    public String[][] schoolmap;
    public String[][] spknownmap;
    private CreateMenu menucreate;
    private int Spells0Left;
    private int Spells1Left;
    private int classn;
    private int intmod;
    private LinkedList Spells0List;
    private LinkedList Spells1List;
    private LinkedList Spells0AvailList;
    private LinkedList Spells1AvailList;
    private boolean initialized;
}
