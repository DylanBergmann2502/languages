package intermediate;

public class Multithreading {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		MultithreadThing myThing = new MultithreadThing(); //without arguments
//		MultithreadThing myThing2 = new MultithreadThing();
	
//		Multithreading myThing4 = new Multithreading(i);
//		Thread myThread = new Thread(myThing4);// change to this if implements Runnable
//		myThread.start();
//		myThread.join(); 
		// if u want a thread to wait for others to complete => join(), 
		// but that defeats the purpose of multi-threading :)
//		mythread.IsAlive(); // shows if a thread is still running 
		
//		myThing.run(); //run both in 1 thread
//		myThing2.run();
//		
//		myThing.start(); // run both in different threads
//		myThing2.start();
		
		for (int i=1; i <=5; i++) { 
			// when breaking into multiple threads, they run dependently from one another => no telling which is run first
			// if one of the thread caught an error, the others still keep running
			MultithreadThing myThing3 = new MultithreadThing(i);
			myThing3.start();
		}
		
		
	}

}
