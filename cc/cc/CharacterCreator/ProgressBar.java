/*
 * ProgressBar.java
 *
 * Created on February 23, 2003, 6:29 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.*;

// Referenced classes of package CharacterCreator:
//            ResourceFactory, TLKFactory

public class ProgressBar extends JFrame
{

    public ProgressBar()
    {
        initComponents();
        
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();            
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }        
    }

    private void initComponents()
    {
        ProgressBar = new JProgressBar();
        ProgressText = new JLabel();
        jPanel1 = new JPanel();
        jPanel2 = new JPanel();
        jPanel3 = new JPanel();
        jPanel4 = new JPanel();
        getContentPane().setLayout(new GridBagLayout());
        setResizable(false);
        setUndecorated(true);
        addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent evt)
            {
                exitForm(evt);
            }

        });
        ProgressBar.setMaximum(1000);
        GridBagConstraints gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = 2;
        getContentPane().add(ProgressBar, gridBagConstraints);
        ProgressText.setFont(new Font("Trebuchet MS", 0, 12));
        ProgressText.setHorizontalAlignment(2);
        ProgressText.setText("PHTEXT");
        ProgressText.setVerticalAlignment(1);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = 2;
        getContentPane().add(ProgressText, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel1, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel2, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        getContentPane().add(jPanel3, gridBagConstraints);
        gridBagConstraints = new GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 2;
        getContentPane().add(jPanel4, gridBagConstraints);
        pack();
    }

    private void exitForm(WindowEvent evt)
    {
        System.exit(0);
    }

    private ResourceFactory RESFACTORY;
    private TLKFactory TLKFACTORY;
    private JPanel jPanel4;
    private JPanel jPanel3;
    private JPanel jPanel2;
    private JPanel jPanel1;
    public JLabel ProgressText;
    public JProgressBar ProgressBar;

}
