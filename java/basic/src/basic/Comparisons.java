package basic;
import java.util.Scanner;

public class Comparisons {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int x1 = 6;
		int y1 = 23;
		int z1 = 10;
		// for numbers: >, <, ==, >=, <=, !=
		
		String x2 = "hello";
		String y2 = "Hello"; // capital letters matter
		// for texts: ==, !=. If use ==, the result wont be returned as expected
		
		boolean compare1 = x1 < y1;
		boolean compare2 = x2 != y2;
		
		// to compare 2 equal texts
		Scanner sc = new Scanner(System.in);
		String s = sc.nextLine();
		s.equals("hello");
		
		// && : and, ||: or
		boolean compare3 = x1 > y1 && z1 < y1;  // if 1 of them is false => false
		boolean compare4 = !(x1 > y1 || z1 < y1); // if 1 of them is true => true
		boolean compare5 = (x1 < y1 && y1 > z1)||(z1 + 2 < 5 || x1 + 7 > y1);
		System.out.println(compare5);
	}

}
