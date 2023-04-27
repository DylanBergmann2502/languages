package basic;

import java.util.HashMap;
import java.util.Map;

public class Homework2 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Map m = new HashMap();
		String str = "hello my name is dylan and i am not cool";
		int count = 0;
		
		for (char x:str.toCharArray()) {
			if (m.containsKey(x)){
				int old = (int) m.get(x);
				m.put(x,  old+1);
			}
			else {
				m.put(x,1);
			}
		}
		System.out.println(m);
	}

}
