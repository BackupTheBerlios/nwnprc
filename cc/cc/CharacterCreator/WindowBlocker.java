/*
 * WindowBlocker.java
 *
 * Created on February 23, 2003, 6:23 PM
 */
package CharacterCreator;

import java.awt.Component;
import java.awt.Cursor;
import java.awt.event.MouseAdapter;
import java.io.PrintStream;
import javax.swing.RootPaneContainer;

public final class WindowBlocker
{

    public WindowBlocker(RootPaneContainer window)
    {
        if(window == null)
        {
            System.out.println("No window found.");
            return;
        } else
        {
            glassPane = window.getGlassPane();
            glassPane.setCursor(Cursor.getPredefinedCursor(3));
            glassPane.addMouseListener(DUMMY_MOUSE_LISTENER);
            return;
        }
    }

    public void setBlocked(boolean blocked)
    {
        if(glassPane == null)
        {
            System.out.println("No glasspane found.");
            return;
        } else
        {
            glassPane.setVisible(blocked);
            return;
        }
    }

    private static final MouseAdapter DUMMY_MOUSE_LISTENER = new MouseAdapter() {

    };
    private Component glassPane;

}
