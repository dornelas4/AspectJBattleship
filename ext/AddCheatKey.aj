package ext;

import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.Color;
import java.awt.Graphics;
import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

import ext.Strategy;
import ext.SmartStrategy;
import ext.RandomStrategy;
import ext.SweepStrategy;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Place;

privileged aspect AddCheatKey {
	static boolean f5Pressed = false;	//checks if the button was press
	BattleshipDialog test ;
	pointcut cheatKey(BoardPanel x): this(x) && execution(BoardPanel.new(..));
	after(BoardPanel x): cheatKey(x){ 
		ActionMap actionMap = x.getActionMap();
	    int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
	    InputMap inputMap = x.getInputMap(condition);
	    String cheat = "Cheat";
	    inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
	    actionMap.put(cheat, new KeyAction(x, cheat));
	}

	
	pointcut image(BoardPanel board, Graphics g): this(board) && args(g) && execution(void paint(Graphics));
	after(BoardPanel b, Graphics g): image(b,g){
		if(f5Pressed){ 
			showShips(b,g);
		}
	}

	 @SuppressWarnings("serial")
     private static class KeyAction extends AbstractAction {
        private final BoardPanel boardPanel;
        private Strategy st;
        BattleshipDialog dialog ;
        public KeyAction(BoardPanel boardPanel, String command) {
            this.boardPanel = boardPanel;
            putValue(ACTION_COMMAND_KEY, command);
           
            
        }
        
        /** Called when a cheat is requested. */
        public void actionPerformed(ActionEvent event) {
	        f5Pressed = !f5Pressed;
	        boardPanel.repaint();
	        
      
        }   
     }
	 
	 public static void showShips(BoardPanel board, Graphics g){
		 for(Place p: board.board.places()) {
			if (p.hasShip()) {
				int x = board.leftMargin + (p.getX() - 1) * board.placeSize;
    		    int y = board.topMargin + (p.getY() - 1) * board.placeSize;
    		    if(!p.isHit()){
					g.setColor(Color.ORANGE);
	    		    g.fillRect(x + 1, y + 1, board.placeSize - 1, board.placeSize - 1);
    		    }
			}
			
		
				
		 }
	 }
}
