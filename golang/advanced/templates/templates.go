package main

import (
	ht "html/template"
	"os"
	"strings"
	tt "text/template"
)

func textTemplates() {
	// Basic substitution
	t1 := tt.Must(tt.New("t1").Parse("Value: {{.}}\n"))
	t1.Execute(os.Stdout, "some text") // Value: some text

	// Struct fields
	t2 := tt.Must(tt.New("t2").Parse("Name: {{.Name}}, Age: {{.Age}}\n"))
	type Person struct {
		Name string
		Age  int
	}
	t2.Execute(os.Stdout, Person{"Alice", 30}) // Name: Alice, Age: 30

	// Conditionals
	t3 := tt.Must(tt.New("t3").Parse(
		"{{if .Active}}active{{else}}inactive{{end}}\n",
	))
	t3.Execute(os.Stdout, struct{ Active bool }{true})  // active
	t3.Execute(os.Stdout, struct{ Active bool }{false}) // inactive

	// Range over slice
	t4 := tt.Must(tt.New("t4").Parse(
		"{{range .Items}}- {{.}}\n{{end}}",
	))
	t4.Execute(os.Stdout, struct{ Items []string }{[]string{"a", "b", "c"}})
	// - a
	// - b
	// - c

	// Custom functions via FuncMap
	funcMap := tt.FuncMap{
		"upper": strings.ToUpper,
		"join":  strings.Join,
	}
	t5 := tt.Must(tt.New("t5").Funcs(funcMap).Parse(
		"{{.Name | upper}}\n{{join .Tags \", \"}}\n",
	))
	t5.Execute(os.Stdout, struct {
		Name string
		Tags []string
	}{"alice", []string{"go", "backend", "cloud"}})
	// ALICE
	// go, backend, cloud

	// Named templates: define + template
	const tmplStr = `{{define "header"}}=== {{.Title}} ===
{{end}}{{define "page"}}{{template "header" .}}{{.Body}}
{{end}}`
	t6 := tt.Must(tt.New("").Parse(tmplStr))
	type Page struct{ Title, Body string }
	t6.ExecuteTemplate(os.Stdout, "page", Page{"Hello", "World content here"})
	// === Hello ===
	// World content here
}

func htmlTemplates() {
	// html/template auto-escapes to prevent XSS
	t := ht.Must(ht.New("safe").Parse(`<p>{{.}}</p>` + "\n"))
	t.Execute(os.Stdout, "<script>alert('xss')</script>")
	// <p>&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;</p>

	// Explicit safe HTML via ht.HTML bypasses escaping
	t2 := ht.Must(ht.New("safe2").Parse(`<div>{{.}}</div>` + "\n"))
	t2.Execute(os.Stdout, ht.HTML("<strong>bold</strong>"))
	// <div><strong>bold</strong></div>
}

func main() {
	textTemplates()
	htmlTemplates()
}
