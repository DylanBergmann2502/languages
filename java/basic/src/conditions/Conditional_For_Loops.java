package conditions;

public class Conditional_For_Loops {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int x = 2;
		// x += 1;
		for (int i=0; i<=10; i++) { // i+=5, i+=x
			System.out.println(i);
		}
		
		int[] arr = {1,5,6,4,3,6};
		for (int i=0; i < arr.length; i++) {
			if (arr[i]==5) {
				System.out.println("Found a 5! at index " + i);
			}
		}
		
	}
		

}
