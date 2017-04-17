package ext;

import battleship.model.Place;

public class SweepStrategy extends Strategy{
	private int index =1;
	public SweepStrategy(Iterable<Place> places){
		super(places);
	}
	@Override
	void move(){
		Place shot = allMoves.get(index);
		shot.hit();
		index++;
	}
}