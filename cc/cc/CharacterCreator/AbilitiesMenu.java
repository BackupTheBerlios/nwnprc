/*
 * AbilitiesMenu.java
 *
 * Created on February 23, 2003, 6:04 PM
 */

/**
 *
 * @author  James
 */
package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
import javax.swing.border.EtchedBorder;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import CharacterCreator.defs.*;
// Referenced classes of package CharacterCreator:
//            TLKFactory, CreateMenu, ResourceFactory

public class AbilitiesMenu extends JFrame
{

    public AbilitiesMenu()
    {
        StartingValue = 8;
        modifier = new int[6];
        racemod = new String[6];
        menucreate = TLKFactory.getCreateMenu();
        menucreate.BlockWindow(true);        
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        initComponents();
        OKButton.setEnabled(false);
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();            
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        
        TOTALPOINTS = 30;
        for(int i = 0; i < 6; i++)
        {
            String mod = menucreate.MainCharDataAux[1][i + 9];
            if(mod.startsWith("-") || mod.startsWith("0"))
                racemod[i] = mod;
            else
                racemod[i] = "+" + mod;
        }

        StrRaceMod.setText(racemod[0]);
        DexRaceMod.setText(racemod[1]);
        ConRaceMod.setText(racemod[5]);
        IntRaceMod.setText(racemod[2]);
        WisRaceMod.setText(racemod[4]);
        ChaRaceMod.setText(racemod[3]);
        ResetStats();
        ResetAllSpinners();
        CURRENTPOINTS = TOTALPOINTS;
        OLDSTR = StartingValue;
        OLDWIS = StartingValue;
        OLDDEX = StartingValue;
        OLDINT = StartingValue;
        OLDCON = StartingValue;
        OLDCHA = StartingValue;
        StrSpinnerStateChanged(new ChangeEvent(this));
        DexSpinnerStateChanged(new ChangeEvent(this));
        ConSpinnerStateChanged(new ChangeEvent(this));
        IntSpinnerStateChanged(new ChangeEvent(this));
        WisSpinnerStateChanged(new ChangeEvent(this));
        ChaSpinnerStateChanged(new ChangeEvent(this));
        CurrentPoints.setText(Integer.toString(TOTALPOINTS));
        DescriptionText.setText(TLKFAC.getEntry(457));
    }

    private void increaseStat(int whichone, int howmuch)
    {
        JSpinner tempspinner = new JSpinner();
        switch(whichone)
        {
        case 0: // '\0'
            tempspinner = StrSpinner;
            break;

        case 1: // '\001'
            tempspinner = DexSpinner;
            break;

        case 2: // '\002'
            tempspinner = ConSpinner;
            break;

        case 3: // '\003'
            tempspinner = IntSpinner;
            break;

        case 4: // '\004'
            tempspinner = WisSpinner;
            break;

        case 5: // '\005'
            tempspinner = ChaSpinner;
            break;

        default:
            return;
        }
        int tempval = (new Integer(tempspinner.getValue().toString())).intValue();
        for(int z = 0; z < howmuch; z++)
        {
            tempval++;
            tempspinner.setValue(new Integer(tempval));
        }

    }

    private int getMod(int whichone)
    {
        return modifier[whichone];
    }

    public void ResetStats()
    {
        STRMAX = MAXSTAT;
        DEXMAX = MAXSTAT;
        CONMAX = MAXSTAT;
        INTMAX = MAXSTAT;
        WISMAX = MAXSTAT;
        CHAMAX = MAXSTAT;
        STRMIN = MINSTAT;
        DEXMIN = MINSTAT;
        CONMIN = MINSTAT;
        INTMIN = MINSTAT;
        WISMIN = MINSTAT;
        CHAMIN = MINSTAT;
    }

    public void ResetAllSpinners()
    {
        ResetSpinner(0, StartingValue);
        ResetSpinner(1, StartingValue);
        ResetSpinner(2, StartingValue);
        ResetSpinner(3, StartingValue);
        ResetSpinner(4, StartingValue);
        ResetSpinner(5, StartingValue);
    }

    public void ResetSpinner(int whichone, int prevalue)
    {
        switch(whichone)
        {
        default:
            break;

        case 0: // '\0'
            if(prevalue < STRMIN)
                prevalue = STRMIN;
            if(prevalue > STRMAX)
                prevalue = STRMAX;
            SpinnerNumberModel StrNumModel = new SpinnerNumberModel(prevalue, STRMIN, STRMAX, 1);
            StrSpinner.setModel(StrNumModel);
            break;

        case 1: // '\001'
            if(prevalue < DEXMIN)
                prevalue = DEXMIN;
            if(prevalue > DEXMAX)
                prevalue = DEXMAX;
            SpinnerNumberModel DexNumModel = new SpinnerNumberModel(prevalue, DEXMIN, DEXMAX, 1);
            DexSpinner.setModel(DexNumModel);
            break;

        case 2: // '\002'
            if(prevalue < CONMIN)
                prevalue = CONMIN;
            if(prevalue > CONMAX)
                prevalue = CONMAX;
            SpinnerNumberModel ConNumModel = new SpinnerNumberModel(prevalue, CONMIN, CONMAX, 1);
            ConSpinner.setModel(ConNumModel);
            break;

        case 3: // '\003'
            if(prevalue < INTMIN)
                prevalue = INTMIN;
            if(prevalue > INTMAX)
                prevalue = INTMAX;
            SpinnerNumberModel IntNumModel = new SpinnerNumberModel(prevalue, INTMIN, INTMAX, 1);
            IntSpinner.setModel(IntNumModel);
            break;

        case 4: // '\004'
            if(prevalue < WISMIN)
                prevalue = WISMIN;
            if(prevalue > WISMAX)
                prevalue = WISMAX;
            SpinnerNumberModel WisNumModel = new SpinnerNumberModel(prevalue, WISMIN, WISMAX, 1);
            WisSpinner.setModel(WisNumModel);
            break;

        case 5: // '\005'
            if(prevalue < CHAMIN)
                prevalue = CHAMIN;
            if(prevalue > CHAMAX)
                prevalue = CHAMAX;
            SpinnerNumberModel ChaNumModel = new SpinnerNumberModel(prevalue, CHAMIN, CHAMAX, 1);
            ChaSpinner.setModel(ChaNumModel);
            break;
        }
    }

