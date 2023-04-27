package intermediate;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class Annotations_tutorial {

	public static void main(String[] args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException { // annotations dont change your code, just specify some extra info for the compiler
		
		@SuppressWarnings("unused")
		Cat myCat = new Cat("Dylan"); 
		
//		if (myCat.getClass().isAnnotationPresent(VeryImportant.class)) {
//			System.out.println("This thing is very important");
//		} else {
//			System.out.println("This thing is not very important :( ");
//		}
		
		for (Method method : myCat.getClass().getDeclaredMethods()) {
			if (method.isAnnotationPresent(RunImmediately.class)) {
				// retrieve the annotation from the  class
				RunImmediately annotation = method.getAnnotation(RunImmediately.class); 
				
				for (int i = 0; i<annotation.times();i++){
					method.invoke(myCat); // invoke = call that method
				}
	
			}
		}
		
		for (Field field : myCat.getClass().getDeclaredFields()) {
			if (field.isAnnotationPresent(RunImmediately.class)) {
				Object objectValue = field.get(myCat);
				
				if (objectValue instanceof String stringValue) {
					System.out.println(stringValue.toUpperCase());
				}
			}
		
		}
	}

}
