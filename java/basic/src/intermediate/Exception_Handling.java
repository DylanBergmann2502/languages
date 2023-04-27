package intermediate;

public class Exception_Handling {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			int myInt = Integer.parseInt("pants");
			System.out.println("After parsing pants"); 
			// since the exception is caught above, system never reaches this line
			return; // even there's a return statement, finally wont stop running
		}
		catch (Exception e) {
			System.out.println("You cannot make an int out of that!!!");
		}
//		catch (NumberFormatException | NullPointerException e) { // catch multiple exceptions
//			System.out.println("You cannot make an int out of that!!!");
//		}
		finally { // execute whether the exception is caught or not
			System.out.println("Finally block");
			// avoid using return in finally block bc it will override everything else in try and catch
		}
	}

}
