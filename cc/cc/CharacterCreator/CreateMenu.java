/*
 * CreateMenu1.java
 *
 * Created on March 16, 2003, 11:18 AM
 */

package CharacterCreator;

import java.awt.event.*;
import javax.swing.event.MouseInputAdapter;
import java.awt.*;
import java.util.prefs.Preferences;
//import java.awt.event.ActionEvent;
//import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;
import java.util.*;
import javax.swing.*;
import javax.swing.border.EtchedBorder;
import CharacterCreator.util.*;
import CharacterCreator.defs.*;
/**
 *
 * @author  James
 */
public class CreateMenu extends javax.swing.JFrame {

    public class SpellButton extends JPanel {
        private void initComponents() {
            setLayout(new GridBagLayout());

            spellButton = new JButton();
            spellButton.setBackground(new Color(0, 0, 0));
            spellButton.setForeground(new Color(0, 0, 125));  // Where is this color used?
            spellButton.setHorizontalAlignment(2);
            spellButton.setIconTextGap(15);
            spellButton.setPreferredSize(new Dimension(240, 52));

			if (spell != null)
				spellButton.addMouseListener(new java.awt.event.MouseAdapter() {
					public void mouseClicked(java.awt.event.MouseEvent evt) {
						SpellButtonMouseClicked(evt);
					}
				});

            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.fill = 2;
            add(spellButton, gridBagConstraints);
        }

        private void SpellButtonMouseClicked(java.awt.event.MouseEvent evt) {
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

        public SpellButton(Spell _spell) throws IOException {
			spell = _spell;
            initComponents();

			spellButton.setEnabled(false);
			spellButton.setIcon(spell.Icon());
			spellButton.setDisabledIcon(spell.Icon());
			spellButton.setText(spell.Spell);
        }

		public SpellButton(String sText) {
			spell = null;
			initComponents();
			spellButton.setText(sText);
		}
    }

    /** Creates new form CreateMenu1 */
    public CreateMenu(TLKFactory TLK, ResourceFactory resFac) {
        XP1 = false;
        XP2 = false;
        Preferences prefs = Preferences.userNodeForPackage(getClass());
        String GameDir = prefs.get("GameDir", null);
        if((new File(GameDir, "xp1.key")).exists()) {
            XP1 = true;
        }
        if((new File(GameDir, "xp2.key")).exists()) {
            XP2 = true;
        }
        skilllabels = new Vector();
        MainCharData = new HashMap[20];
        MainCharDataAux = new String[20][];
        TLKFac = TLK;
        RESFAC = resFac;

        initComponents();
        glasspane = new MyGlassPane(this.getContentPane());
        //glasspane = new JPanel();
        this.setGlassPane(glasspane);
        //glasspane.setVisible(true);
        //mainframe = CreateMenu.getFrames();
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        //        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));

        //******VERSION CONTROL*********
        VersionLabel.setText(MainMenu.versionumber);
        //******VERSION CONTROL*********

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }

        DoneLabel.setVisible(false);
		skillsmap = SkillMap.GetSkillMap();

        // Loop through skillsmap and create skill buttons
		for(int ii = 0; ii < skillsmap.length; ++ii) {
			JButton SkillButton = new JButton();
			JLabel SkillLabel = new JLabel();
			if(skillsmap[ii].Skill != null) {
				java.awt.GridBagConstraints gridBagConstraints;

				JPanel SkillPanel = new JPanel();

				SkillPanel.setLayout(new java.awt.GridBagLayout());

				SkillPanel.setBackground(new java.awt.Color(0, 0, 0));
				SkillPanel.setBorder(new javax.swing.border.BevelBorder(javax.swing.border.BevelBorder.RAISED, java.awt.Color.gray, java.awt.Color.lightGray, java.awt.Color.gray, java.awt.Color.lightGray));
				SkillButton.setBackground(new java.awt.Color(0, 0, 0));
				SkillButton.setForeground(new java.awt.Color(222, 200, 120));
				SkillButton.setText(skillsmap[ii].Skill);

				SkillButton.setIcon(skillsmap[ii].Icon());
				SkillButton.setBorder(null);
				SkillButton.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
				SkillButton.setIconTextGap(10);
				SkillButton.setPreferredSize(new java.awt.Dimension(212, 32));
				gridBagConstraints = new java.awt.GridBagConstraints();
				gridBagConstraints.gridx = 0;
				gridBagConstraints.gridy = 0;
				gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
				gridBagConstraints.weightx = 1.0;
				SkillPanel.add(SkillButton, gridBagConstraints);

				SkillLabel.setBackground(new java.awt.Color(0, 0, 0));
				SkillLabel.setForeground(new java.awt.Color(222, 200, 120));
				SkillLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
				SkillLabel.setText("0");
				SkillLabel.setHorizontalTextPosition(javax.swing.SwingConstants.LEFT);
				gridBagConstraints = new java.awt.GridBagConstraints();
				gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
				gridBagConstraints.ipadx = 25;
				SkillPanel.add(SkillLabel, gridBagConstraints);

				SkillSetButtonList.add(SkillPanel);
			}
			SkillButtons.add(SkillButton);
			skilllabels.add(SkillLabel);
		}

