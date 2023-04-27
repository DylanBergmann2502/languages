package conditions;
import java.util.Scanner;

public class For_Each_Loops {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int[] arr = {1,5,7,3,4,5};
		String[] names = new String[5];
		Scanner sc = new Scanner(System.in);
		
		int count = 0;
		for (int element:arr) {
			System.out.println(element + " " + count);
			count++;
		}
		
		for(int i = 0; i<names.length ; i++) { // or i-- = i - 1 
			// variable; condition; code that runs after each alteration
			System.out.print("Input: ");
			String input = sc.nextLine();
			names[i] = input;
		}
		
		// this is for each loop
		for(String n:names) {
			System.out.println(n);
			if (n.equals("tim")) {
				break;
			}
		}
		

	}
}
