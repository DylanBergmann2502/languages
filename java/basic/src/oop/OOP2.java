package oop;

public class OOP2 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Dog_Static tim = new Dog_Static("tim", 9);
		Dog_Static bob = new Dog_Static("bob", 9);
		System.out.println(Dog_Static.count);
		
		Dog_Static.count = 7;
		System.out.println(Dog_Static.count);
	}

}
