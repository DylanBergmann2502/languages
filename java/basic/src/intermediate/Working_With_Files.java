package intermediate;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class Working_With_Files {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String[] names = {"John", "Carl", "Gemma"};
		
		BufferedWriter writer = new BufferedWriter(new FileWriter("output.txt"));
		// BufferedWriter writer = new BufferedWriter(new FileWriter("C:\\Users\\locdu\\Downloads\\java\\basic\\src\\intermediate\\output.txt"));
		writer.write("Writing to a file.");
		writer.write("\nHere another line.");
		for (String name:names) {
			writer.write("\n" + name);
		}
		writer.close();
		
		
		BufferedReader reader = new BufferedReader(new FileReader("output.txt"));
		String line;
		System.out.println(reader.readLine()); //read one line
		while ((line = reader.readLine()) != null) { // read multiple lines
			System.out.println(line);
		}
		reader.close();
		
	}

}
