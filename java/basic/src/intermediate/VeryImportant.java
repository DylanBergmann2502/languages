package intermediate;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.TYPE, ElementType.METHOD}) 
// use @Target when u wanna use this annotation for a specific field 
// .TYPE = class, .METHOD = method
@Retention(RetentionPolicy.RUNTIME) //.RUNTIME = keep this annotation around when running code
public @interface VeryImportant {

}
