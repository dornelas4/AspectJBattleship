package ext;

import battleship.model.Place;

public class RandomStrategy extends Strategy{
	public RandomStrategy(Iterable<Place> places){
		super(places);
	}
	/*
	 * Generate random numbers as keys
	 * hit random places in board
	 */
	@Override
	void move(){
		Place shot;
		int shotIndex;
		int random = (int)(Math.random()*allKeys.size());//gen random number
		shotIndex = allKeys.get(random);//get key at random index
		shot = allMoves.get(shotIndex);//get place at index key
		allKeys.remove((Integer)shotIndex);
		allMoves.remove(shotIndex);
		shot.hit();



	}
}