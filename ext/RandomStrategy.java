package ext;

import battleship.model.Place;

public class RandomStrategy extends Strategy{
	public RandomStrategy(Iterable<Place> places){
		super(places);
	}
	@Override
	void move(){
		Place shot;
		int shotIndex;
		int random = (int)(Math.random()*allKeys.size());
		shotIndex = allKeys.get(random);
		shot = allMoves.get(shotIndex);
		allKeys.remove((Integer)shotIndex);
		allMoves.remove(shotIndex);
		shot.hit();



	}
}