package vudo

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const Version = "0.1.0"

type CLI struct {
	Stdout io.Writer
	Stderr io.Writer
	Env    []string
	Runner Runner
}

func New(stdout, stderr io.Writer) *CLI {
	return &CLI{
		Stdout: stdout,
		Stderr: stderr,
		Env:    os.Environ(),
		Runner: ExecRunner{},
	}
}

func (c *CLI) Run(args []string) int {
	if len(args) == 0 {
		c.printHelp()
		return 0
	}

	switch args[0] {
	case "help", "-h", "--help":
		c.printHelp()
		return 0
	case "version", "-v", "--version":
		fmt.Fprintf(c.Stdout, "vudo %s\n", Version)
		return 0
	case "branch":
		return c.branch(args[1:])
	case "doctor":
		return c.doctor()
	case "interactive", "-i":
		fmt.Fprintln(c.Stderr, "interactive mode is not implemented yet")
		return 1
	case "path":
		fmt.Fprintln(c.Stdout, c.dotfilesDir())
		return 0
	case "pr":
		return c.pr(args[1:])
	case "sync":
		return c.sync(args[1:])
	case "wt", "worktree":
		return c.worktree(args[1:])
	default:
		fmt.Fprintf(c.Stderr, "unknown command: %s\n\n", args[0])
		c.printHelp()
		return 1
	}
}

func (c *CLI) printHelp() {
	fmt.Fprint(c.Stdout, `vudo is Vu's personal utility CLI.

Usage:
  vudo <command>

Commands:
  branch      Create or open branch worktrees under .worktree
  doctor      Check expected local development tools
  interactive Start interactive mode
  path        Print the dotfiles directory
  pr          Wrap gh PR workflows
  sync        Sync the current repo with git or av
  wt          List and clean git worktrees
  version     Print the CLI version
  help        Show this help

Aliases:
  -i          Start interactive mode
`)
}

func (c *CLI) doctor() int {
	checks := []struct {
		name string
		ok   bool
	}{
		{name: "dotfiles dir", ok: dirExists(c.dotfilesDir())},
		{name: "git", ok: commandExists("git")},
		{name: "nvim", ok: commandExists("nvim")},
		{name: "tmux", ok: commandExists("tmux")},
		{name: "fzf", ok: commandExists("fzf")},
	}

	exitCode := 0
	for _, check := range checks {
		status := "ok"
		if !check.ok {
			status = "missing"
			exitCode = 1
		}
		fmt.Fprintf(c.Stdout, "%-14s %s\n", check.name, status)
	}

	return exitCode
}

func (c *CLI) dotfilesDir() string {
	if value := envValue(c.Env, "DOTFILES_DIR"); value != "" {
		return value
	}
	if value := envValue(c.Env, "HOME"); value != "" {
		return filepath.Join(value, "code", "dotfiles")
	}
	return "."
}

func envValue(env []string, key string) string {
	prefix := key + "="
	for _, entry := range env {
		if strings.HasPrefix(entry, prefix) {
			return strings.TrimPrefix(entry, prefix)
		}
	}
	return ""
}

func dirExists(path string) bool {
	info, err := os.Stat(path)
	return err == nil && info.IsDir()
}

func commandExists(name string) bool {
	_, err := exec.LookPath(name)
	return err == nil
}
