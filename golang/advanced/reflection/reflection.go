package main

import (
	"fmt"
	"reflect"
)

type User struct {
	Name  string `json:"name" validate:"required"`
	Age   int    `json:"age"`
	Email string `json:"email" validate:"required"`
}

func (u User) Greet() string {
	return "Hi, I'm " + u.Name
}

func (u *User) SetName(name string) {
	u.Name = name
}

func main() {

	// --- reflect.TypeOf / reflect.ValueOf ---

	x := 42
	fmt.Println(reflect.TypeOf(x))  // int
	fmt.Println(reflect.ValueOf(x)) // 42

	u := User{Name: "Alice", Age: 30, Email: "alice@example.com"}
	t := reflect.TypeOf(u)
	v := reflect.ValueOf(u)

	fmt.Println(t.Name())    // User
	fmt.Println(t.Kind())    // struct
	fmt.Println(t.NumField()) // 3

	// --- Iterate struct fields ---

	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		value := v.Field(i)
		fmt.Printf("Field: %-8s Type: %-8s Value: %v\n", field.Name, field.Type, value)
	}
	// Field: Name     Type: string   Value: Alice
	// Field: Age      Type: int      Value: 30
	// Field: Email    Type: string   Value: alice@example.com

	// --- Struct tags ---

	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		fmt.Printf("%s: json=%q validate=%q\n",
			field.Name,
			field.Tag.Get("json"),
			field.Tag.Get("validate"),
		)
	}
	// Name:  json="name"  validate="required"
	// Age:   json="age"   validate=""
	// Email: json="email" validate="required"

	// --- Iterate methods ---

	ut := reflect.TypeOf(u)
	for i := 0; i < ut.NumMethod(); i++ {
		fmt.Println(ut.Method(i).Name) // Greet
	}

	// --- Modify a value via pointer ---

	up := reflect.ValueOf(&u).Elem()
	up.FieldByName("Name").SetString("Bob")
	fmt.Println(u.Name) // Bob

	// --- Call methods dynamically ---

	method := reflect.ValueOf(u).MethodByName("Greet")
	result := method.Call(nil)
	fmt.Println(result[0]) // Hi, I'm Bob

	// --- reflect.DeepEqual ---

	a := []int{1, 2, 3}
	b := []int{1, 2, 3}
	c := []int{1, 2, 4}
	fmt.Println(reflect.DeepEqual(a, b)) // true
	fmt.Println(reflect.DeepEqual(a, c)) // false

	// --- Type switch (complements reflection) ---

	values := []any{42, "hello", true, 3.14, User{}}
	for _, val := range values {
		switch val.(type) {
		case int:
			fmt.Printf("%v is int\n", val)
		case string:
			fmt.Printf("%v is string\n", val)
		case bool:
			fmt.Printf("%v is bool\n", val)
		default:
			fmt.Printf("%v is %T\n", val, val)
		}
	}

	// --- makeInstance: create a zero value of any type ---

	typ := reflect.TypeOf(User{})
	newVal := reflect.New(typ).Elem()
	newVal.FieldByName("Name").SetString("Zero User")
	fmt.Println(newVal.Interface().(User).Name) // Zero User
}