    public void ResetSpinner(int whichone)
    {
        if(whichone == 0)
        {
            int prevalue = (new Integer(StrSpinner.getValue().toString())).intValue();
            if(prevalue < STRMIN)
                prevalue = STRMIN;
            if(prevalue > STRMAX)
                prevalue = STRMAX;
            SpinnerNumberModel StrNumModel = new SpinnerNumberModel(prevalue, STRMIN, STRMAX, 1);
            StrSpinner.setModel(StrNumModel);
        } else
        if(whichone == 1)
        {
            int prevalue = (new Integer(DexSpinner.getValue().toString())).intValue();
            if(prevalue < DEXMIN)
                prevalue = DEXMIN;
            if(prevalue > DEXMAX)
                prevalue = DEXMAX;
            SpinnerNumberModel DexNumModel = new SpinnerNumberModel(prevalue, DEXMIN, DEXMAX, 1);
            DexSpinner.setModel(DexNumModel);
        } else
        if(whichone == 2)
        {
            int prevalue = (new Integer(ConSpinner.getValue().toString())).intValue();
            if(prevalue < CONMIN)
                prevalue = CONMIN;
            if(prevalue > CONMAX)
                prevalue = CONMAX;
            SpinnerNumberModel ConNumModel = new SpinnerNumberModel(prevalue, CONMIN, CONMAX, 1);
            ConSpinner.setModel(ConNumModel);
        } else
        if(whichone == 3)
        {
            int prevalue = (new Integer(IntSpinner.getValue().toString())).intValue();
            if(prevalue < INTMIN)
                prevalue = INTMIN;
            if(prevalue > INTMAX)
                prevalue = INTMAX;
            SpinnerNumberModel IntNumModel = new SpinnerNumberModel(prevalue, INTMIN, INTMAX, 1);
            IntSpinner.setModel(IntNumModel);
        } else
        if(whichone == 4)
        {
            int prevalue = (new Integer(WisSpinner.getValue().toString())).intValue();
            if(prevalue < WISMIN)
                prevalue = WISMIN;
            if(prevalue > WISMAX)
                prevalue = WISMAX;
            SpinnerNumberModel WisNumModel = new SpinnerNumberModel(prevalue, WISMIN, WISMAX, 1);
            WisSpinner.setModel(WisNumModel);
        } else
        if(whichone == 5)
        {
            int prevalue = (new Integer(ChaSpinner.getValue().toString())).intValue();
            if(prevalue < CHAMIN)
                prevalue = CHAMIN;
            if(prevalue > CHAMAX)
                prevalue = CHAMAX;
            SpinnerNumberModel ChaNumModel = new SpinnerNumberModel(prevalue, CHAMIN, CHAMAX, 1);
            ChaSpinner.setModel(ChaNumModel);
        }
    }

    public int getCost(int first)
    {
        int response = first - 12;
        response /= 2;
        if(response < 1)
        {
            return 1;
        } else
        {
            response++;
            return response;
        }
    }

    public String getStatMod(int stat)
    {
        int tempmod = 0;

        if (stat > 9)
            tempmod = (stat - 10) / 2;
		else if (stat < 10)
            tempmod = (stat - 11) / 2;

        if(tempmod > 0)
            return "+" + (new Integer(tempmod)).toString();

		return (new Integer(tempmod)).toString();
    }

    public void updatepoints()
    {
        CurrentPoints.setText((new Integer(CURRENTPOINTS)).toString());
        if(CURRENTPOINTS < (new Integer(StrCost.getText())).intValue())
        {
            STRMAX = (new Integer(StrSpinner.getValue().toString())).intValue();
            ResetSpinner(0);
        } else
        {
            STRMAX = MAXSTAT;
            ResetSpinner(0);
        }
        if(CURRENTPOINTS < (new Integer(DexCost.getText())).intValue())
        {
            DEXMAX = (new Integer(DexSpinner.getValue().toString())).intValue();
            ResetSpinner(1);
        } else
        {
            DEXMAX = MAXSTAT;
            ResetSpinner(1);
        }
        if(CURRENTPOINTS < (new Integer(ConCost.getText())).intValue())
        {
            CONMAX = (new Integer(ConSpinner.getValue().toString())).intValue();
            ResetSpinner(2);
        } else
        {
            CONMAX = MAXSTAT;
            ResetSpinner(2);
        }
        if(CURRENTPOINTS < (new Integer(IntCost.getText())).intValue())
        {
            INTMAX = (new Integer(IntSpinner.getValue().toString())).intValue();
            ResetSpinner(3);
        } else
        {
            INTMAX = MAXSTAT;
            ResetSpinner(3);
        }
        if(CURRENTPOINTS < (new Integer(WisCost.getText())).intValue())
        {
            WISMAX = (new Integer(WisSpinner.getValue().toString())).intValue();
            ResetSpinner(4);
        } else
        {
            WISMAX = MAXSTAT;
            ResetSpinner(4);
        }
        if(CURRENTPOINTS < (new Integer(ChaCost.getText())).intValue())
        {
            CHAMAX = (new Integer(ChaSpinner.getValue().toString())).intValue();
            ResetSpinner(5);
        } else
        {
            CHAMAX = MAXSTAT;
            ResetSpinner(5);
        }
        if(CURRENTPOINTS == 0) {
            OKButton.setEnabled(true);
        }
    }

