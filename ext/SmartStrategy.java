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



	void addNextShots( Place place){
		int right = place.getX()+1;
		int left = place.getX()-1;
		int top = place.getY()-1;
		int bottom = place.getY()+1;

		if(top >1 && allKeys.contains(top)){
			nextAIShots.push(top);
		}
		if(bottom<10 && allKeys.contains(bottom)){
			nextAIShots.push(bottom);
		}
		if(right <10 && allKeys.contains(right)){
			nextAIShots.push(right);
		}
		if(left > 1 && allKeys.contains(left)){
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
			allKeys.remove((Integer)shotIndex);
			allMoves.remove(shotIndex);
			shot = allMoves.get(shotIndex);

		}
		shot.hit();
		if(shot.isHitShip()){
			addNextShots(shot);
		}


	}
}