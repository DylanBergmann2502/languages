package main

import (
	"bufio"
	"fmt"
	"net/http"
)

func main() {

	resp, err := http.Get("https://gobyexample.com")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("Response status:", resp.Status) // Response status: 200 OK

	scanner := bufio.NewScanner(resp.Body)
	for i := 0; scanner.Scan() && i < 5; i++ {
		fmt.Println(scanner.Text())
	}

	// <!DOCTYPE html>
	// <html>
	// 	<head>
	// 	 <meta charset="utf-8">
	// 	 <title>Go by Example</title>

	if err := scanner.Err(); err != nil {
		panic(err)
	}
}
