package ext;
////////////
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.util.Random;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

public privileged aspect AddStrategy {
	/* New play button */
	private JButton newPlayButton = new JButton("Play");
	private Strategy AIStrategy ;




	after(BattleshipDialog dialog) returning(JPanel content): target(dialog) && execution(JPanel makeControlPane()){
		/*Gets the returning value of the method makeControlPane
		Then adds the newPlayButton to the pane */

		JButton practice = dialog.playButton;
		practice.setText("Practice");
		JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
		buttons.add(practice); 
		buttons.add(this.newPlayButton);
		content.add(buttons, BorderLayout.NORTH);

		/* action to the button play */
		newPlayButton.addActionListener(this::shipsStatus);

		/* adds the oponent board and ship status */
		JPanel playView = new JPanel(new BorderLayout());
		Board opBoard = new Board(10);
		//AIStrategy = new SmartStrategy(opBoard.places());
		placeShips(opBoard);
		BoardPanel opponentBoard = new BoardPanel(opBoard, 0, 0, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY);

		JPanel opponent = new JPanel( new GridLayout(1, 3));
		JComboBox drop = createDropDown();
		drop.setPreferredSize(new Dimension(80,80));
		
		opponent.setBorder(BorderFactory.createEmptyBorder(0,5,0,0));
		JPanel shipsStatus = shipNamePanel(dialog.board.ships());
		opponent.add(shipsStatus);
		opponent.add(drop);
		opponent.add(opponentBoard);
		

		/*opponent boar to the north and user board at center */
		playView.add(opponent, BorderLayout.NORTH);
		opponentBoard.setPreferredSize(new Dimension(110,110));
		content.add(playView, BorderLayout.CENTER);
		//AIStrategy = setDifficulty((String)drop.getSelectedItem(),dialog.board.places());
	}
	/* to do
	before(): this(BoardPanel) && execution(void Place.hit()){
		AIStrategy.move();

	}
	 */

	private void shipsStatus(ActionEvent event){

	}
	/*
	 * Add strategy dropdown menu
	 */
	private JComboBox createDropDown(){
		String[] difficulties = new String[] {"Smart", "Random","Sweep"};

		JComboBox<String> options = new JComboBox<>(difficulties);
		return options;
	}
	/*
	 * Create strategy
	 */
	private Strategy setDifficulty(String difficulty,Iterable<Place> places){
		if(difficulty.equals("Sweep")){
			AIStrategy = new SmartStrategy(places);
		}
		else if(difficulty.equals("Random")){
			AIStrategy = new SmartStrategy(places);
		}
		else{
			AIStrategy = new SmartStrategy(places);
		}
		return AIStrategy;
	}

	/*
	 * Add JPanel with ship name and size
	 */
	private JPanel shipNamePanel(Iterable<Ship> ships){
		JPanel shipsStatus = new JPanel(new GridLayout(6,2));
		shipsStatus.setBorder(BorderFactory.createEmptyBorder(0,0,5,0)); 
		for(Ship boardShip : ships){
			shipsStatus.add(new JLabel(boardShip.name() + ":  "));
			shipsStatus.add(new JLabel(Integer.toString(boardShip.size())));
		}
		return shipsStatus;
	}

	private void placeShips(Board board) {
		Random random = new Random();
		int size = board.size();
		for (Ship ship : board.ships()) {
			int i = 0;
			int j = 0;
			boolean dir = false;
			do {
				i = random.nextInt(size) + 1;
				j = random.nextInt(size) + 1;
				dir = random.nextBoolean();
			} while (!board.placeShip(ship, i, j, dir));
		}
	}
}
