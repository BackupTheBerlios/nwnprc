/*
 * Win32.java
 *
 * Created on April 13, 2003, 9:26 PM
 */

package CharacterCreator;

/**
 *
 * @author  James
 */
import java.lang.reflect.*; 
import java.io.*; 
import java.util.prefs.Preferences; 


public class Win32 
{ 

    private static final byte[] BIOWARE_PATH = 
        stringToByteArray("SOFTWARE\\BioWare\\NWN\\Neverwinter"); 

    private static boolean initialized = false; 
    private static String version; 
    private static File nwnRoot; 

    private static void initialize() 
    { 
        if (initialized) 
            return; 

        try 
        { 
            System.out.println("Reading Bioware registry settings"); 
            Class cl = Class.forName("java.util.prefs.WindowsPreferences"); 

            Object obj = Preferences.systemRoot(); 

            Method open = cl.getDeclaredMethod("WindowsRegOpenKey1", 
                    new Class[] 
                    {Integer.TYPE, byte[].class, Integer.TYPE} 
                ); 

            open.setAccessible(true); 

            Method close = cl.getDeclaredMethod("WindowsRegCloseKey", 
                    new Class[] 
                    {Integer.TYPE} 
                ); 

            close.setAccessible(true); 

            Method query = cl.getDeclaredMethod("WindowsRegQueryValueEx", 
                    new Class[] 
                    {Integer.TYPE, byte[].class} 
                ); 

            query.setAccessible(true); 

            int[] answer = (int[]) open.invoke(obj, new Object[] 
                    {new Integer(0x80000002), BIOWARE_PATH, new Integer(1)} 
                ); 

            if (answer[1] != 0) 
            { 
                System.out.println("Cannot read Bioware registry settings, error " + answer[1]); 
                return; 
            } 
            Integer natHandle = new Integer(answer[0]); 

            byte[] str = (byte[]) query.invoke(obj, new Object[] 
                    {natHandle, stringToByteArray("Version")} 
                ); 
                
            if ( str == null ) 
            { 
                System.out.println("I cannot find registry keys for NWN"); 
                return; 
            } 

            version = new String(str, 0, str.length - 1); 

            str = (byte[]) query.invoke(obj, new Object[] 
                        {natHandle, stringToByteArray("Location")} 
                    ); 
            nwnRoot = new File(new String(str, 0, str.length - 1)); 

            close.invoke(obj, new Object[] 
                {natHandle} 
            ); 

        } catch (Exception exc) 
        { 
            exc.printStackTrace(); 
        } 
        finally 
        { 
            initialized = true; 
        } 

        
    } 

    private static byte[] stringToByteArray(String str) 
    { 
        byte[] result = new byte[str.length() + 1]; 

        for (int i = 0; i < str.length(); i++) 
        { 
            result[i] = (byte) str.charAt(i); 
        } 
        result[str.length()] = 0; 
        return result; 
    } 

    public static File findNwnRoot() 
    { 
        initialize(); 
        System.out.println("NWN root = " + nwnRoot); 
        return nwnRoot; 
    } 

    public static String getNwnVersion() 
    { 
        initialize(); 
        System.out.println("NWN version = " + version); 
        return version; 
    } 

} 
