package oop;

import java.util.Scanner;

public class OOP_Introduction {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		// sc.next();
		String h = "hello";
		h.length();
		
		tim("Timmm", 5); // inside called statement () = argument 
		System.out.println(add2(6));
		System.out.println(str("Tim"));
	}
	
	public static void tim(String str, int x) { // inside () = parameter, void = not return anything, just do sth
		for (int i=0; i<x; i++) {
			System.out.println(str);
		}
	}
	
	public static int add2(int x) {
		return x + 2;
	}
	
	public static String str(String x) {
		return x + "!";
	}

}
