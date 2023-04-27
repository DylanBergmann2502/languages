package conditions;

public class Switch_Statements { // = if, but helps compare 1 value to many others very easily

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println(getDateName(0));
	}
	
	public static String getDateName(int dayNum) {
		String dayName = "";
		
//		if (dayNum == 0) {
//			dayName == "Monday";
//		} else if (dayNum == 1) {
//			dayName = "Tuesday";
//		} etc.
		
		switch(dayNum) {
			case 0: dayName = "Sunday";
				break; // if already yielded the required results => break out of the loop 
			case 1: dayName = "Monday";
				break;
			case 2: dayName = "Tuesday";
				break;
			case 3: dayName = "Wednesday";
				break;
			case 4: dayName = "Thursday";
				break;
			case 5: dayName = "Friday";
				break;
			case 6: dayName = "Saturday";
				break;
			default: dayName = "Invalid Day Number"; // default = if none of the cases above		
		}
		return dayName;
	}

}