        pack();
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
    }


    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;

        SkillButtons = new javax.swing.ButtonGroup();
        GenderButton = new javax.swing.JButton();
        RaceButton = new javax.swing.JButton();
        PortraitButton = new javax.swing.JButton();
        ClassButton = new javax.swing.JButton();
        AlignmentButton = new javax.swing.JButton();
        AbilitiesButton = new javax.swing.JButton();
        PackagesButton = new javax.swing.JButton();
        CustomizeButton = new javax.swing.JButton();
        ResetButton = new javax.swing.JButton();
        FinalizeButton = new javax.swing.JButton();
        ExitButton = new javax.swing.JButton();
        CharacterPanel = new javax.swing.JPanel();
        CharacterTabs = new javax.swing.JTabbedPane();
        CharSheet = new javax.swing.JPanel();
        CharPortrait = new javax.swing.JLabel();
        InfoPanel1 = new javax.swing.JPanel();
        RaceName = new javax.swing.JLabel();
        AlignmentName = new javax.swing.JLabel();
        ClassName = new javax.swing.JLabel();
        Comma = new javax.swing.JLabel();
        SexName = new javax.swing.JLabel();
        Hyphen = new javax.swing.JLabel();
        StrTitle = new javax.swing.JLabel();
        DexTitle = new javax.swing.JLabel();
        ConTitle = new javax.swing.JLabel();
        IntTitle = new javax.swing.JLabel();
        WisTitle = new javax.swing.JLabel();
        ChaTitle = new javax.swing.JLabel();
        ACHPPanel = new javax.swing.JPanel();
        ACLabel = new javax.swing.JLabel();
        HPLabel = new javax.swing.JLabel();
        AC = new javax.swing.JLabel();
        HP = new javax.swing.JLabel();
        PadACWindow = new javax.swing.JPanel();
        PadMiddlePanel1 = new javax.swing.JPanel();
        StrMod = new javax.swing.JLabel();
        DexMod = new javax.swing.JLabel();
        ConMod = new javax.swing.JLabel();
        IntMod = new javax.swing.JLabel();
        WisMod = new javax.swing.JLabel();
        ChaMod = new javax.swing.JLabel();
        Strength = new javax.swing.JLabel();
        Dexterity = new javax.swing.JLabel();
        Constitution = new javax.swing.JLabel();
        Intelligence = new javax.swing.JLabel();
        Wisdom = new javax.swing.JLabel();
        Charisma = new javax.swing.JLabel();
        SkillSheet = new javax.swing.JPanel();
        SkillButtonContainer = new javax.swing.JScrollPane();
        SkillSetButtonBak = new javax.swing.JPanel();
        SkillSetButtonList = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel8 = new javax.swing.JPanel();
        jPanel9 = new javax.swing.JPanel();
        FeatSheet = new javax.swing.JPanel();
        FeatButtonContainer = new javax.swing.JScrollPane();
        FeatButtonBak = new javax.swing.JPanel();
        FeatSelectedButtonList = new javax.swing.JPanel();
        jPanel14 = new javax.swing.JPanel();
        jPanel15 = new javax.swing.JPanel();
        jPanel16 = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();
        SpellSheet = new javax.swing.JPanel();
        SpellSelectedTabs = new javax.swing.JTabbedPane();
        Spell0ButtonContainer = new javax.swing.JScrollPane();
        Spell0ButtonBak = new javax.swing.JPanel();
        Spell0ButtonList = new javax.swing.JPanel();
        Spell1ButtonContainer = new javax.swing.JScrollPane();
        Spell1ButtonBak = new javax.swing.JPanel();
        Spell1ButtonList = new javax.swing.JPanel();
        jPanel26 = new javax.swing.JPanel();
        jPanel27 = new javax.swing.JPanel();
        jPanel28 = new javax.swing.JPanel();
        jPanel29 = new javax.swing.JPanel();
        PadLeftCharFrame = new javax.swing.JPanel();
        PadRightCharFrame = new javax.swing.JPanel();
        PadUpCharFrame = new javax.swing.JPanel();
        PadDownCharFrame = new javax.swing.JPanel();
        PadLeftFrame = new javax.swing.JPanel();
        PadMiddleFrame1 = new javax.swing.JPanel();
        PadUpFrame = new javax.swing.JPanel();
        PadDownFrame = new javax.swing.JPanel();
        VersionLabel = new javax.swing.JLabel();
        PadRightFrame = new javax.swing.JPanel();
        DoneLabel = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setTitle("Character Record");
        setBackground(new java.awt.Color(0, 0, 0));
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        GenderButton.setText("Gender");
        GenderButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GenderButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(GenderButton, gridBagConstraints);