    private void initComponents()
    {
        StrLabel = new JLabel();
        StrRaceMod = new JTextField();
        StrSpinner = new JSpinner();
        StrMod = new JTextField();
        StrTotal = new JTextField();
        DexLabel = new JLabel();
        DexRaceMod = new JTextField();
        DexSpinner = new JSpinner();
        DexMod = new JTextField();
        DexTotal = new JTextField();
        ConLabel = new JLabel();
        ConRaceMod = new JTextField();
        ConSpinner = new JSpinner();
        ConMod = new JTextField();
        ConTotal = new JTextField();
        IntLabel = new JLabel();
        IntRaceMod = new JTextField();
        IntSpinner = new JSpinner();
        IntMod = new JTextField();
        IntTotal = new JTextField();
        WisLabel = new JLabel();
        WisRaceMod = new JTextField();
        WisSpinner = new JSpinner();
        WisMod = new JTextField();
        WisTotal = new JTextField();
        ChaLabel = new JLabel();
        ChaRaceMod = new JTextField();
        ChaSpinner = new JSpinner();
        ChaMod = new JTextField();
        ChaTotal = new JTextField();
        PointsPanel = new JPanel();
        PointsLabel = new JLabel();
        CurrentPoints = new JTextField();
        RecommendedButton = new JButton();
        OKButton = new JButton();
        CancelButton = new JButton();
        DescriptionWindow = new JPanel();
        DescriptionText = new JTextArea();
        jPanel7 = new JPanel();
        jPanel8 = new JPanel();
        jPanel9 = new JPanel();
        jPanel10 = new JPanel();
        jPanel1 = new JPanel();
        jPanel2 = new JPanel();
        jPanel3 = new JPanel();
        jPanel4 = new JPanel();
        jPanel5 = new JPanel();
        jPanel6 = new JPanel();
        NameLabel = new JLabel();
        Race = new JLabel();
        Points = new JLabel();
        StatMod = new JLabel();
        Total = new JLabel();
        IncreaseCost = new JLabel();
        StrCost = new JTextField();
        DexCost = new JTextField();
        ConCost = new JTextField();
        IntCost = new JTextField();
        WisCost = new JTextField();
        ChaCost = new JTextField();
        StatBackground = new JPanel();
        ResetButton = new JButton();
        getContentPane().setLayout(new GridBagLayout());
        setTitle("Select Abilities");
        setResizable(false);
        addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent evt)
            {
                exitForm(evt);
            }

        });
        StrLabel.setBackground(new Color(0, 0, 0));
        StrLabel.setFont(new Font("Georgia", 0, 12));
        StrLabel.setForeground(new Color(255, 255, 153));
        StrLabel.setHorizontalAlignment(2);
        StrLabel.setText("Strength");
        StrLabel.setOpaque(true);

        StrLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                StrLabelMouseClicked(evt);
            }
        });        
        
        GridBagConstraints gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 4, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(StrLabel, gridBagConstraints);
        StrRaceMod.setBackground(new Color(0, 0, 0));
        StrRaceMod.setForeground(new Color(255, 255, 153));
        StrRaceMod.setHorizontalAlignment(0);
        StrRaceMod.setText("+2");
        StrRaceMod.setBorder(null);
        StrRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(StrRaceMod, gridBagConstraints);
        StrSpinner.setBackground(new Color(0, 0, 0));
        StrSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        StrSpinner.setForeground(new Color(255, 255, 153));
        StrSpinner.setPreferredSize(new Dimension(50, 24));
        StrSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                StrSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(StrSpinner, gridBagConstraints);
        StrMod.setBackground(new Color(0, 0, 0));
        StrMod.setForeground(new Color(255, 255, 153));
        StrMod.setHorizontalAlignment(0);
        StrMod.setText("(-1)");
        StrMod.setBorder(null);
        StrMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(StrMod, gridBagConstraints);
        StrTotal.setBackground(new Color(0, 0, 0));
        StrTotal.setForeground(new Color(255, 255, 153));
        StrTotal.setHorizontalAlignment(0);
        StrTotal.setText("8");
        StrTotal.setBorder(null);
        StrTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(StrTotal, gridBagConstraints);
        DexLabel.setBackground(new Color(0, 0, 0));
        DexLabel.setFont(new Font("Georgia", 0, 12));
        DexLabel.setForeground(new Color(255, 255, 153));
        DexLabel.setHorizontalAlignment(2);
        DexLabel.setText("Dexterity");
        
        DexLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                DexLabelMouseClicked(evt);
            }
        }); 
        
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 5, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(DexLabel, gridBagConstraints);
        DexRaceMod.setBackground(new Color(0, 0, 0));
        DexRaceMod.setForeground(new Color(255, 255, 153));
        DexRaceMod.setHorizontalAlignment(0);
        DexRaceMod.setText("+2");
        DexRaceMod.setBorder(null);
        DexRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(DexRaceMod, gridBagConstraints);
        DexSpinner.setBackground(new Color(0, 0, 0));
        DexSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        DexSpinner.setForeground(new Color(255, 255, 153));
        DexSpinner.setPreferredSize(new Dimension(50, 24));
        DexSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                DexSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(DexSpinner, gridBagConstraints);
        DexMod.setBackground(new Color(0, 0, 0));
        DexMod.setForeground(new Color(255, 255, 153));
        DexMod.setHorizontalAlignment(0);
        DexMod.setText("(-1)");
        DexMod.setBorder(null);
        DexMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(DexMod, gridBagConstraints);
        DexTotal.setBackground(new Color(0, 0, 0));
        DexTotal.setForeground(new Color(255, 255, 153));
        DexTotal.setHorizontalAlignment(0);
        DexTotal.setText("8");
        DexTotal.setBorder(null);
        DexTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(DexTotal, gridBagConstraints);
        ConLabel.setBackground(new Color(0, 0, 0));
        ConLabel.setFont(new Font("Georgia", 0, 12));
        ConLabel.setForeground(new Color(255, 255, 153));
        ConLabel.setHorizontalAlignment(2);
        ConLabel.setText("Constitution");
        
        ConLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                ConLabelMouseClicked(evt);
            }
        });         
        
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 5, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(ConLabel, gridBagConstraints);
        ConRaceMod.setBackground(new Color(0, 0, 0));
        ConRaceMod.setForeground(new Color(255, 255, 153));
        ConRaceMod.setHorizontalAlignment(0);
        ConRaceMod.setText("+2");
        ConRaceMod.setBorder(null);
        ConRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(ConRaceMod, gridBagConstraints);
        ConSpinner.setBackground(new Color(0, 0, 0));
        ConSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        ConSpinner.setForeground(new Color(255, 255, 153));
        ConSpinner.setPreferredSize(new Dimension(50, 24));
        ConSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                ConSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(ConSpinner, gridBagConstraints);
        ConMod.setBackground(new Color(0, 0, 0));
        ConMod.setForeground(new Color(255, 255, 153));
        ConMod.setHorizontalAlignment(0);
        ConMod.setText("(-1)");
        ConMod.setBorder(null);
        ConMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(ConMod, gridBagConstraints);
        ConTotal.setBackground(new Color(0, 0, 0));
        ConTotal.setForeground(new Color(255, 255, 153));
        ConTotal.setHorizontalAlignment(0);
        ConTotal.setText("8");
        ConTotal.setBorder(null);
        ConTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(ConTotal, gridBagConstraints);
        IntLabel.setBackground(new Color(0, 0, 0));
        IntLabel.setFont(new Font("Georgia", 0, 12));
        IntLabel.setForeground(new Color(255, 255, 153));
        IntLabel.setHorizontalAlignment(2);
        IntLabel.setText("Intelligence");
        
        IntLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                IntLabelMouseClicked(evt);
            }
        });           
        
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 5, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(IntLabel, gridBagConstraints);
        IntRaceMod.setBackground(new Color(0, 0, 0));
        IntRaceMod.setForeground(new Color(255, 255, 153));
        IntRaceMod.setHorizontalAlignment(0);
        IntRaceMod.setText("+2");
        IntRaceMod.setBorder(null);
        IntRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(IntRaceMod, gridBagConstraints);
        IntSpinner.setBackground(new Color(0, 0, 0));
        IntSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        IntSpinner.setForeground(new Color(255, 255, 153));
        IntSpinner.setPreferredSize(new Dimension(50, 24));
        IntSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                IntSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(IntSpinner, gridBagConstraints);
        IntMod.setBackground(new Color(0, 0, 0));
        IntMod.setForeground(new Color(255, 255, 153));
        IntMod.setHorizontalAlignment(0);
        IntMod.setText("(-1)");
        IntMod.setBorder(null);
        IntMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(IntMod, gridBagConstraints);
        IntTotal.setBackground(new Color(0, 0, 0));
        IntTotal.setForeground(new Color(255, 255, 153));
        IntTotal.setHorizontalAlignment(0);
        IntTotal.setText("8");
        IntTotal.setBorder(null);
        IntTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(IntTotal, gridBagConstraints);
        WisLabel.setBackground(new Color(0, 0, 0));
        WisLabel.setFont(new Font("Georgia", 0, 12));
        WisLabel.setForeground(new Color(255, 255, 153));
        WisLabel.setHorizontalAlignment(2);
        WisLabel.setText("Wisdom");
        
        WisLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                WisLabelMouseClicked(evt);
            }
        });    
        
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 5, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(WisLabel, gridBagConstraints);
        WisRaceMod.setBackground(new Color(0, 0, 0));
        WisRaceMod.setForeground(new Color(255, 255, 153));
        WisRaceMod.setHorizontalAlignment(0);
        WisRaceMod.setText("+2");
        WisRaceMod.setBorder(null);
        WisRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(WisRaceMod, gridBagConstraints);
        WisSpinner.setBackground(new Color(0, 0, 0));
        WisSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        WisSpinner.setForeground(new Color(255, 255, 153));
        WisSpinner.setPreferredSize(new Dimension(50, 24));
        WisSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                WisSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(WisSpinner, gridBagConstraints);
        WisMod.setBackground(new Color(0, 0, 0));
        WisMod.setForeground(new Color(255, 255, 153));
        WisMod.setHorizontalAlignment(0);
        WisMod.setText("(-1)");
        WisMod.setBorder(null);
        WisMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(WisMod, gridBagConstraints);
        WisTotal.setBackground(new Color(0, 0, 0));
        WisTotal.setForeground(new Color(255, 255, 153));
        WisTotal.setHorizontalAlignment(0);
        WisTotal.setText("8");
        WisTotal.setBorder(null);
        WisTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(WisTotal, gridBagConstraints);
        
        ChaLabel.setBackground(new Color(0, 0, 0));
        ChaLabel.setFont(new Font("Georgia", 0, 12));
        ChaLabel.setForeground(new Color(255, 255, 153));
        ChaLabel.setHorizontalAlignment(2);
        ChaLabel.setText("Charisma");
        
        ChaLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                ChaLabelMouseClicked(evt);
            }
        });   
        
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 5, 0, 0);
        gridBagConstraints.anchor = 17;
        getContentPane().add(ChaLabel, gridBagConstraints);
        ChaRaceMod.setBackground(new Color(0, 0, 0));
        ChaRaceMod.setForeground(new Color(255, 255, 153));
        ChaRaceMod.setHorizontalAlignment(0);
        ChaRaceMod.setText("+2");
        ChaRaceMod.setBorder(null);
        ChaRaceMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(ChaRaceMod, gridBagConstraints);
        ChaSpinner.setBackground(new Color(0, 0, 0));
        ChaSpinner.setFont(new Font("Trebuchet MS", 0, 12));
        ChaSpinner.setForeground(new Color(255, 255, 153));
        ChaSpinner.setPreferredSize(new Dimension(50, 24));
        ChaSpinner.addChangeListener(new ChangeListener() {

            public void stateChanged(ChangeEvent evt)
            {
                ChaSpinnerStateChanged(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.anchor = 13;
        getContentPane().add(ChaSpinner, gridBagConstraints);
        ChaMod.setBackground(new Color(0, 0, 0));
        ChaMod.setForeground(new Color(255, 255, 153));
        ChaMod.setHorizontalAlignment(0);
        ChaMod.setText("(-1)");
        ChaMod.setBorder(null);
        ChaMod.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 10, 0, 10);
        getContentPane().add(ChaMod, gridBagConstraints);
        ChaTotal.setBackground(new Color(0, 0, 0));
        ChaTotal.setForeground(new Color(255, 255, 153));
        ChaTotal.setHorizontalAlignment(0);
        ChaTotal.setText("8");
        ChaTotal.setBorder(null);
        ChaTotal.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(ChaTotal, gridBagConstraints);
        PointsPanel.setBorder(new EtchedBorder());
        PointsLabel.setText("Remaining Points");
        PointsPanel.add(PointsLabel);
        CurrentPoints.setHorizontalAlignment(0);
        CurrentPoints.setText("0");
        CurrentPoints.setPreferredSize(new Dimension(20, 20));
        PointsPanel.add(CurrentPoints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.gridwidth = 7;
        gridBagConstraints.fill = 1;
        getContentPane().add(PointsPanel, gridBagConstraints);
        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent evt)
            {
                RecommendedButtonActionPerformed(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.anchor = 17;
        getContentPane().add(RecommendedButton, gridBagConstraints);
        OKButton.setText("OK");
        OKButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent evt)
            {
                OKButtonActionPerformed(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 10;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.anchor = 13;
        getContentPane().add(OKButton, gridBagConstraints);
        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent evt)
            {
                CancelButtonActionPerformed(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 11;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.anchor = 17;
        getContentPane().add(CancelButton, gridBagConstraints);
        DescriptionWindow.setLayout(new GridBagLayout());
        DescriptionWindow.setBorder(new EtchedBorder());
        DescriptionText.setBackground(new Color(0, 0, 0));
        DescriptionText.setForeground(new Color(255, 255, 153));
        DescriptionText.setLineWrap(true);
        DescriptionText.setWrapStyleWord(true);
        DescriptionText.setPreferredSize(new Dimension(400, 300));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = 1;
        DescriptionWindow.add(DescriptionText, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.gridwidth = 0;
        gridBagConstraints.fill = 1;
        DescriptionWindow.add(jPanel7, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 0;
        gridBagConstraints.fill = 1;
        DescriptionWindow.add(jPanel8, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 0;
        gridBagConstraints.fill = 1;
        DescriptionWindow.add(jPanel9, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = 0;
        gridBagConstraints.fill = 1;
        DescriptionWindow.add(jPanel10, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 10;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 6;
        gridBagConstraints.gridheight = 13;
        gridBagConstraints.fill = 1;
        getContentPane().add(DescriptionWindow, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel1, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 9;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel2, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.gridwidth = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel3, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel4, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 16;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel5, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 16;
        gridBagConstraints.gridwidth = 0;
        gridBagConstraints.fill = 1;
        getContentPane().add(jPanel6, gridBagConstraints);
        NameLabel.setBackground(new Color(0, 0, 0));
        NameLabel.setFont(new Font("Trebuchet MS", 0, 10));
        NameLabel.setForeground(new Color(255, 255, 102));
        NameLabel.setHorizontalAlignment(0);
        NameLabel.setText("Name");
        NameLabel.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(NameLabel, gridBagConstraints);
        Race.setBackground(new Color(0, 0, 0));
        Race.setFont(new Font("Trebuchet MS", 0, 10));
        Race.setForeground(new Color(255, 255, 102));
        Race.setHorizontalAlignment(0);
        Race.setText("Race");
        Race.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(Race, gridBagConstraints);
        Points.setBackground(new Color(0, 0, 0));
        Points.setFont(new Font("Trebuchet MS", 0, 10));
        Points.setForeground(new Color(255, 255, 102));
        Points.setHorizontalAlignment(0);
        Points.setText("Current");
        Points.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(Points, gridBagConstraints);
        StatMod.setBackground(new Color(0, 0, 0));
        StatMod.setFont(new Font("Trebuchet MS", 0, 10));
        StatMod.setForeground(new Color(255, 255, 102));
        StatMod.setHorizontalAlignment(0);
        StatMod.setText("Mod");
        StatMod.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 5;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(StatMod, gridBagConstraints);
        Total.setBackground(new Color(0, 0, 0));
        Total.setFont(new Font("Trebuchet MS", 0, 10));
        Total.setForeground(new Color(255, 255, 102));
        Total.setHorizontalAlignment(0);
        Total.setText("Total");
        Total.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 6;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(Total, gridBagConstraints);
        IncreaseCost.setBackground(new Color(0, 0, 0));
        IncreaseCost.setFont(new Font("Trebuchet MS", 0, 10));
        IncreaseCost.setForeground(new Color(255, 255, 102));
        IncreaseCost.setHorizontalAlignment(0);
        IncreaseCost.setText("Cost");
        IncreaseCost.setOpaque(true);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = 1;
        getContentPane().add(IncreaseCost, gridBagConstraints);
        StrCost.setBackground(new Color(0, 0, 0));
        StrCost.setForeground(new Color(255, 255, 153));
        StrCost.setHorizontalAlignment(0);
        StrCost.setText("8");
        StrCost.setBorder(null);
        StrCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(StrCost, gridBagConstraints);
        DexCost.setBackground(new Color(0, 0, 0));
        DexCost.setForeground(new Color(255, 255, 153));
        DexCost.setHorizontalAlignment(0);
        DexCost.setText("8");
        DexCost.setBorder(null);
        DexCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(DexCost, gridBagConstraints);
        ConCost.setBackground(new Color(0, 0, 0));
        ConCost.setForeground(new Color(255, 255, 153));
        ConCost.setHorizontalAlignment(0);
        ConCost.setText("8");
        ConCost.setBorder(null);
        ConCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(ConCost, gridBagConstraints);
        IntCost.setBackground(new Color(0, 0, 0));
        IntCost.setForeground(new Color(255, 255, 153));
        IntCost.setHorizontalAlignment(0);
        IntCost.setText("8");
        IntCost.setBorder(null);
        IntCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(IntCost, gridBagConstraints);
        WisCost.setBackground(new Color(0, 0, 0));
        WisCost.setForeground(new Color(255, 255, 153));
        WisCost.setHorizontalAlignment(0);
        WisCost.setText("8");
        WisCost.setBorder(null);
        WisCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(WisCost, gridBagConstraints);
        ChaCost.setBackground(new Color(0, 0, 0));
        ChaCost.setForeground(new Color(255, 255, 153));
        ChaCost.setHorizontalAlignment(0);
        ChaCost.setText("8");
        ChaCost.setBorder(null);
        ChaCost.setPreferredSize(new Dimension(20, 22));
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 7;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = 1;
        gridBagConstraints.insets = new Insets(0, 6, 0, 6);
        getContentPane().add(ChaCost, gridBagConstraints);
        StatBackground.setBackground(new Color(0, 0, 0));
        StatBackground.setBorder(new EtchedBorder());
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.gridwidth = 7;
        gridBagConstraints.gridheight = 6;
        gridBagConstraints.fill = 1;
        getContentPane().add(StatBackground, gridBagConstraints);
        ResetButton.setText("Reset");
        ResetButton.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent evt)
            {
                ResetButtonActionPerformed(evt);
            }

        });
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.gridwidth = 3;
        gridBagConstraints.anchor = 13;
        getContentPane().add(ResetButton, gridBagConstraints);
        pack();
    }

    private void ResetButtonActionPerformed(ActionEvent evt)
    {
        OKButton.setEnabled(false);
        //System.out.println("AC : " +evt.getActionCommand() + " SRC: " + evt.getSource().toString() + " ID: " + evt.getID());
        StrRaceMod.setText(racemod[0]);
        DexRaceMod.setText(racemod[1]);
        ConRaceMod.setText(racemod[5]);
        IntRaceMod.setText(racemod[2]);
        WisRaceMod.setText(racemod[4]);
        ChaRaceMod.setText(racemod[3]);
        ResetStats();
        ResetAllSpinners();
        CURRENTPOINTS = TOTALPOINTS;
        OLDSTR = StartingValue;
        OLDWIS = StartingValue;
        OLDDEX = StartingValue;
        OLDINT = StartingValue;
        OLDCON = StartingValue;
        OLDCHA = StartingValue;
        StrSpinnerStateChanged(new ChangeEvent(this));
        DexSpinnerStateChanged(new ChangeEvent(this));
        ConSpinnerStateChanged(new ChangeEvent(this));
        IntSpinnerStateChanged(new ChangeEvent(this));
        WisSpinnerStateChanged(new ChangeEvent(this));
        ChaSpinnerStateChanged(new ChangeEvent(this));
        CurrentPoints.setText(Integer.toString(TOTALPOINTS));
        DescriptionText.setText(TLKFAC.getEntry(457));
        RecommendedButton.setEnabled(true);
    }

    private void ChaSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(ChaSpinner.getValue().toString())).intValue();
        String racemodstr = ChaRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        ChaTotal.setText((new Integer(newtmpvalue)).toString());
        ChaMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        ChaCost.setText((new Integer(cost)).toString());
        if(OLDCHA < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDCHA++;
        } else
        if(OLDCHA > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDCHA--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(478));
    }

    private void WisSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(WisSpinner.getValue().toString())).intValue();
        String racemodstr = WisRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        WisTotal.setText((new Integer(newtmpvalue)).toString());
        WisMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        WisCost.setText((new Integer(cost)).toString());
        if(OLDWIS < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDWIS++;
        } else
        if(OLDWIS > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDWIS--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(462));
    }

    private void IntSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(IntSpinner.getValue().toString())).intValue();
        String racemodstr = IntRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        IntTotal.setText((new Integer(newtmpvalue)).toString());
        IntMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        IntCost.setText((new Integer(cost)).toString());
        if(OLDINT < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDINT++;
        } else
        if(OLDINT > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDINT--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(463));
    }

    private void DexSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(DexSpinner.getValue().toString())).intValue();
        String racemodstr = DexRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        DexTotal.setText((new Integer(newtmpvalue)).toString());
        DexMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        DexCost.setText((new Integer(cost)).toString());
        if(OLDDEX < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDDEX++;
        } else
        if(OLDDEX > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDDEX--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(460));
    }

    private void ConSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(ConSpinner.getValue().toString())).intValue();
        String racemodstr = ConRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        ConTotal.setText((new Integer(newtmpvalue)).toString());
        ConMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        ConCost.setText((new Integer(cost)).toString());
        if(OLDCON < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDCON++;
        } else
        if(OLDCON > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDCON--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(461));
    }

    private void StrSpinnerStateChanged(ChangeEvent evt)
    {
        int tmpvalue = (new Integer(StrSpinner.getValue().toString())).intValue();
        String racemodstr = StrRaceMod.getText();
        if(racemodstr.startsWith("+"))
            racemodstr = racemodstr.substring(1, racemodstr.length());
        int racemod = (new Integer(racemodstr)).intValue();
        int newtmpvalue = tmpvalue + racemod;
        StrTotal.setText((new Integer(newtmpvalue)).toString());
        StrMod.setText(getStatMod(newtmpvalue));
        int cost = getCost(tmpvalue);
        StrCost.setText((new Integer(cost)).toString());
        if(OLDSTR < tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS - getCost(tmpvalue - 1);
            OLDSTR++;
        } else
        if(OLDSTR > tmpvalue)
        {
            CURRENTPOINTS = CURRENTPOINTS + getCost(tmpvalue);
            OLDSTR--;
        }
        updatepoints();
        DescriptionText.setText(TLKFAC.getEntry(459));
    }

    private void StrLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(459));
    }
    
    private void DexLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(460));
    }
    
    private void ConLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(461));
    }
    
    private void IntLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(463));
    }

    private void WisLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(462));
    }
    
    private void ChaLabelMouseClicked(java.awt.event.MouseEvent evt) {
        // Add your handling code here:
        DescriptionText.setText(TLKFAC.getEntry(478));
    }
    
    private void CancelButtonActionPerformed(ActionEvent evt)
    {
        menucreate.BlockWindow(false);        
        setVisible(false);
        dispose();
    }

    private void OKButtonActionPerformed(ActionEvent evt)
    {
        menucreate.MainCharData[5] = new HashMap();
        menucreate.MainCharData[5].put(new Integer(0), StrTotal.getText());
        menucreate.MainCharData[5].put(new Integer(1), DexTotal.getText());
        menucreate.MainCharData[5].put(new Integer(2), ConTotal.getText());
        menucreate.MainCharData[5].put(new Integer(3), IntTotal.getText());
        menucreate.MainCharData[5].put(new Integer(4), WisTotal.getText());
        menucreate.MainCharData[5].put(new Integer(5), ChaTotal.getText());
        menucreate.MainCharData[5].put(new Integer(6), (StrSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(7), (DexSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(8), (ConSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(9), (IntSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(10), (WisSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(11), (ChaSpinner.getValue()).toString());
        menucreate.MainCharData[5].put(new Integer(12), Integer.toString(getrealmod(StrMod.getText())));
        menucreate.MainCharData[5].put(new Integer(13), Integer.toString(getrealmod(DexMod.getText())));
        menucreate.MainCharData[5].put(new Integer(14), Integer.toString(getrealmod(ConMod.getText())));
        menucreate.MainCharData[5].put(new Integer(15), Integer.toString(getrealmod(IntMod.getText())));
        menucreate.MainCharData[5].put(new Integer(16), Integer.toString(getrealmod(WisMod.getText())));
        menucreate.MainCharData[5].put(new Integer(17), Integer.toString(getrealmod(ChaMod.getText())));
        menucreate.Strength.setText(StrTotal.getText());
        menucreate.Dexterity.setText(DexTotal.getText());
        menucreate.Constitution.setText(ConTotal.getText());
        menucreate.Intelligence.setText(IntTotal.getText());
        menucreate.Wisdom.setText(WisTotal.getText());
        menucreate.Charisma.setText(ChaTotal.getText());
        menucreate.StrMod.setText(StrMod.getText());
        menucreate.DexMod.setText(DexMod.getText());
        menucreate.ConMod.setText(ConMod.getText());
        menucreate.IntMod.setText(IntMod.getText());
        menucreate.WisMod.setText(WisMod.getText());
        menucreate.ChaMod.setText(ChaMod.getText());
        menucreate.PackagesButton.setEnabled(true);
        menucreate.RedoAll();
        menucreate.BlockWindow(false);        
        setVisible(false);
        dispose();
    }

    private void RecommendedButtonActionPerformed(ActionEvent evt)
    {
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        OKButton.setEnabled(true);
        //Reset all stats FIRST
        StrRaceMod.setText(racemod[0]);
        DexRaceMod.setText(racemod[1]);
        ConRaceMod.setText(racemod[5]);
        IntRaceMod.setText(racemod[2]);
        WisRaceMod.setText(racemod[4]);
        ChaRaceMod.setText(racemod[3]);
        ResetStats();
        ResetAllSpinners();
        CURRENTPOINTS = TOTALPOINTS;
        OLDSTR = StartingValue;
        OLDWIS = StartingValue;
        OLDDEX = StartingValue;
        OLDINT = StartingValue;
        OLDCON = StartingValue;
        OLDCHA = StartingValue;
        StrSpinnerStateChanged(new ChangeEvent(this));
        DexSpinnerStateChanged(new ChangeEvent(this));
        ConSpinnerStateChanged(new ChangeEvent(this));
        IntSpinnerStateChanged(new ChangeEvent(this));
        WisSpinnerStateChanged(new ChangeEvent(this));
        ChaSpinnerStateChanged(new ChangeEvent(this));
        CurrentPoints.setText(Integer.toString(TOTALPOINTS));
        //DescriptionText.setText(TLKFAC.getEntry(457));
        //RecommendedButton.setEnabled(true);

        //Now do recommended stuff
        
        int StrIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Str]) - StartingValue;
        int DexIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Dex]) - StartingValue;
        int ConIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Con]) - StartingValue;
        int IntIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Int]) - StartingValue;
        int WisIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Wis]) - StartingValue;
        int ChaIncrease = Integer.parseInt(menucreate.MainCharDataAux[3][classes.Cha]) - StartingValue;
        increaseStat(0, StrIncrease);
        increaseStat(1, DexIncrease);
        increaseStat(2, ConIncrease);
        increaseStat(3, IntIncrease);
        increaseStat(4, WisIncrease);
        increaseStat(5, ChaIncrease);
        RecommendedButton.setEnabled(false);
        DescriptionText.setText(TLKFAC.getEntry(457));

        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        
    }

    private void exitForm(WindowEvent evt)
    {
        menucreate.BlockWindow(false);        
        setVisible(false);
        dispose();
    }

    public int getrealmod(String mod) {
        int returnable = 0;
        try {
            if(mod.indexOf("+") == -1) {
                return new Integer(mod).intValue();
            } else {
                String realmod = mod.substring(1);
                return new Integer(realmod).intValue();
            }
        }
        catch (NumberFormatException e) {
            System.out.println("Number Format Exception warning: " + mod + " is not a true stat mod.");
            return 0;
        }
        
    }
    
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private CreateMenu menucreate;
    public Map abilitiesmap[];
    public int TOTALPOINTS;
    public int CURRENTPOINTS;
    public static int MINSTAT = 8;
    public static int MAXSTAT = 18;
    public int STRMAX;
    public int DEXMAX;
    public int CONMAX;
    public int WISMAX;
    public int INTMAX;
    public int CHAMAX;
    public int STRMIN;
    public int DEXMIN;
    public int CONMIN;
    public int WISMIN;
    public int INTMIN;
    public int CHAMIN;
    public int OLDSTR;
    public int OLDDEX;
    public int OLDCON;
    public int OLDWIS;
    public int OLDINT;
    public int OLDCHA;
    public int StartingValue;
    int modifier[];
    String racemod[];
    private JTextField StrCost;
    private JSpinner ChaSpinner;
    private JTextField DexRaceMod;
    private JLabel Race;
    private JTextField WisRaceMod;
    private JLabel StatMod;
    private JButton CancelButton;
    private JPanel DescriptionWindow;
    private JTextField ChaCost;
    private JTextField ChaMod;
    private JLabel IntLabel;
    private JTextField DexCost;
    private JLabel StrLabel;
    private JPanel jPanel10;
    private JLabel ChaLabel;
    private JSpinner ConSpinner;
    private JTextField ChaRaceMod;
    private JTextField ConCost;
    private JLabel IncreaseCost;
    private JButton RecommendedButton;
    private JSpinner IntSpinner;
    private JSpinner StrSpinner;
    private JPanel StatBackground;
    private JButton ResetButton;
    private JPanel PointsPanel;
    private JTextField ConMod;
    private JPanel jPanel9;
    private JPanel jPanel8;
    private JLabel DexLabel;
    private JPanel jPanel7;
    private JTextField IntCost;
    private JPanel jPanel6;
    private JPanel jPanel5;
    private JPanel jPanel4;
    private JPanel jPanel3;
    private JPanel jPanel2;
    private JPanel jPanel1;
    private JTextField IntTotal;
    private JTextField StrTotal;
    private JTextField IntMod;
    private JLabel WisLabel;
    private JLabel ConLabel;
    private JLabel PointsLabel;
    private JTextField StrMod;
    private JTextField ConRaceMod;
    private JTextField WisCost;
    private JButton OKButton;
    private JTextArea DescriptionText;
    private JTextField ChaTotal;
    private JLabel Total;
    private JSpinner DexSpinner;
    private JTextField IntRaceMod;
    private JTextField StrRaceMod;
    private JTextField CurrentPoints;
    private JSpinner WisSpinner;
    private JTextField DexTotal;
    private JTextField DexMod;
    private JLabel NameLabel;
    private JLabel Points;
    private JTextField WisTotal;
    private JTextField ConTotal;
    private JTextField WisMod;

}
