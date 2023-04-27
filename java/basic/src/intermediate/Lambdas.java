package intermediate;

public class Lambdas {

	public static void main(String[] args) { 
		// lambda can only be used with a functional interface
		// Lambda = shortcut to define implementation of a functional interface
		
//		printThing( //these are for void print();
//			() -> {
//				System.out.println("Meow");
//			}
//		);
//		printThing(()-> System.out.println("Meow 2"));
		
//		Printable lamdaPrintable = (s)-> System.out.println("Meow 2"); //thse are for void print(String suffix);
//		printThing(lamdaPrintable);
		
		Printable lamdaPrintable = (s)-> {
			System.out.println("Meow 2" + s);
			return "Meow";
		};
		Printable lamdaPrintable2 = (s)-> "Meow 2" + s; 
		
		printThing(lamdaPrintable);
		
		
	}
	
	static void printThing(Printable thing) {
		thing.print("!");
	}	
}
