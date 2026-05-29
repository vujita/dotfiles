package main

import (
	"os"

	"dotfiles/cli/internal/vudo"
)

func main() {
	cli := vudo.New(os.Stdout, os.Stderr)
	os.Exit(cli.Run(os.Args[1:]))
}
