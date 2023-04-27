package intermediate;

public class Printer <T>{ // <> type parameter // can extend from classes and interfaces
	T thingToPrint;
	//V otherThing; => specify <T, V> above
	
	public Printer(T thingToPrint) {
		this.thingToPrint = thingToPrint;
	}
	
	public void print() {
		System.out.println(thingToPrint);
	}
}
