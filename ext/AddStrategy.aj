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

	private JButton newPlayButton = new JButton("Play"); //new play button
	private Strategy AIStrategy ;//AI strategy
	public JPanel opponent;// opponent options panel
	public Board opBoard;//board for opponent play
	private boolean gameMode = false; //true if playing against AI


/* 
 * Generates the opponent board and starts a new game
 */
	after(BattleshipDialog dialog) returning(JPanel content): target(dialog) && execution(JPanel makeControlPane()){
	

		JButton practice = dialog.playButton; // old play button becomes practice button
		practice.setText("Practice");
		JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
		buttons.add(practice); 
		buttons.add(this.newPlayButton);
		content.add(buttons, BorderLayout.NORTH);

		/* action to the button play */
		newPlayButton.addActionListener(this::startGame);

		/* adds the oponent board and ship status */
		JPanel playView = new JPanel(new BorderLayout());
		opBoard = new Board(10);
		placeShips(opBoard);
		BoardPanel opponentBoard = new BoardPanel(opBoard, 0, 0, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY);
		opponent = new JPanel( new GridLayout(1, 3)); 
		JComboBox drop = createDropDown(); // dropdown for strategy selection
		drop.setPreferredSize(new Dimension(80,80));
		opponent.setBorder(BorderFactory.createEmptyBorder(0,5,0,0));
		JPanel shipsStatus = shipNamePanel(dialog.board.ships()); // create ship status indicator
		opponent.add(shipsStatus);
		opponent.add(drop);
		opponent.add(opponentBoard);
		/*opponent board to the north and user board at center */
		playView.add(opponent, BorderLayout.NORTH);
		opponentBoard.setPreferredSize(new Dimension(110,110));
		content.add(playView, BorderLayout.CENTER);
		/* Initialize user strategy */
		AIStrategy = new SmartStrategy(opBoard.places());
		//AIStrategy = setDifficulty((String)drop.getSelectedItem(),opBoard.places());
	}
	/*
	 * Generate AI shot after user shoots
	 */
	after(): this(BoardPanel) && call(void Place.hit()){
		AIStrategy.move();
		opponent.repaint();
	}

	/*
	 * Listener for new play button
	 */
	private void startGame(ActionEvent event){
		gameMode = true;
		System.out.println(gameMode);
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
	 * Create strategy based on user selection from dropdown menu
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
	/*
	 * Deploy user ships for opponent board
	 */
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
