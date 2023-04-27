package intermediate;

public class MultithreadThing extends Thread implements Runnable {
// public class MultithreadThing implements Runnable {	//the rest of the code can stay the same
// Runnable is better bc Java does not support multiple inheritance but does support multiple implementation
	private int threadNumber;
	
	public MultithreadThing (int threadNumber) {
		this.threadNumber = threadNumber;
	}
	
	@Override
	public void run() { // overriding the run method of Thread 
		for (int i =1; i<=5; i++) {
			System.out.println(i + "from thread " + threadNumber);
			if (threadNumber == 3) {
				throw new RuntimeException();
			}
			try {Thread.sleep(1000);} catch (InterruptedException e) {e.printStackTrace();}
		}
	}
}
