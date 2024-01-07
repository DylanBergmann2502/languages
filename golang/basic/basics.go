// all files in the same directory must share the same package name
// when a package is imported only capitalized entities can be accessed.
package main

import (
	"fmt"
	"reflect"
)

func main() {
	const Age = 21
	fmt.Println(Age)
	fmt.Printf("Age is of type: %s\n", reflect.TypeOf(Age))
}
