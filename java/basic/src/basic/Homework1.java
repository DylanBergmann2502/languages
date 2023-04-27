package basic;
import java.util.Scanner;

public class Homework1 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.print("In put your age: ");
		Scanner sc = new Scanner(System.in);
		String s = sc.nextLine();
		int age = Integer.parseInt(s);
		
		if (age >= 18) {
			System.out.print("What is your fav food? ");
			String food = sc.nextLine();
			if (food.equals("Fried Chicken")) {
				System.out.println("Mine too!!! <3");
			}
			else {
				System.out.println("Oh! That is just not my taste");
			}
		}
		else if (age >= 13) {
			System.out.println("You are a teenager!");
		}
		else {
			System.out.println("You are a kid!");
		}
	}

}
