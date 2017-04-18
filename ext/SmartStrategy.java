package ext;

import java.util.Stack;

import battleship.model.Place;

public class SmartStrategy extends Strategy  {
	Stack<Integer> nextAIShots;
	boolean shipHit = false;

	public SmartStrategy(Iterable<Place> places){
		super(places);
		setAllMoves(places);
		setAllKeys();
		nextAIShots = new Stack<Integer>();//stack for next shots when AI hits a ship
	}

	/*
	 * Add to stack the cells that are next to current cell if it was a hit
	 */

	void addNextShots( int current ,Place place ){
		//variables for next cells
		int right = current+10; 
		int left = current-10;
		int top = current-1;
		int bottom = current+1;
		//if current place is in board and next cells are still possible to be hit, add to stack
		if(place.getY() <10 && allMoves.containsKey(bottom)){
			nextAIShots.push(bottom);
		}
		if(place.getY()>1 && allMoves.containsKey(top)){
			nextAIShots.push(top);
		}
		if(place.getX() <10 && allMoves.containsKey(right)){
			nextAIShots.push(right);
		}
		if(place.getX() > 1 && allMoves.containsKey(left)){
			nextAIShots.push(left);
		}

	}
	/*
	 * Generate random shots from all possible moves
	 * if a ship is hit , add next possible cells to stack
	 * 
	 */
	@Override
	void move(){
		Place shot;
		int shotIndex;
		if(nextAIShots.isEmpty()){ // stack with next shots is empty
			int random = (int)(Math.random()*allKeys.size()); //generate random number using the size of the keys list
			shotIndex = allKeys.get(random); // get the key at the random number location
			shot = allMoves.get(shotIndex); //get the place at the shot key location
			//remove keys from both keys list and moves hashmap
			allKeys.remove((Integer)shotIndex); 
			allMoves.remove(shotIndex);
		}
		else{ //stack is not empty
			shotIndex = nextAIShots.pop();//get the key for the next shot from the stack
			shot = allMoves.get(shotIndex);
			allMoves.remove(shotIndex);
			allKeys.remove((Integer)shotIndex);
		}
		shot.hit();
		if(shot.isHitShip()){//shot hit a ship
			addNextShots(shotIndex,shot);
		}


	}
}