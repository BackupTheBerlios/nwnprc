/*
 *	Sound.java
 *
 *	Created on November 21, 2004
 *
 *	-Judd
 */

package CharacterCreator;

import Music.NativeFmod.*;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteOrder;
import java.nio.ByteBuffer;

public class Sound {
	private static String[] soundFiles = null;
	private static String soundSet = null;
	private static int index = 0;
	
	private static boolean initOK = true;
	
	static{
		try{
			Fmod.loadLibraries();
		}catch(Exception e){
			System.err.println("Could not load sound module!");
			initOK = false;
		}
	}

	public static void Play(String filename) {
		// If loading the native sound library failed, do not attempt to play any sounds
		if(!initOK) return;
		
		ResourceFactory rFac = TLKFactory.getCreateMenu().getResourceFactory();
		String name = ResourceFactory.fixFilename(filename, ".ssf");

		if (soundSet == null || soundSet.compareTo(name) != 0) {
			index = 0;
			// Get the SSF for this char
			try {
				if (rFac.SetToResource(name)) {
					byte[] ssf = rFac.getResBuffer();
					ByteBuffer bb = ByteBuffer.wrap(ssf);
					bb.order(ByteOrder.LITTLE_ENDIAN);
					int arrayLength = bb.getInt(8);
					String[] names = new String[arrayLength];
					for (int ii=0; ii<arrayLength; ++ii) {
						int offset = bb.getInt((ii * 4) + 40);
						names[ii] = null;
						int len = 16;
						for (int jj=0; jj<16; ++jj) {
							if (ssf[offset + jj] == 0) {
								len = jj;
								break;
							}
						}
						if (len > 0) {
							names[ii] = new String(ssf, offset, len) + ".wav";
							names[ii] = ResourceFactory.fixFilename(names[ii], ".wav");
						}
					}

					int count = 0;
					for (int ii=0; ii<names.length; ++ii)
						if (names[ii] != null)
							++count;

					soundFiles = new String[count];
					count = 0;
					for (int ii=0; ii<names.length; ++ii) {
						if (names[ii] != null) {
							soundFiles[count] = names[ii];
							++count;
						}
					}

					if (soundFiles.length > 0)
						soundSet = name;
					else
						soundSet = null;
				}
			}
			catch (Exception e) {
				System.out.println("SOUND ERROR");
				e.printStackTrace();
			}
		}

		if (soundFiles != null) {
			index %= soundFiles.length;
			try {
				if (rFac.SetToResource(soundFiles[index])) {
					byte[] sound = rFac.getResBuffer();
					Sound.Play(sound);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			++index;
		}
	}

	// Play the provided data stream using FMOD
	public static void Play(byte[] data) throws Exception{
		// Determine if the file is prefixed with BMU info
		if (data.length >= 8) {
			boolean prefix = false;
			if (data[0] == (byte)'B'
					&& data[1] == (byte)'M'
					&& data[2] == (byte)'U'
					&& data[3] == (byte)' ') {
				prefix = true;
			}

			File file = null;
			//try {
			file = File.createTempFile("cc_", ".wav");
			file.deleteOnExit();

			FileOutputStream fos = new FileOutputStream(file);
			if (prefix)
				fos.write(data, 8, data.length - 8);
			else
				fos.write(data);

			fos.close();
			//} catch (Exception e) {}
			Fmod.loadLibraries();
			
			Fmod.FSOUND_SetDriver(0);
			Fmod.FSOUND_Init(44100, 32, 0);
			Fmod.FSOUND_Stream_SetBufferSize(1000);
			FSOUND_STREAM stream = Fmod.FSOUND_Stream_Open(
					file.toString(), FSOUND_MODES.FSOUND_NORMAL, 0, 0);
			Fmod.FSOUND_Stream_PlayEx(FSOUND_MISC_VALUES.FSOUND_FREE,
					stream, null, false);
		}
	}
}
