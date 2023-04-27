package oop;

public class Dog_Static {
	
	protected static int count = 0; // "static" to indicate class variable
	
	protected String name; 
	protected int age; 
	
	public Dog_Static(String name, int age) { 
		this.name = name;
		this.age = age;
		Dog_Static.count += 1; // = this.count also works
		display();
	}
	
	public static void display() { // static method does not deal with class instance
		System.out.println("I am a dog");
	}
}

