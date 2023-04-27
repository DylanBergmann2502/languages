package oop;

public class Car implements Vehicle{ // Car must define abstract methods
	
	private int gear = 1;
	private int speed = 0;
	
	public void changeGear(int gear) {
		this.gear = gear;
	}
	
	public void speedUp(int change) {
		this.speed += change;
	}
	
	public void slowDown(int change) {
		this.speed -= change;
	}
	
	public void display() {
		System.out.println("I am a car, going " + this.speed + "km/h and I am gear " + this.gear);
		out();
	}
	
}
