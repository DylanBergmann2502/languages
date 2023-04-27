package intermediate;

import java.util.ArrayList;
import java.util.List;

public class Generics {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Printer<Integer> printer = new Printer<>(23); 
		// passing type argument(wrapper classes) after the class to specify what data type we want
		printer.print();
		
//		ArrayList<Cat> cats = new ArrayList<>();
//		cats.add(new Cat());
				
		shout(57, "loud");
		
		List<Integer> intList = new ArrayList<>();
		intList.add(3);
		printList(intList);
		
//		List<Cat> catList = new ArrayList<>();
//		catList.add(new Cat());
//		printList(catList);
	}
	
	private static <T, V> T shout(T thingToShout, V otherThingToShout) { // using generics for methods
		System.out.println(thingToShout + "!!!!!!");
		System.out.println(otherThingToShout + "!!!!!!");
		return thingToShout;
	}
	private static void printList(List<?> myList) { 
// <? extends Animal> wild cards can extends to specify that the created object has to be extend from a specific class/interface
		System.out.println(myList);		
	}
}
