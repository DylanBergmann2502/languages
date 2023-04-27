package conditions;
import java.util.Scanner;

public class Conditions {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		String s = sc.nextLine();
		
		if (s.equals("dylan")) {
			System.out.println("Hello dylan");
		}
		else if (s.equals("hello")) { // the first one is executed
			System.out.println("Hi!");
		}
		else if (s.equals("hello")) {
			System.out.println("Hi2!");
		}
		else {
			System.out.println("Print");
		}
		
		
	}

}
