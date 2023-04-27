package oop;

public class Outer_N_Inner_Classes {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		OuterClass out = new OuterClass();
		
		out.inner1(); // run this to create the private inner class
		
		OuterClass.InnerClass2 in2 = out.new InnerClass2(); // create the public inner class
		in2.display();
		
		out.inner3();
	}

}
