package data_structure;

import java.util.ArrayList;
import java.util.LinkedList;

public class Lists {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ArrayList<Integer> t = new ArrayList<Integer>(); // list is slower than set, like arrays but can change size 
		LinkedList<Integer> t1 = new LinkedList<Integer>(); // LinkedList is faster than ArrayList
		
		t.add(1);
		t.add(2);
		t.add(5);
		t.add(9);
		t.add(11);
		
		t.get(0); // indexing list
		t.set(1, 5); // at position 1, set the value of 5 but position 1 has to exist first
		t.subList(1,4); // grabbing a list from index 1 to 4 exluding 4
		
		System.out.println(t.subList(1,4));
	}

}
