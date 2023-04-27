package data_structure;

import java.util.LinkedHashMap;
import java.util.Map;

public class Maps {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//Map m = new HashMap(); // HashMap = py dict, map is faster than set, map is UNORDERED
		//Map m = new TreeMap(); // TreeMap is ORDERED, data type for KEYS must be the same
		Map m = new LinkedHashMap(); // like lists, LinkedHashMap maintains order of added items
		
		m.put("tim", 5); //put(key, value), key should be unique, value can overlap
		m.put("joe", "x");
		// m.put(11, 999);
		// m.put(11, 998);
		
		System.out.println(m.get("tim")); // get a key
		// System.out.println(m.get(11));
		System.out.println(m);
		
		m.containsValue("a"); // check if the value exists in map
		m.containsKey(5); // check if the key exists in map
		System.out.println(m.containsKey(5));
		System.out.println(m.get(5));
		
		System.out.println(m.values()); // get all values
		
		m.remove('a'); // remove a key => in ''
		m.clear();
		m.isEmpty();
	}

}
