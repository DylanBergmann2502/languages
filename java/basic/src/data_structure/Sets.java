package data_structure;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.TreeSet;

public class Sets {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		// HashSet contains UNORDERED and unique values, HashSet is the standard SET
		// Set<Integer> t = new HashSet<Integer>(); 
		
		// TreeSet contains ORDERED and unique values
		// Set<Integer> t = new TreeSet<Integer>();
		
		// LinkedHashSet = HashSet, only certain operations are much faster
		Set<Integer> t = new LinkedHashSet<Integer>();
		
		t.add(5);
		t.add(7);
		t.add(5);
		t.add(9);
		t.add(-8); // result = [5, 7, -8, 9]
		
		boolean x = t.contains(5); 
		
		t.remove(9);
		t.remove(0); // nothing happens if value(s) doesn't exist
		
		// t.clear();
		boolean y = t.isEmpty(); 
		int z = t.size();
		
		// t[0]; // This action cannot be done on SETS because unlike arrays they're UNORDERED
		
		System.out.println(t);
	}

}
