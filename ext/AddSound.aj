package ext;

import java.io.File;
import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import battleship.model.*;

public aspect AddSound {
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "src\\sounds\\";
    
    //play audio when ship is hit
	after(): execution(void notifyHit(Place, int)){
		playAudio("gun.wav");
	}
	//play audio when ship is sunk
	after(): execution(void notifyShipSunk(Ship)){
		playAudio("sunk.wav");
	}
	/*
	 * Play the audio file
	 */
    public static void playAudio(String filename) {
      try {
    	  File sound = new File(SOUND_DIR + filename);
          AudioInputStream audioIn = AudioSystem.getAudioInputStream(sound);
          Clip clip = AudioSystem.getClip();
          clip.open(audioIn);
          clip.start();
      } catch (UnsupportedAudioFileException 
            | IOException | LineUnavailableException e) {
          e.printStackTrace();
      }
    }
	

    
}
