package greeting

/*
import (
	"errors"
	errs "github.com/pkg/errors"
)
*/

// Hello is a public function (callable from other packages).
func Hello(name string) string {
	return "Hello " + name
}

// hello is a private function (not callable from other packages).
func hello(name string) string {
	return "Hello " + name
}
