package main

import (
	"fmt"
	"time"
)

func main() {
	p := fmt.Println

	t := time.Now()

	// Formats
	/*
		Year: 				"2006"; "06"
		Month: 				"Jan"; "January"; "01"; "1"
		Weekday: 			"Mon"; "Monday"
		Day of the month: 	"2"; "_2"; "02" (For preceding 0)
		Day of the year: 	"__2"; "002"
		Hour: 				"15" ( 24 hour time format ); "3"; "03" (PM or AM)
		Minute: 			"4"; "04"
		Second: 			"5"; "05"
		AM/PM mark: 		"PM"
	*/

	p(t.Format("3:04PM"))
	p(t.Format("Mon Jan _2 15:04:05 2006"))
	p(t.Format("2006-01-02T15:04:05.999999-07:00"))
	form := "3 04 PM"
	t2, e := time.Parse(form, "8 41 PM")
	p(t2)

	fmt.Printf("%d-%02d-%02dT%02d:%02d:%02d-00:00\n",
		t.Year(), t.Month(), t.Day(),
		t.Hour(), t.Minute(), t.Second())

	ansic := "Mon Jan _2 15:04:05 2006"
	_, e = time.Parse(ansic, "8:41PM")
	p(e)
}
