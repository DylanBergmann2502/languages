package main

import (
	"fmt"
	"io"
	"os/exec"
)

func main() {

	dateCmd := exec.Command("date")

	dateOut, err := dateCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println("> date")        // > date
	fmt.Println(string(dateOut)) // Thu 05 May 2022 10:10:12 PM PDT

	_, err = exec.Command("date", "-x").Output()
	if err != nil {
		switch e := err.(type) {
		case *exec.Error:
			fmt.Println("failed executing:", err)
		case *exec.ExitError:
			fmt.Println("command exit rc =", e.ExitCode()) // command exit rc = 1
		default:
			panic(err)
		}
	}

	grepCmd := exec.Command("grep", "hello")

	grepIn, _ := grepCmd.StdinPipe()
	grepOut, _ := grepCmd.StdoutPipe()
	grepCmd.Start()
	grepIn.Write([]byte("hello grep\ngoodbye grep"))
	grepIn.Close()
	grepBytes, _ := io.ReadAll(grepOut)
	grepCmd.Wait()

	fmt.Println("> grep hello")    // > grep hello
	fmt.Println(string(grepBytes)) // hello grep

	lsCmd := exec.Command("bash", "-c", "ls -a -l -h")
	lsOut, err := lsCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println("> ls -a -l -h") // > ls -a -l -h
	fmt.Println(string(lsOut))   // drwxr-xr-x  4 mark 136B Oct 3 16:29 .
	// drwxr-xr-x 91 mark 3.0K Oct 3 12:50 ..
	// -rw-r--r--  1 mark 1.3K Oct 3 16:28 spawning-processes.go
}
