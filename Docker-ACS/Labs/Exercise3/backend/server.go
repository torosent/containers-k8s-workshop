package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
)

func shouldbemain() {

	fmt.Println("Hooking up handlers...")

	http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})

	fmt.Println("Running server...")

	log.Fatal(http.ListenAndServe(":80", nil))
}
