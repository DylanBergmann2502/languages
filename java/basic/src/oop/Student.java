package oop;

public class Student implements Comparable<Student>{ // implement interface
	private String name;
	
	public Student(String name) {
		this.name = name;
	}
	
	public boolean equals(Student other) {
		if (this.name == other.name){
			return true;
		}
		else {
			return false;
		}
	}
	
	public int compareTo(Student other) {
		return this.name.compareTo(other.name); // compare the distance of the first letters
	}
	
	public String toString() { // similar to __str__ in python, no need to call it, java understands automatically
		return "Student(" + this.name + ")"; // this is called string representation
	}
}
