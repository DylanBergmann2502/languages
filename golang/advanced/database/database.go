package main

// database/sql is stdlib; it needs a driver registered at runtime.
// To run this file, add a driver to go.mod:
//   go get modernc.org/sqlite
// Then change the blank import below to:
//   _ "modernc.org/sqlite"
// And use "sqlite" as the driver name instead of "sqlite3".
//
// Or use mattn/go-sqlite3 (requires CGO):
//   go get github.com/mattn/go-sqlite3
//   import _ "github.com/mattn/go-sqlite3"
//   db, err := sql.Open("sqlite3", ":memory:")

import (
	"database/sql"
	"fmt"
	"log"

	_ "modernc.org/sqlite" // registers the "sqlite" driver
)

type User struct {
	ID    int
	Name  string
	Email string
}

func main() {
	// Open an in-memory SQLite database
	db, err := sql.Open("sqlite", ":memory:")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Verify the connection
	if err := db.Ping(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("connected")

	// --- DDL: create table ---
	_, err = db.Exec(`CREATE TABLE users (
		id    INTEGER PRIMARY KEY AUTOINCREMENT,
		name  TEXT NOT NULL,
		email TEXT NOT NULL UNIQUE
	)`)
	if err != nil {
		log.Fatal(err)
	}

	// --- INSERT with prepared statement (prevents SQL injection) ---
	stmt, err := db.Prepare("INSERT INTO users (name, email) VALUES (?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt.Close()

	res, err := stmt.Exec("Alice", "alice@example.com")
	if err != nil {
		log.Fatal(err)
	}
	id, _ := res.LastInsertId()
	rows, _ := res.RowsAffected()
	fmt.Printf("inserted id=%d rows=%d\n", id, rows) // inserted id=1 rows=1

	stmt.Exec("Bob", "bob@example.com")
	stmt.Exec("Charlie", "charlie@example.com")

	// --- SELECT multiple rows ---
	rws, err := db.Query("SELECT id, name, email FROM users ORDER BY id")
	if err != nil {
		log.Fatal(err)
	}
	defer rws.Close()

	for rws.Next() {
		var u User
		if err := rws.Scan(&u.ID, &u.Name, &u.Email); err != nil {
			log.Fatal(err)
		}
		fmt.Printf("%+v\n", u)
	}
	// {ID:1 Name:Alice Email:alice@example.com}
	// {ID:2 Name:Bob Email:bob@example.com}
	// {ID:3 Name:Charlie Email:charlie@example.com}

	if err := rws.Err(); err != nil { // always check after iterating
		log.Fatal(err)
	}

	// --- SELECT single row ---
	var u User
	err = db.QueryRow("SELECT id, name, email FROM users WHERE id = ?", 1).
		Scan(&u.ID, &u.Name, &u.Email)
	if err == sql.ErrNoRows {
		fmt.Println("not found")
	} else if err != nil {
		log.Fatal(err)
	}
	fmt.Println("found:", u.Name) // found: Alice

	// --- UPDATE ---
	result, err := db.Exec("UPDATE users SET name = ? WHERE id = ?", "Alicia", 1)
	if err != nil {
		log.Fatal(err)
	}
	affected, _ := result.RowsAffected()
	fmt.Println("updated rows:", affected) // updated rows: 1

	// --- DELETE ---
	db.Exec("DELETE FROM users WHERE id = ?", 3)

	// --- Transactions ---
	tx, err := db.Begin()
	if err != nil {
		log.Fatal(err)
	}

	_, err = tx.Exec("INSERT INTO users (name, email) VALUES (?, ?)", "Diana", "diana@example.com")
	if err != nil {
		tx.Rollback()
		log.Fatal(err)
	}
	_, err = tx.Exec("INSERT INTO users (name, email) VALUES (?, ?)", "Eve", "eve@example.com")
	if err != nil {
		tx.Rollback()
		log.Fatal(err)
	}

	if err := tx.Commit(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("transaction committed")

	// --- Connection pool settings ---
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)
	// db.SetConnMaxLifetime(5 * time.Minute)

	// Final state
	rws2, _ := db.Query("SELECT id, name FROM users ORDER BY id")
	defer rws2.Close()
	for rws2.Next() {
		var id int
		var name string
		rws2.Scan(&id, &name)
		fmt.Printf("  %d: %s\n", id, name)
	}
}