        RaceButton.setText("Race");
        RaceButton.setEnabled(false);
        RaceButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RaceButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(RaceButton, gridBagConstraints);

        PortraitButton.setText("Portrait");
        PortraitButton.setEnabled(false);
        PortraitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                PortraitButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(PortraitButton, gridBagConstraints);

        ClassButton.setText("Class");
        ClassButton.setEnabled(false);
        ClassButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ClassButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(ClassButton, gridBagConstraints);

        AlignmentButton.setText("Alignment");
        AlignmentButton.setEnabled(false);
        AlignmentButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                AlignmentButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(AlignmentButton, gridBagConstraints);

        AbilitiesButton.setText("Abilities");
        AbilitiesButton.setEnabled(false);
        AbilitiesButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                AbilitiesButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(AbilitiesButton, gridBagConstraints);

        PackagesButton.setText("Packages");
        PackagesButton.setEnabled(false);
        PackagesButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                PackagesButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(PackagesButton, gridBagConstraints);

        CustomizeButton.setText("Customize");
        CustomizeButton.setEnabled(false);
        CustomizeButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CustomizeButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(CustomizeButton, gridBagConstraints);

        ResetButton.setText("Reset");
        ResetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResetButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(ResetButton, gridBagConstraints);

        FinalizeButton.setText("Finalize");
        FinalizeButton.setEnabled(false);
        FinalizeButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                FinalizeButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        getContentPane().add(FinalizeButton, gridBagConstraints);

        ExitButton.setText("Exit");
        ExitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ExitButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.SOUTH;
        getContentPane().add(ExitButton, gridBagConstraints);

        CharacterPanel.setLayout(new java.awt.GridBagLayout());

        CharacterPanel.setBorder(new javax.swing.border.EtchedBorder());
        CharacterPanel.setPreferredSize(new java.awt.Dimension(570, 500));
        CharacterTabs.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        CharacterTabs.setName("CharSheet");
        CharacterTabs.setPreferredSize(new java.awt.Dimension(546, 476));
        CharSheet.setLayout(new java.awt.GridBagLayout());

        CharSheet.setPreferredSize(new java.awt.Dimension(74, 110));
        CharPortrait.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/portrait2.jpg")));
        CharPortrait.setName("CurrentPortrait");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 3;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        CharSheet.add(CharPortrait, gridBagConstraints);

        InfoPanel1.setLayout(new java.awt.GridBagLayout());

        InfoPanel1.setBorder(new javax.swing.border.EtchedBorder());
        RaceName.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        RaceName.setText("Human");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        InfoPanel1.add(RaceName, gridBagConstraints);

        AlignmentName.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        AlignmentName.setText("True Neutral");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        InfoPanel1.add(AlignmentName, gridBagConstraints);

        ClassName.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        ClassName.setText("Fighter");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        InfoPanel1.add(ClassName, gridBagConstraints);

        Comma.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Comma.setText(",");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.ipadx = 4;
        InfoPanel1.add(Comma, gridBagConstraints);

        SexName.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        SexName.setText("Male");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        InfoPanel1.add(SexName, gridBagConstraints);

        Hyphen.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Hyphen.setText("-");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        InfoPanel1.add(Hyphen, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = 3;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 22;
        gridBagConstraints.ipady = 22;
        CharSheet.add(InfoPanel1, gridBagConstraints);

        StrTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        StrTitle.setText("Strength");
        StrTitle.setBorder(new javax.swing.border.EtchedBorder());
        StrTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 20;
        CharSheet.add(StrTitle, gridBagConstraints);

        DexTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        DexTitle.setText("Dexterity");
        DexTitle.setBorder(new javax.swing.border.EtchedBorder());
        DexTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(DexTitle, gridBagConstraints);

        ConTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        ConTitle.setText("Constitution");
        ConTitle.setBorder(new javax.swing.border.EtchedBorder());
        ConTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(ConTitle, gridBagConstraints);

        IntTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        IntTitle.setText("Intelligence");
        IntTitle.setBorder(new javax.swing.border.EtchedBorder());
        IntTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(IntTitle, gridBagConstraints);

        WisTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        WisTitle.setText("Wisdom");
        WisTitle.setBorder(new javax.swing.border.EtchedBorder());
        WisTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(WisTitle, gridBagConstraints);

        ChaTitle.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        ChaTitle.setText("Charisma");
        ChaTitle.setBorder(new javax.swing.border.EtchedBorder());
        ChaTitle.setPreferredSize(new java.awt.Dimension(100, 19));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(ChaTitle, gridBagConstraints);

        ACHPPanel.setLayout(new java.awt.GridBagLayout());

        ACHPPanel.setBorder(new javax.swing.border.EtchedBorder());
        ACLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        ACLabel.setText("AC");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        ACHPPanel.add(ACLabel, gridBagConstraints);

        HPLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        HPLabel.setText("HP");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        ACHPPanel.add(HPLabel, gridBagConstraints);

        AC.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        AC.setText("10");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        ACHPPanel.add(AC, gridBagConstraints);

        HP.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        HP.setText("0");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        ACHPPanel.add(HP, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        ACHPPanel.add(PadACWindow, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(ACHPPanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharSheet.add(PadMiddlePanel1, gridBagConstraints);

        StrMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        StrMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        StrMod.setText("0");
        StrMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        CharSheet.add(StrMod, gridBagConstraints);

        DexMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        DexMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        DexMod.setText("0");
        DexMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        CharSheet.add(DexMod, gridBagConstraints);

        ConMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        ConMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        ConMod.setText("0");
        ConMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        CharSheet.add(ConMod, gridBagConstraints);

        IntMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        IntMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        IntMod.setText("0");
        IntMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        CharSheet.add(IntMod, gridBagConstraints);

        WisMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        WisMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        WisMod.setText("0");
        WisMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        CharSheet.add(WisMod, gridBagConstraints);

        ChaMod.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        ChaMod.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        ChaMod.setText("0");
        ChaMod.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 10;
        CharSheet.add(ChaMod, gridBagConstraints);

        Strength.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Strength.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Strength.setText("10");
        Strength.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Strength, gridBagConstraints);

        Dexterity.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Dexterity.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Dexterity.setText("10");
        Dexterity.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Dexterity, gridBagConstraints);

        Constitution.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Constitution.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Constitution.setText("10");
        Constitution.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Constitution, gridBagConstraints);

        Intelligence.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Intelligence.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Intelligence.setText("10");
        Intelligence.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Intelligence, gridBagConstraints);

