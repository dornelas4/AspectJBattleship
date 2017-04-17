package ext;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;

import javax.swing.BorderFactory;
import javax.swing.JButton;
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
	//private JPanel cont;


	
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
		JPanel cont = new JPanel(new BorderLayout());
		BoardPanel oponentBoard = new BoardPanel(new Board(10), 0, 0, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY);
		JPanel oponent = new JPanel( new GridLayout(1, 2));
		oponent.setBorder(BorderFactory.createEmptyBorder(0,5,0,0));
		JPanel shipsStatus = new JPanel(new GridLayout(6,2));
		shipsStatus.setBorder(BorderFactory.createEmptyBorder(0,0,5,0));
		String aircraft ="Aircraft carrier";
		String battleship ="Battleship";
		String frigate ="Frigate";
		String submarine ="Submarine";
		String minesweeper ="Minesweeper";
		/* Adds the ships status*/
		shipsStatus.add(new JLabel(aircraft +":  "));
		shipsStatus.add(new JLabel(counter(aircraft,dialog.board.ships)));
		shipsStatus.add(new JLabel(battleship+ ":  "));
		shipsStatus.add(new JLabel(counter(battleship,dialog.board.ships)));
		shipsStatus.add(new JLabel(frigate + ":  "));
		shipsStatus.add(new JLabel(counter(frigate,dialog.board.ships)));
		shipsStatus.add(new JLabel(submarine + ":  "));
		shipsStatus.add(new JLabel(counter(submarine,dialog.board.ships)));
		shipsStatus.add(new JLabel(minesweeper +":  "));
		shipsStatus.add(new JLabel(counter(minesweeper,dialog.board.ships)));

		oponent.add(shipsStatus);
		oponent.add(oponentBoard);
		
		/*opponent boar to the north and user board at center */
		cont.add(oponent, BorderLayout.NORTH);
		oponentBoard.setPreferredSize(new Dimension(110,110));
		content.add(cont, BorderLayout.CENTER);
	}

	private void shipsStatus(ActionEvent event){
	
	}
	
	private String counter(String ship,Iterable<Ship> ships){
		String size ="";
		for(Ship boardShip : ships){
			if(ship.equals(boardShip.name())){
				int tempSize=  boardShip.size();
				
				size =  Integer.toString(tempSize);
			}
		}
		return size;
	}
