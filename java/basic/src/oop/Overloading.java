package oop;

public class Overloading {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Student joe = new Student("Joe");
		Student bill = new Student("Bill");
		
		// System.out.println(joe == bill);
		// if compare between 2 objects => usually return false due to being 2 different SAVED objects
		System.out.println(joe.equals(bill));
		
		System.out.println(joe.compareTo(bill)>0); // 8>0
		
		System.out.println(joe); 
		// w/o string representation, return basic.Student@27f674d => where joe object is saved in the system
		// with string representation, return joe 
		System.out.println(bill.toString()); // calling toString() or not does not matter
		
	}

}
