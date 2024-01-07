package main

import "fmt"

type Student struct {
	name   string
	grades []int
	age    int
}

func (s Student) getAge() int {
	return s.age
}

func (s *Student) setAge(age int) int {
	s.age = age
	return s.age
}

func (s Student) getAverageGrade() float32 {
	var sum int
	for _, v := range s.grades {
		sum += v
	}
	return float32(sum) / float32(len(s.grades))
}

func main() {
	s1 := Student{"Tim", []int{70, 90, 80, 85}, 19}
	fmt.Println(s1.getAge())

	s1.setAge(20)
	fmt.Println(s1.getAge())

	fmt.Println(s1.getAverageGrade())
}
