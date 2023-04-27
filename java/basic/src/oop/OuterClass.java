package oop;

public class OuterClass {
	private class InnerClass1 { // private => cannot access display() directly
		
		public void display() {
			System.out.println("This is an inner class");
		}
	}
	
	public void inner1() { // create an instance of the private inner class
		InnerClass1 in = new InnerClass1();
		in.display();
	}
	////////////////////////////////////////////
	public class InnerClass2 {
		public void display() {
			System.out.println("This is also an inner class");
		}	
	}
	///////////////////////////////////////////
	public void inner3() {
		class InnerClass3 { // create a class inside a method
			// since you have to call it to get it, there's no need to assign public or private to the class 
			public void display() {
				System.out.println("Jez, another inner class?");
			}
		}
		
		InnerClass3 in = new InnerClass3();
		in.display();
	}
}
