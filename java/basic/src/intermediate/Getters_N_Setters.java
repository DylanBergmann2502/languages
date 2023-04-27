package intermediate;

public class Getters_N_Setters {

	public static void main(String[] args) { // getters and setters force user to make things in a specific way 
		// TODO Auto-generated method stub
		Movie movie1 = new Movie("The Avengers", "Joss Whedon", "PG-13");
		Movie movie2 = new Movie("Step Brothers", "Adam McKay", "R");
		
		// movie1.rating = "Dog"; // should be invalid
		movie1.rating = "PG"; // G, PG, PG-13, R, NR
		
		System.out.println(movie1.rating);
	}

}
