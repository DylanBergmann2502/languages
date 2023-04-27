package data_structure;

import java.util.Arrays;

public class Array {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int[] newArr1 = new int[5]; // creating an empty array
		String[] newArr2 = new String[5]; // array of 5 and only 5, cannot exceed // without values, all values will be set to null
		
		newArr2[0] = "hello"; // add a value to an array 
		newArr2[1] = "hi";
		newArr2[2] = "tim";
		newArr2[3] = "bill";
		// newArr2[4] = "joe";
		
		String x = newArr2[4]; // indexing the array
		// System.out.println(x);
		
		int[] nums = {2,3,43,6,6}; // set an array, array should be in {}
		double[] nums2 = {2.0, 3.0};
		int y = nums[4];		
		System.out.println(y);
		
		// Sorting
		int[] z = {-99, 5, 6, 3, 2, 1, 7, 8, 0};
		Arrays.sort(z, 1, 3); // (array, beginning, end)
		for (int i:z) {
			System.out.print(i + ",");
		}
	}

}
