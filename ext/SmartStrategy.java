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
		nextAIShots = new Stack<Integer>();
	}



	void addNextShots( int current ,Place place ){
		int right = current+10;
		int left = current-10;
		int top = current-1;
		int bottom = current+1;
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
	@Override
	void move(){
		Place shot;
		int shotIndex;
		if(nextAIShots.isEmpty()){
			int random = (int)(Math.random()*allKeys.size());
			shotIndex = allKeys.get(random);
			shot = allMoves.get(shotIndex);
			allKeys.remove((Integer)shotIndex);
			allMoves.remove(shotIndex);
		}
		else{
			shotIndex = nextAIShots.pop();
			
		
			shot = allMoves.get(shotIndex);
			allMoves.remove(shotIndex);
			allKeys.remove((Integer)shotIndex);

		}
		shot.hit();
		if(shot.isHitShip()){
			addNextShots(shotIndex,shot);
		}


	}
}