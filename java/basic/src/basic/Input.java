package basic;
import java.util.Scanner;

public class Input {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		String scanned1 = sc.next();
		int scanned2 = sc.nextInt();
		double scanned3 = sc.nextDouble();
		boolean scanned4 = sc.nextBoolean(); 
		
		int x = Integer.parseInt(scanned1); //convert string -> integer
		
		System.out.println(x);
		
		// to input anything but nextLine, you have to clean up the input buffer using sc.nextLine() an extra time
	}

}
