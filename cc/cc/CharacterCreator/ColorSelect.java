/*
 * ColorSelect.java
 *
 * Created on March 18, 2003, 10:57 PM
 */

package CharacterCreator;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

/**
 *
 * @author  James
 */
public class ColorSelect extends javax.swing.JFrame {
    
    public class NewButton extends javax.swing.JButton {
        
        public void CreateButton(String type, int i) {
            //newbutton = new JButton();
            //getContentPane().add(newbutton, -1);
            String filename = "/CharacterCreator/resource/color/" + type + i + ".jpg";
            ImageIcon newicon = new ImageIcon(getClass().getResource(filename));
            newicon.setDescription(type + i + ".jpg");
            setIcon(newicon);
            setSize(16,16);
            setBorder(null);
            setMargin(new java.awt.Insets(0, 0, 0, 0));
            addActionListener(new ActionListener() {
                
                public void actionPerformed(ActionEvent evt) {
                    NewButtonActionPerformed(evt);
                }
                
            });
            //FILENAME = filename;
            //ButFrame.add(newbutton, -1);
            
        }
        
        private void NewButtonActionPerformed(ActionEvent evt) {
            //System.out.println("BUTTON PRESSED");
            javax.swing.Icon test = getIcon();
            if(test instanceof ImageIcon) {
                //System.out.println(((ImageIcon)test).getDescription());
                SelectedColor.setIcon(test);
                //System.out.println(FILENAME);
            }
        }
        //public String FILENAME;
        JButton newbutton;
        
        public void NewButton(String type, int i) {
            CreateButton(type, i);
            return;
        }
    }
    
    /** Creates a new instance of ColorSelect.
     *@param type Should be hair, skin, or tattoo
     */
    public ColorSelect(String type, JLabel tmp) {
        deftype = type;
        targetlabel = tmp;
        //System.out.println("ColorSelect initialized");
        initComponents();
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();            
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }        
        //for(int i=0; i<4; i++) {
        for(int i=0; i<64; i++) {
            NewButton test = new NewButton();
            test.NewButton(type, i);
            ButFrame.add(test, -1);
        }
        //ButFrame.setMaximumSize(new Dimension(128,128));
        //ButFrame.setSize(128,128);
        //setSize(200, 250);
        pack();
    }
    
    
    
    
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;
        getContentPane().setLayout(new java.awt.GridBagLayout());
        setResizable(false);
        
        ButFrame = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();
        SelectedColor = new javax.swing.JLabel();
        
        //getContentPane().setLayout(new GridLayout(8, 8));
        ButFrame.setLayout(new GridLayout(8, 8, 0, 0));
        ButFrame.setMaximumSize(new java.awt.Dimension(138, 138));
        ButFrame.setMinimumSize(new java.awt.Dimension(138, 138));
        ButFrame.setPreferredSize(new java.awt.Dimension(138, 138));
        ButFrame.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(0, 0, 0, 0)));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });
        
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;        
        getContentPane().add(ButFrame, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel3, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel4, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel5, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel6, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(jPanel7, gridBagConstraints);

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
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        SelectedColor.setToolTipText("null");
        SelectedColor.setBorder(new javax.swing.border.EtchedBorder(javax.swing.border.EtchedBorder.RAISED));
        SelectedColor.setMaximumSize(new java.awt.Dimension(20, 20));
        SelectedColor.setMinimumSize(new java.awt.Dimension(20, 20));
        SelectedColor.setPreferredSize(new java.awt.Dimension(20, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        getContentPane().add(SelectedColor, gridBagConstraints);        
        
        //pack();
    }
    
    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        Icon test = SelectedColor.getIcon();
        if(((ImageIcon)test).getDescription() == null) {
            
        }
        String output = ((ImageIcon)test).getDescription();
        //System.out.println(output);
        Integer tmp = new Integer(output.substring(deftype.length(),output.indexOf(".")));
        colornum = tmp.intValue();
        //System.out.println(output.substring(deftype.length(),output.indexOf(".")));
        targetlabel.setText(output.substring(deftype.length(),output.indexOf(".")));
        setVisible(false);
        dispose();         
    }

    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {
        // Add your handling code here:
        setVisible(false);
        dispose();        
    }    
    
    private void exitForm(java.awt.event.WindowEvent evt) {
        //System.exit(0);
        setVisible(false);
        dispose();
    }
    
    public int getColor() {
        return colornum;
    }
    /**
     * @param args the command line arguments
     */
//    public static void main(String args[]) {
//        new ColorSelect("hair").show();
//    }
    
    JLabel targetlabel;
    int colornum;
    JLabel SelectedColor;
    JButton OKButton;
    JButton CancelButton;
    JPanel jPanel2;
    JPanel jPanel3;
    JPanel jPanel4;
    JPanel jPanel5;
    JPanel jPanel6;
    JPanel jPanel7;
    JPanel ButFrame;
    String deftype;
    public String FILENAME;
}
