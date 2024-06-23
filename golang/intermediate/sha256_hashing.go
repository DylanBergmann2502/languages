package main

import (
	"crypto/sha256"
	"fmt"
)

func main() {
	s := "sha256 this string"

	h := sha256.New()

	h.Write([]byte(s))

	bs := h.Sum(nil)

	fmt.Println(s)         // sha256 this string
	fmt.Printf("%x\n", bs) // 1af1dfa857bf1d8814fe1af8983c18080019922e557f15a8ae213f7a6313f69e
}
