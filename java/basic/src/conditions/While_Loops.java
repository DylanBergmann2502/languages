package conditions;
import java.util.Scanner;

public class While_Loops {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
//		System.out.print("Type a number: ");
//		int x = sc.nextInt();
		
//		int count = 0;
//		while(x != 10) {
//			System.out.println("Type 10...");
//			System.out.print("Type a number: ");
//			x = sc.nextInt();
//			count++;
//		}
//		System.out.println("You tried " + count + " times.");
		
		int y;
		do { // this is do while loop
			System.out.print("Type a number: ");
			y = sc.nextInt();
		} while (y!= 10);
		
		int z = 0;
		while(z<=10) {
			z+=1;
		}
	}

}
