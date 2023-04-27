package basic;

public class Operators {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int x = 5;
		int y = 7;
		int z = 57;
		int a = 5;
		int b = 10;
		
		int math_operator = (x + y) * z - b / a;
		int u1 = z/y; 
		//dividing using 2 ints => result = int no matter what
		double u2 = z/y;
		
		double z2 = 57;
		double y2 = 7;
		double u3 = z2/y2;
		double u4 = z/y2; // if 1 of the 2 is double -> result = double
		
		double c = Math.pow(x,y); // exponents have to be double
		
		int d = 56%5; // % is modulus/remainder => return the remainder
		
		System.out.println(d);
	}

}
