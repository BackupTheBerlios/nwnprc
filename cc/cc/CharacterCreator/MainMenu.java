/*
 * MainMenu1.java
 *
 * Created on April 3, 2003, 5:37 PM
 */

package CharacterCreator;

import java.util.zip.CRC32;
import CharacterCreator.ResVer;
import java.lang.*;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.net.*;
import java.io.PrintStream;
import java.util.prefs.Preferences;
import javax.swing.*;
import CharacterCreator.util.*;
import CharacterCreator.io.*;
/**
 *
 * @author  James
 */
public class MainMenu extends javax.swing.JFrame {
    
    /** Creates new form MainMenu1 */
    public MainMenu() {
        crc = new CRC32();
        Preferences newprefs = Preferences.userNodeForPackage(getClass());
        String filedelimiter = System.getProperty("file.separator");
        newprefs.put("FileDelim", filedelimiter);
        initComponents();
        VersionTag.setText("v. " + versionumber);
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }
        ResVer rv = new ResVer();
        int tst = rv.VerifyResources();
    }
    
    public boolean isWindows() {
        if(System.getProperty("os.name").equalsIgnoreCase("Windows XP")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Windows Me")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Windows 98")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Windows 95")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Linux")) {
            return false;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Windows 2000")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Windows NT")) {
            return true;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Mac OS")) {
            return false;
        }
        if(System.getProperty("os.name").equalsIgnoreCase("Mac OS X")) {
            return false;
        }
        return false;
    }
    
    public static MainMenu getMainMenu() {
        return mainmenu;
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        CreateButton = new javax.swing.JButton();
        SettingsButton = new javax.swing.JButton();
        CreditsButton = new javax.swing.JButton();
        ExitButton = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        VersionTag = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();

        getContentPane().setLayout(new java.awt.GridBagLayout());

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("NWN Character Creator");
        setResizable(false);
        setUndecorated(true);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashtop.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = 10;
        getContentPane().add(jLabel1, gridBagConstraints);

        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashleft.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 3;
        getContentPane().add(jLabel2, gridBagConstraints);

        CreateButton.setBackground(new java.awt.Color(204, 204, 0));
        CreateButton.setForeground(new java.awt.Color(204, 204, 0));
        CreateButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/charpic.jpg")));
        CreateButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
        CreateButton.setPreferredSize(new java.awt.Dimension(121, 30));
        CreateButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CreateButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        getContentPane().add(CreateButton, gridBagConstraints);

        SettingsButton.setBackground(new java.awt.Color(204, 204, 0));
        SettingsButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/settingspic.jpg")));
        SettingsButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
        SettingsButton.setPreferredSize(new java.awt.Dimension(121, 30));
        SettingsButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SettingsButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        getContentPane().add(SettingsButton, gridBagConstraints);

        CreditsButton.setBackground(new java.awt.Color(204, 204, 0));
        CreditsButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/creditspic.jpg")));
        CreditsButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
        CreditsButton.setPreferredSize(new java.awt.Dimension(121, 34));
        CreditsButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CreditsButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        getContentPane().add(CreditsButton, gridBagConstraints);

        ExitButton.setBackground(new java.awt.Color(204, 204, 0));
        ExitButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/exitpic.jpg")));
        ExitButton.setMargin(new java.awt.Insets(0, 0, 0, 0));
        ExitButton.setPreferredSize(new java.awt.Dimension(121, 34));
        ExitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ExitButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        getContentPane().add(ExitButton, gridBagConstraints);

        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashmiddle1.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jLabel3, gridBagConstraints);

        jLabel4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashmiddle2.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 3;
        getContentPane().add(jLabel4, gridBagConstraints);

        jLabel5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashmiddle3.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jLabel5, gridBagConstraints);

        VersionTag.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        VersionTag.setForeground(new java.awt.Color(255, 214, 173));
        VersionTag.setText("V. 1.1");
        VersionTag.setVerticalAlignment(javax.swing.SwingConstants.BOTTOM);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.SOUTHWEST;
        gridBagConstraints.insets = new java.awt.Insets(0, 12, 7, 0);
        getContentPane().add(VersionTag, gridBagConstraints);

        jLabel6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashbottom.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.gridwidth = 5;
        getContentPane().add(jLabel6, gridBagConstraints);

        jLabel7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/CharacterCreator/resource/splashright.jpg")));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridheight = 3;
        getContentPane().add(jLabel7, gridBagConstraints);

        pack();
    }//GEN-END:initComponents
    
    private void ExitButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ExitButtonActionPerformed
        // Add your handling code here:
        System.exit(0);
    }//GEN-LAST:event_ExitButtonActionPerformed
    
    private void CreditsButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CreditsButtonActionPerformed
        // Add your handling code here:
        new CreditsMenu().show();
    }//GEN-LAST:event_CreditsButtonActionPerformed
    
    private void SettingsButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SettingsButtonActionPerformed
        // Add your handling code here:
        (new SettingsMenu()).show();
        setVisible(false);
        dispose();
    }//GEN-LAST:event_SettingsButtonActionPerformed
    
    private void CreateButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CreateButtonActionPerformed
        // Add your handling code here:
        Preferences prefs = Preferences.userNodeForPackage(getClass());
        String GameDir = prefs.get("GameDir", null);
        if(GameDir == null) {
            if(isWindows()) {
                if(Win32.findNwnRoot().exists()) {
                    GameDir = Win32.findNwnRoot().getAbsolutePath();
                    prefs.put("GameDir", GameDir);
                }
            } else {
                JOptionPane.showMessageDialog(null, "Invalid NWN Directory. Please run Settings.", "Error", 0);
                System.exit(1);
            }
        }
        if(!(new File(GameDir)).exists()) {
            JOptionPane.showMessageDialog(null, "No Settings information found. Please run Settings.", "Error", 0);
            return;
        }
        if(!(new File(GameDir, "chitin.key")).exists()) {
            if(isWindows()) {
                if(Win32.findNwnRoot().exists()) {
                    GameDir = Win32.findNwnRoot().getAbsolutePath();
                    prefs.put("GameDir", GameDir);
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid NWN Directory. Please run Settings.", "Error", 0);
                    return;
                }
            }
            if(!(new File(GameDir, "chitin.key")).exists()) {
                JOptionPane.showMessageDialog(null, "CHITIN.KEY file missing.", "Error", 0);
                System.exit(1);
            }
            //if(!(new File(GameDir, "patch.key")).exists()) {
            //    JOptionPane.showMessageDialog(null, "PATCH.KEY file missing. Please update your version of NWN.", "Error", 0);
            //    System.exit(1);
            //}
        }
        String filedelim = prefs.get("FileDelim", null);
        if(!GameDir.endsWith(filedelim)) {
            GameDir += filedelim;
            prefs.put("GameDir", GameDir);
        }
        if(isWindows()) {
            float nwnver = new Float(Win32.getNwnVersion()).floatValue();
            if(nwnver < 1.59) {
                JOptionPane.showMessageDialog(null, "Warning - Your version of NWN is " + Win32.getNwnVersion() + ". Please patch to the latest version.", "Error", 0);
            }
        }
        //System.out.println(System.getProperty("os.arch"));
        //System.out.println(System.getProperty("os.name"));
        SwingWorker worker2 = new SwingWorker() {
            
            public Object construct() {
                return new TLKFactory();
            }
            
        };
        worker2.start();
        setVisible(false);
        dispose();
        return;
        
    }//GEN-LAST:event_CreateButtonActionPerformed
    
    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
        System.exit(0);
    }//GEN-LAST:event_exitForm
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        String javaVersion = System.getProperty("java.specification.version");
        try {
            if(Integer.parseInt(javaVersion.substring(0, 1)) < 2 && Integer.parseInt(javaVersion.substring(2, 3)) < 4) {
                JOptionPane.showMessageDialog(null, "Version 1.4 or newer of Java required", "Error", 0);
                System.exit(10);
            }
        }
        
        catch(Exception e) { }
        
        
        mainmenu = new MainMenu();
        mainmenu.show();
        
    }
    
    public CRC32 crc;
    //*******************************************************
    //************VERSION INFORMATION - CHANGE HERE**********
    public static String versionumber = "PRC: 1.3";
    //*******************************************************
    private static MainMenu mainmenu;
    private static CreateMenu createmenu;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton CreateButton;
    private javax.swing.JButton CreditsButton;
    private javax.swing.JButton ExitButton;
    private javax.swing.JButton SettingsButton;
    private javax.swing.JLabel VersionTag;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    // End of variables declaration//GEN-END:variables
}
