package ext;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.Stack;

import battleship.model.*;

abstract class Strategy {

	public HashMap<Integer,Place> allMoves;
	public List<Integer> allKeys;

	/*
	 * Create hashmap with all possible board moves
	 */
	public void setAllMoves(Iterable<Place> places){
		allMoves = new HashMap<Integer,Place>();
		int boardIndex = 1;
		for(Place place : places){
			allMoves.put(boardIndex, place);
			boardIndex++;
		}
	}
	public void setAllKeys(){
		allKeys = new ArrayList<Integer>();
		for(int i =1; i<=100;i++){
			allKeys.add(i);
		}
	}
	/* 
	 * Generates computer opponent move
	 * To be overriden in strategy classes.
	 */
	void move(){

	}


	/*
	 * Instantiate strategy to be used
	 * 
	 */
	public Strategy(Iterable<Place> places){
		setAllMoves(places);
		setAllKeys();

	}


	////////////////////////////////////////////////////////////////////////// 


	

	

	
}





