package intermediate;

public class String_Formatting {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String name = "Dylan Bergmann"; // %s
		char initial = 'D'; // %c
		int age = 22; // %d
		double gpa = 3.96; // %f
		boolean amItellingthetruth = true; // %b		

		String fstring = String.format("My name is %s. My initial is %c. I am %d year old.  "
				+ "My GPA is %f which is %b", name, initial, age, gpa, amItellingthetruth);
		
		System.out.println(fstring);
		System.out.printf("My name is %s. My initial is %c. I am %d year old.  "
				+ "My GPA is %f which is %b", name, initial, age, gpa, amItellingthetruth);
		
		System.out.println(name.length());
	
		
	}
}
