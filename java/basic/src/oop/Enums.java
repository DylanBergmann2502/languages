package oop;

public class Enums {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Level lvl = Level.LOW;
		
//		Level[] arr = Level.values();
//		
//		if (lvl == Level.LOW) {
//			System.out.println(lvl);
//		}
//		else if (lvl == Level.MEDIUM) {
//			System.out.println(lvl);
//		}
//		else {
//			System.out.println(lvl);
//		}
//		
//		for (Level e: arr) {
//			System.out.println(e);
//		}
		System.out.println(lvl.getLvl());
		lvl.setLvl(2);
		System.out.println(lvl.getLvl());
	}

}
