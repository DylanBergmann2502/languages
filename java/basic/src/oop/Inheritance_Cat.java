package oop;

public class Inheritance_Cat extends Dog { // extends to inherit from the Dog class
	
	protected String food; 
	// protected: only child classes or classes in the same package can have access to this 
	// public: everywhere is allowed
	// private: available only within the same class, use this when doing calculations from within the class
	
	public Inheritance_Cat(String name, int age, String food) { // calling constructor method
		super(name, age); // calling the attributes from the parent class
		this.food = food;
	}
	
	public Inheritance_Cat(String name) { // class can have many constructor methods
		super(name, 0);  // set age and food to a default value
		this.food = "fish";
	}	
	
	public void self_introduce() { // overriding parent's method
		System.out.println("Meow, my name is " + this.name +  " and I get fed with " + this.food); 
	} // this.age cannot be accessed cuz this attribute in the parent's class is private
	
}