        Wisdom.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Wisdom.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Wisdom.setText("10");
        Wisdom.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Wisdom, gridBagConstraints);

        Charisma.setFont(new java.awt.Font("Trebuchet MS", 0, 12));
        Charisma.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        Charisma.setText("10");
        Charisma.setBorder(new javax.swing.border.EtchedBorder());
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 4;
        CharSheet.add(Charisma, gridBagConstraints);

        CharacterTabs.addTab("Character", CharSheet);

        SkillSheet.setLayout(new java.awt.GridBagLayout());

        SkillButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        SkillButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        SkillButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        SkillButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        SkillButtonContainer.setPreferredSize(new java.awt.Dimension(291, 300));
        SkillButtonContainer.setAutoscrolls(true);
		SkillButtonContainer.getVerticalScrollBar().setUnitIncrement(32);
		SkillButtonContainer.getVerticalScrollBar().setBlockIncrement(32);

        SkillSetButtonBak.setLayout(new java.awt.GridBagLayout());

        SkillSetButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        SkillSetButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        SkillSetButtonBak.setAlignmentX(0.0F);
        SkillSetButtonBak.setAlignmentY(0.0F);
        SkillSetButtonBak.setAutoscrolls(true);
        SkillSetButtonList.setLayout(new java.awt.GridLayout(0, 1));

        SkillSetButtonList.setBackground(new java.awt.Color(0, 0, 0));
        SkillSetButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSetButtonBak.add(SkillSetButtonList, gridBagConstraints);

        SkillButtonContainer.setViewportView(SkillSetButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SkillSheet.add(SkillButtonContainer, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        SkillSheet.add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        SkillSheet.add(jPanel7, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        SkillSheet.add(jPanel8, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        SkillSheet.add(jPanel9, gridBagConstraints);

        CharacterTabs.addTab("Skills", SkillSheet);

        FeatSheet.setLayout(new java.awt.GridBagLayout());

        FeatButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        FeatButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        FeatButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        FeatButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        FeatButtonContainer.setPreferredSize(new java.awt.Dimension(373, 300));
        FeatButtonContainer.setAutoscrolls(true);
		FeatButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
		FeatButtonContainer.getVerticalScrollBar().setBlockIncrement(52);

        FeatButtonBak.setLayout(new java.awt.GridBagLayout());

        FeatButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        FeatButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        FeatButtonBak.setAlignmentX(0.0F);
        FeatButtonBak.setAlignmentY(0.0F);
        FeatButtonBak.setAutoscrolls(true);
        FeatSelectedButtonList.setLayout(new java.awt.GridLayout(0, 1));

        FeatSelectedButtonList.setBackground(new java.awt.Color(0, 0, 0));
        FeatSelectedButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        FeatButtonBak.add(FeatSelectedButtonList, gridBagConstraints);

        FeatButtonContainer.setViewportView(FeatButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        FeatSheet.add(FeatButtonContainer, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        FeatSheet.add(jPanel14, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        FeatSheet.add(jPanel15, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        FeatSheet.add(jPanel16, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        FeatSheet.add(jPanel17, gridBagConstraints);

        CharacterTabs.addTab("Feats", FeatSheet);

        SpellSheet.setLayout(new java.awt.GridBagLayout());

        SpellSelectedTabs.setBackground(new java.awt.Color(0, 0, 0));
        SpellSelectedTabs.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        Spell0ButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        Spell0ButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        Spell0ButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
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
        Spell1ButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
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
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        SpellSheet.add(SpellSelectedTabs, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        SpellSheet.add(jPanel26, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        SpellSheet.add(jPanel27, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        SpellSheet.add(jPanel28, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        SpellSheet.add(jPanel29, gridBagConstraints);

        CharacterTabs.addTab("Spells", SpellSheet);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        CharacterPanel.add(CharacterTabs, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharacterPanel.add(PadLeftCharFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharacterPanel.add(PadRightCharFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharacterPanel.add(PadUpCharFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        CharacterPanel.add(PadDownCharFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 10;
        gridBagConstraints.gridheight = 12;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(CharacterPanel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        getContentPane().add(PadLeftFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(PadMiddleFrame1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 13;
        gridBagConstraints.gridy = 0;
        getContentPane().add(PadUpFrame, gridBagConstraints);

        PadDownFrame.setLayout(new java.awt.FlowLayout(java.awt.FlowLayout.RIGHT));

        VersionLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        VersionLabel.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        PadDownFrame.add(VersionLabel);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 13;
        gridBagConstraints.gridy = 14;
        getContentPane().add(PadDownFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 14;
        getContentPane().add(PadRightFrame, gridBagConstraints);

        DoneLabel.setForeground(new java.awt.Color(255, 0, 0));
        DoneLabel.setText("BIC Written");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
        getContentPane().add(DoneLabel, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        getContentPane().add(jPanel1, gridBagConstraints);

        pack();
    }

    private void ExitButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(0);
        setVisible(false);
        dispose();
        System.exit(0);
        //(new MainMenu()).show();
    }

    private void FinalizeButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        new FinalizeChar();
    }

    private void ResetButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(0);
        DoneLabel.setVisible(false);
		GenderButton.setEnabled(true);
    }

    private void PackagesButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(7);
        (new PackagesMenu()).show();
    }

    private void AlignmentButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(4);

        // must catch unreported exception java.lang.Exception
        try
        {
			(new AlignmentMenu()).show();
		}
		catch(Exception e)
		{}
    }

    private void ClassButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(3);
        (new ClassMenu()).show();
    }

    private void RaceButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(1);
        (new RaceMenu()).show();
    }

    private void GenderButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(0);
        (new SexMenu()).show();
    }

    private void CustomizeButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here
        System.gc();
        CharReset(8);
        (new CustomizeMenu1()).show();
    }

    private void AbilitiesButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        (new AbilitiesMenu()).show();
        CharReset(5);
    }

    private void PortraitButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        System.gc();
        CharReset(2);
        (new PortraitMenu()).show();
    }

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {
        System.gc();
        System.exit(0);
    }
    public void RedoSkills() {
        LinkedList skilltypelist = new LinkedList();
        skilltypelist.add("STR");
        skilltypelist.add("DEX");
        skilltypelist.add("CON");
        skilltypelist.add("INT");
        skilltypelist.add("WIS");
        skilltypelist.add("CHA");
        LinkedList statmodlist = new LinkedList();
        if(MainCharData[5] != null) {
            statmodlist.add(MainCharData[5].get(new Integer(12)));
            statmodlist.add(MainCharData[5].get(new Integer(13)));
            statmodlist.add(MainCharData[5].get(new Integer(14)));
            statmodlist.add(MainCharData[5].get(new Integer(15)));
            statmodlist.add(MainCharData[5].get(new Integer(16)));
            statmodlist.add(MainCharData[5].get(new Integer(17)));
        } else {
            statmodlist.add("0");
            statmodlist.add("0");
            statmodlist.add("0");
            statmodlist.add("0");
            statmodlist.add("0");
            statmodlist.add("0");
        }

        for(int ii = 0; ii < skillsmap.length; ++ii) {
            int skillnum = skilltypelist.indexOf(skillsmap[ii].KeyAbility);
            if(skillnum != -1) {
                if(MainCharData[8] != null) {
                    int skillmod = Integer.parseInt((String)statmodlist.get(skillnum));
                    int skillranks = Integer.parseInt(MainCharData[8].get(new Integer(ii)).toString());
                    int skilltotal = skillranks + skillmod;
                    ((JLabel)skilllabels.get(ii)).setText("" + skilltotal);
                } else {
                    int skilltotal = Integer.parseInt((String)statmodlist.get(skillnum));
                    ((JLabel)skilllabels.get(ii)).setText("" + skilltotal);
                }
            }
        }
    }

    public void RedoFeats() {
        if(MainCharData[6] != null) {
            Boolean tmp = (Boolean)MainCharData[6].get(new Integer(0));
            if(tmp.equals(Boolean.FALSE)) {
                if(MainCharData[9] != null) {
                    FeatSelectedButtonList.removeAll();
                    int numfeats = ((Integer)MainCharData[9].get(new Integer(0))).intValue();
					featmap = FeatMap.GetFeatMap();

					for(int i = 0; i < numfeats; i++) {
						int featnum = ((Integer)MainCharData[9].get(new Integer(i+1))).intValue();
						if(featmap[featnum] != null) {
							FeatButton featbutton = new FeatButton(featmap[featnum], false, null);
							FeatSelectedButtonList.add(featbutton, -1);
						}
					}
                }
                pack();
            }
        }
		else {
			FeatSelectedButtonList.removeAll();
		}
    }

    public void RedoSpells() {
        if(MainCharDataAux[3] != null) {
            if(MainCharDataAux[3][classes.SpellCaster].equalsIgnoreCase("1")) {
                int classnum = Integer.parseInt(MainCharDataAux[3][0]);
                if(classnum == 2 || classnum == 3) {
                    try {
                        SpellSelectedTabs.setIconAt(0, RESFAC.getIcon("ir_orisons"));
                        SpellSelectedTabs.setIconAt(1, RESFAC.getIcon("ir_level1"));

                        SpellButton spbutton = new SpellButton("All 0 Level Spells");
                        Spell0ButtonList.removeAll();
                        Spell0ButtonList.add(spbutton);

                        SpellButton spbutton1 = new SpellButton("All 1st Level Spells");
                        Spell1ButtonList.removeAll();
                        Spell1ButtonList.add(spbutton1);
                    }
                    catch(IOException err) {
                        JOptionPane.showMessageDialog(null, "Error - not found. Your data files might be corrupt.", "Error", 0);
                        System.exit(0);
                    }
                }
                if(classnum == 1 || classnum == 9 || classnum == 10) {

					spellmap = SpellMap.GetSpellMap();
                    try {
                        SpellSelectedTabs.setIconAt(0, RESFAC.getIcon("ir_cantrips"));
                        SpellSelectedTabs.setIconAt(1, RESFAC.getIcon("ir_level1"));

                        if(MainCharData[10] != null) {
                            int spell0num = (((Integer)MainCharData[10].get(new Integer(0)))).intValue();
                            Spell0ButtonList.removeAll();
							ArrayList al = new ArrayList();
                            for(int i = 0; i < spell0num; i++) {
                                int spellselect = (((Integer)MainCharData[10].get(new Integer(i+1)))).intValue();
                                if(spellmap[spellselect] != null)
									al.add(spellmap[spellselect]);
                            }
							Collections.sort(al);
							for (int ii=0; ii<al.size(); ++ii)
								Spell0ButtonList.add(new SpellButton((Spell)al.get(ii)), -1);
                        }

                        if(MainCharData[11] != null) {
                            int spell1num = (((Integer)MainCharData[11].get(new Integer(0)))).intValue();
                            Spell1ButtonList.removeAll();
							ArrayList al = new ArrayList();
                            for(int i = 0; i < spell1num; i++) {
                                int spellselect = (((Integer)MainCharData[11].get(new Integer(i+1)))).intValue();
                                if(spellmap[spellselect] != null)
									al.add(spellmap[spellselect]);
                            }
							Collections.sort(al);
							for (int ii=0; ii<al.size(); ++ii)
								Spell1ButtonList.add(new SpellButton((Spell)al.get(ii)), -1);
                        }
                    }
                    catch(IOException err) {
                        JOptionPane.showMessageDialog(null, "Error - not found. Your data files might be corrupt.", "Error", 0);
                        System.exit(0);
                    }
                }
                if(classnum == 6 || classnum == 7) {
                    String imagestring = "";
                    try {
                        SpellSelectedTabs.setIconAt(0, RESFAC.getIcon("ir_orisons"));
                        SpellSelectedTabs.setIconAt(1, RESFAC.getIcon("ir_level1"));
                    }
                    catch(IOException err) {
                        JOptionPane.showMessageDialog(null, "Error - not found. Your data files might be corrupt.", "Error", 0);
                        System.exit(0);
                    }
                }
            }
        }
		else {
			Spell0ButtonList.removeAll();
			Spell1ButtonList.removeAll();
		}
        pack();
    }

    public void RedoACHP() {
        if(MainCharDataAux[3] != null) {
            int classhps = Integer.parseInt(MainCharDataAux[3][classes.HitDie]);
            if(MainCharData[5] != null) {
                int hpmod = new Integer(((String)MainCharData[5].get(new Integer(14)))).intValue();
                int acmod = new Integer(((String)MainCharData[5].get(new Integer(13)))).intValue();
                int hptotal = classhps + hpmod;
                int actotal = acmod + 10;
                AC.setText(Integer.toString(hptotal));
                HP.setText(Integer.toString(actotal));
            } else {
                int actotal = 10;
                int hptotal = classhps;
                AC.setText(Integer.toString(hptotal));
                HP.setText(Integer.toString(actotal));
            }
        } else {
            AC.setText("10");
            HP.setText("0");
        }
    }

    public void RedoName() {
        if(MainCharData[15] != null) {
            String firstname = (String)MainCharData[15].get(new Integer(7));
            String lastname = (String)MainCharData[15].get(new Integer(8));
            setTitle("Character Record, " + firstname + " " + lastname);
        } else {
            setTitle("Character Record");
        }
    }

    public void RedoAll() {
        RedoSkills();
        RedoFeats();
        RedoSpells();
        RedoACHP();
        RedoName();
    }

    public void ChangePortrait(Image portrait) {
        CharPortrait.setIcon(new ImageIcon(portrait));
    }

    public void BlockWindow(boolean state) {
        this.getGlassPane().setVisible(false);
        if(state) {
            this.getGlassPane().setVisible(true);
        }
    }

    public static TLKFactory getTLKFactory() {
        return TLKFac;
    }

    public static ResourceFactory getResourceFactory() {
        return RESFAC;
    }

    public static CreateMenu getCreateMenu() {
        return createmenu;
    }

    public void CharReset(int level) {
        if(level < 8) {
            for(int q = 8; q < 18; q++) {
                if(MainCharData[q] != null) {
                    MainCharData[q].clear();
                    MainCharData[q] = null;
                }
            }
            CustomizeButton.setEnabled(false);
            RedoAll();
            if(level < 7) {
                if(MainCharData[6] != null) {
                    MainCharData[6].clear();
                    MainCharData[6] = null;
                }
                if(MainCharDataAux[7] != null) {
                    MainCharDataAux[7] = null;
                }
                PackagesButton.setEnabled(false);
                RedoAll();
                //DO HANDLING HERE OF DATA RESET ON SHEETS
                if(level < 6) {
                    if(MainCharData[5] != null) {
                        MainCharData[5].clear();
                        MainCharData[5] = null;
                    }
                    Strength.setText("10");
                    Dexterity.setText("10");
                    Constitution.setText("10");
                    Intelligence.setText("10");
                    Wisdom.setText("10");
                    Charisma.setText("10");
                    StrMod.setText("0");
                    DexMod.setText("0");
                    ConMod.setText("0");
                    IntMod.setText("0");
                    WisMod.setText("0");
                    ChaMod.setText("0");
                    RedoAll();
                    if(level < 5) {
                        if(MainCharData[4] != null) {
                            MainCharData[4].clear();
                            MainCharData[4] = null;
                        }
                        AbilitiesButton.setEnabled(false);
                        AlignmentName.setText("True Neutral");
                        RedoAll();
                        if(level < 4) {
                            if(MainCharDataAux[3] != null) {
                                MainCharDataAux[3] = null;
                            }
                            AlignmentButton.setEnabled(false);
                            ClassName.setText("Fighter");
                            RedoAll();
                            if(level < 3) {
                                if(MainCharData[2] != null) {
                                    MainCharData[2].clear();
                                    MainCharData[2] = null;
                                }
                                ClassButton.setEnabled(false);
                                java.net.URL targurl = getClass().getResource("resource/portrait2.jpg");
                                CharPortrait.setIcon(new ImageIcon(targurl));
                                RedoAll();
                                if(level < 2) {
                                    if(MainCharDataAux[1] != null) {
                                        MainCharDataAux[1] = null;
                                    }
                                    PortraitButton.setEnabled(false);
                                    RaceName.setText("Human");
                                    RedoAll();
                                    if(level < 1) {
                                        if(MainCharData[0] != null) {
                                            MainCharData[0].clear();
                                            MainCharData[0] = null;
                                        }
                                        RaceButton.setEnabled(false);
                                        SexName.setText("Male");
                                        RedoAll();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
		System.gc();
    }

    private JComponent glasspane;
    //private JFrame mainframe[];
    // Variables declaration - do not modify
    private javax.swing.JLabel AC;
    private javax.swing.JPanel ACHPPanel;
    private javax.swing.JLabel ACLabel;
    public javax.swing.JButton AbilitiesButton;
    public javax.swing.JButton AlignmentButton;
    public javax.swing.JLabel AlignmentName;
    public javax.swing.JLabel ChaMod;
    private javax.swing.JLabel ChaTitle;
    public javax.swing.JLabel CharPortrait;
    private javax.swing.JPanel CharSheet;
    private javax.swing.JPanel CharacterPanel;
    private javax.swing.JTabbedPane CharacterTabs;
    public javax.swing.JLabel Charisma;
    public javax.swing.JButton ClassButton;
    public javax.swing.JLabel ClassName;
    private javax.swing.JLabel Comma;
    public javax.swing.JLabel ConMod;
    private javax.swing.JLabel ConTitle;
    public javax.swing.JLabel Constitution;
    public javax.swing.JButton CustomizeButton;
    public javax.swing.JLabel DexMod;
    private javax.swing.JLabel DexTitle;
    public javax.swing.JLabel Dexterity;
    public javax.swing.JLabel DoneLabel;
    private javax.swing.JButton ExitButton;
    private javax.swing.JPanel FeatButtonBak;
    private javax.swing.JScrollPane FeatButtonContainer;
    private javax.swing.JPanel FeatSelectedButtonList;
    private javax.swing.JPanel FeatSheet;
    public javax.swing.JButton FinalizeButton;
    public javax.swing.JButton GenderButton;
    private javax.swing.JLabel HP;
    private javax.swing.JLabel HPLabel;
    private javax.swing.JLabel Hyphen;
    private javax.swing.JPanel InfoPanel1;
    public javax.swing.JLabel IntMod;
    private javax.swing.JLabel IntTitle;
    public javax.swing.JLabel Intelligence;
    public javax.swing.JButton PackagesButton;
    private javax.swing.JPanel PadACWindow;
    private javax.swing.JPanel PadDownCharFrame;
    private javax.swing.JPanel PadDownFrame;
    private javax.swing.JPanel PadLeftCharFrame;
    private javax.swing.JPanel PadLeftFrame;
    private javax.swing.JPanel PadMiddleFrame1;
    private javax.swing.JPanel PadMiddlePanel1;
    private javax.swing.JPanel PadRightCharFrame;
    private javax.swing.JPanel PadRightFrame;
    private javax.swing.JPanel PadUpCharFrame;
    private javax.swing.JPanel PadUpFrame;
    public javax.swing.JButton PortraitButton;
    public javax.swing.JButton RaceButton;
    public javax.swing.JLabel RaceName;
    public javax.swing.JButton ResetButton;
    public javax.swing.JLabel SexName;
    private javax.swing.JScrollPane SkillButtonContainer;
    private javax.swing.ButtonGroup SkillButtons;
    private javax.swing.JPanel SkillSetButtonBak;
    private javax.swing.JPanel SkillSetButtonList;
    private javax.swing.JPanel SkillSheet;
    private javax.swing.JPanel Spell0ButtonBak;
    private javax.swing.JScrollPane Spell0ButtonContainer;
    private javax.swing.JPanel Spell0ButtonList;
    private javax.swing.JPanel Spell1ButtonBak;
    private javax.swing.JScrollPane Spell1ButtonContainer;
    private javax.swing.JPanel Spell1ButtonList;
    private javax.swing.JTabbedPane SpellSelectedTabs;
    private javax.swing.JPanel SpellSheet;
    public javax.swing.JLabel StrMod;
    private javax.swing.JLabel StrTitle;
    public javax.swing.JLabel Strength;
    private javax.swing.JLabel VersionLabel;
    public javax.swing.JLabel WisMod;
    private javax.swing.JLabel WisTitle;
    public javax.swing.JLabel Wisdom;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel26;
    private javax.swing.JPanel jPanel27;
    private javax.swing.JPanel jPanel28;
    private javax.swing.JPanel jPanel29;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;

    // End of variables declaration
    private static CreateMenu createmenu;
    private static TLKFactory TLKFac;
    private static ResourceFactory RESFAC;

    public Map MainCharData[];
	public String[][] MainCharDataAux;
	public int skillPointsLeft;
    public Vector skilllabels;
    private Skill[] skillsmap;
    private Feat[] featmap;
    private Spell[] spellmap;
    public boolean XP1;
    public boolean XP2;
}

class MyGlassPane extends JComponent
                  implements ItemListener {
    Point point;

    //React to change button clicks.
    public void itemStateChanged(ItemEvent e) {
        setVisible(e.getStateChange() == ItemEvent.SELECTED);
    }

    protected void paintComponent(Graphics g) {
        if (point != null) {
            g.setColor(Color.red);
            g.fillOval(point.x - 10, point.y - 10, 20, 20);
        }
    }

    public void setPoint(Point p) {
        point = p;
    }

    public MyGlassPane(Container contentPane) {
        CBListener listener = new CBListener(this, contentPane);
        addMouseListener(listener);
        addMouseMotionListener(listener);
    }
}

class CBListener extends MouseInputAdapter {
    Toolkit toolkit;
    Component liveButton;
    JMenuBar menuBar;
    MyGlassPane glassPane;
    Container contentPane;
    public CBListener(MyGlassPane glassPane, Container contentPane) {
    //public CBListener(Component liveButton, JMenuBar menuBar,
    //                  MyGlassPane glassPane, Container contentPane) {
        toolkit = Toolkit.getDefaultToolkit();
        //this.liveButton = liveButton;
        //this.menuBar = menuBar;
        this.glassPane = glassPane;
        this.contentPane = contentPane;
    }

    public void mouseMoved(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mouseDragged(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mouseClicked(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mouseEntered(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mouseExited(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mousePressed(MouseEvent e) {
        //redispatchMouseEvent(e, false);
    }

    public void mouseReleased(MouseEvent e) {
        //redispatchMouseEvent(e, true);
    }
}
