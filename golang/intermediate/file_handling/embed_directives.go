package main

import (
	"embed"
	"fmt"
)

//go:embed folder/single_file.txt
var fileString string

//go:embed folder/single_file.txt
var fileByte []byte

//go:embed folder/single_file.txt
//go:embed folder/*.hash
var folder embed.FS

func main() {

	// $ mkdir -p folder
	// $ echo "hello go" > folder/single_file.txt
	// $ echo "123" > folder/file1.hash
	// $ echo "456" > folder/file2.hash

	print(fileString)       // hello go
	print(string(fileByte)) // hello go

	content1, _ := folder.ReadFile("folder/file1.hash")
	fmt.Print(string(content1)) // 123

	content2, _ := folder.ReadFile("folder/file2.hash")
	fmt.Print(string(content2)) // 456
}
