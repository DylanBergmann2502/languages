package oop;

public class OOP {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		Dog tim  = new Dog("tim", 4);
//		tim.self_introduce();
//		
//		System.out.println(tim.name);
//		System.out.println(tim.getAge());
//		
//		tim.setAge(8);
//		tim.self_introduce();
		
		// Inheritance
		Inheritance_Cat timmy = new Inheritance_Cat("timmy", 18, "milk"); 
		timmy.self_introduce();
		Inheritance_Cat bob = new Inheritance_Cat("bob");
		bob.self_introduce();

	}

}
