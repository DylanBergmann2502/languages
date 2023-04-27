package intermediate;

@FunctionalInterface // no need to specify annotation but it's best practice, SAM interface
public interface Printable { 
	// a method without implementations inside interface = abstract method
	// interface has exactly 1 abstract method = functional interface 
	
	// void print();
	// void print(String suffix);
	String print(String suffix);
}
