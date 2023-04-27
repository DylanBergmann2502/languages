package oop;

public interface Vehicle { // unique to Java, similar to class but cannot create instances
	// can only be inherited from (or implemented into other classes)
	// inside interfaces, there can only be PUBLIC methods
	
	final int gears = 5; // interface attributes(variables) have to be final => constant, cannot change
	
	void changeGear(int a); // interface methods are abstract
	void speedUp(int a);
	void slowDown(int a);
	
	default void out() {
		System.out.println("Default method");

	}
	
	static int math(int b) {
		return b+9;
	}
}
