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

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

public privileged aspect AddStrategy {

	private JButton BattleshipDialog.newPlayButton = new JButton("Play"); //new play button
	private Strategy AIStrategy ;//AI strategy
	public JPanel opponent;// opponent options panel
	public Board opBoard;//board for opponent play


	/////buttons for selection
	public JRadioButton smart;
	public JRadioButton sweep;
	public JRadioButton random;
	
	public JPanel BattleshipDialog.addNewPlay(){
		JButton practice = playButton; // old play button becomes practice button
		practice.setText("Practice");
		JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
		buttons.add(practice); 
		buttons.add(newPlayButton);
		/* action to the button play */
		newPlayButton.addActionListener(this::playButtonClicked);
		return buttons;
	}

	/* 
	 * Generates the opponent board and starts a new game
	 */
	after(BattleshipDialog dialog) returning(JPanel content): target(dialog) && execution(JPanel makeControlPane()){
		JPanel buttons = dialog.addNewPlay();
		content.add(buttons, BorderLayout.NORTH);
		/* adds the oponent board and ship status */
		JPanel playView = new JPanel(new BorderLayout());
		opBoard = new Board(10);
		placeShips(opBoard);
		BoardPanel opponentBoard = new BoardPanel(opBoard, 0, 0, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY);
		opponent = new JPanel( new GridLayout(1, 3)); 
		JPanel drop = createDropDown(); // dropdown for strategy selection

		opponent.setBorder(BorderFactory.createEmptyBorder(0,5,0,0));
		JPanel shipsStatus = shipNamePanel(dialog.board.ships()); // create ship status indicator
		opponent.add(shipsStatus);
		opponent.add(drop);
		opponent.add(opponentBoard);
		/*opponent board to the north and user board at center */
		playView.add(opponent, BorderLayout.NORTH);
		opponentBoard.setPreferredSize(new Dimension(110,110));
		content.add(playView, BorderLayout.CENTER);
	}
	/*
	 * Generate AI shot after user shoots
	 */
	after(): this(BoardPanel) && call(void Place.hit()){
		AIStrategy.move();
		opponent.repaint();
	}
	after(): execution(void BattleshipDialog.playButtonClicked(*)){
		opBoard.reset();
		placeShips(opBoard);
	}

	

	
	/*
	 * Add strategy radio button menu
	 * smart is selected by default
	 */
	private JPanel createDropDown(){

		JPanel strategies = new JPanel();
		smart =new JRadioButton("Smart");
		smart.setActionCommand("smart");
		smart.setSelected(true);
		AIStrategy = new SmartStrategy(opBoard.places());
		sweep =new JRadioButton("Sweep");
		sweep.setActionCommand("sweep");
		random =new JRadioButton("Random");
		random.setActionCommand("random");
		smart.addActionListener(this::buttonListener);
		sweep.addActionListener(this::buttonListener);
		random.addActionListener(this::buttonListener);
		strategies.add(smart);
		strategies.add(sweep);
		strategies.add(random);

		return strategies;
	}
	/*
	 * Button listener actions
	 * strategy is equals to whatever option is selected
	 */
	private void buttonListener(ActionEvent e){
		String selected = e.getActionCommand();
		System.out.print(e.getActionCommand());
		if(selected.equals("smart")){
			smart.setSelected(true);
			sweep.setSelected(false);
			random.setSelected(false);
			AIStrategy = new SmartStrategy(opBoard.places());
		}
		else if(selected.equals("sweep")){
			smart.setSelected(false);
			sweep.setSelected(true);
			random.setSelected(false);
			AIStrategy = new SweepStrategy(opBoard.places());
		}
		else if(selected.equals("random")){
			smart.setSelected(false);
			sweep.setSelected(false);
			random.setSelected(true);
			AIStrategy = new RandomStrategy(opBoard.places());
		}
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
