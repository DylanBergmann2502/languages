package oop;

public class Dog { // in Java, to create a new class => create a new file
	
	public String name; // private means these attributes are only accessible within this class
	private int age; // if this is public => can access through Dog.age, can't do that if private
	
	public Dog(String name, int age) { // constructor method
		this.name = name;
		this.age = age;
	}
	
	public void self_introduce() { // method
		System.out.println("I am " + this.name + " and I am " + this.age + " years old");
	}
	
	public int getAge() { // this is a getter
		return this.age;
	}
	
	public void setAge(int age) { // this is using a setter
		this.age = age;
	}
	
	private int add2() { //private method can only be called within the class
		return this.age + 2;
	}
}
