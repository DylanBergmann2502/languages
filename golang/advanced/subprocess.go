package main

import (
	"context"
	"fmt"
	"io"
	"os/exec"
	"time"
)

func main() {
	// --- Basic command output ---
	dateCmd := exec.Command("date")
	dateOut, err := dateCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println("> date")
	fmt.Println(string(dateOut))

	// --- Error handling: distinguish exec vs exit errors ---
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

	// --- Stdin pipe: feed input to a command ---
	grepCmd := exec.Command("grep", "hello")
	grepIn, _ := grepCmd.StdinPipe()
	grepOut, _ := grepCmd.StdoutPipe()
	grepCmd.Start()
	grepIn.Write([]byte("hello grep\ngoodbye grep"))
	grepIn.Close()
	grepBytes, _ := io.ReadAll(grepOut)
	grepCmd.Wait()
	fmt.Println("> grep hello")
	fmt.Println(string(grepBytes)) // hello grep

	// --- Shell command via bash -c ---
	lsCmd := exec.Command("bash", "-c", "ls -a -l -h")
	lsOut, err := lsCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println("> ls -a -l -h")
	fmt.Println(string(lsOut))

	// --- CommandContext: cancel or timeout a subprocess ---
	// This is the production pattern — prevents runaway processes.

	// Timeout: kill the process if it doesn't finish in time
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	out, err := exec.CommandContext(ctx, "sleep", "1").Output()
	if err != nil {
		fmt.Println("sleep timed out or failed:", err)
	} else {
		fmt.Println("sleep finished normally, output:", string(out))
	}

	// Demonstrate timeout triggering: 100ms timeout on a 2s sleep
	ctx2, cancel2 := context.WithTimeout(context.Background(), 100*time.Millisecond)
	defer cancel2()

	_, err = exec.CommandContext(ctx2, "sleep", "2").Output()
	if err != nil {
		fmt.Println("expected timeout:", err) // signal: killed
	}

	// Manual cancel: useful when another goroutine signals abort
	ctx3, cancel3 := context.WithCancel(context.Background())
	go func() {
		time.Sleep(50 * time.Millisecond)
		cancel3() // cancel from another goroutine
	}()
	_, err = exec.CommandContext(ctx3, "sleep", "5").Output()
	fmt.Println("cancelled by goroutine:", err) // signal: killed
}
