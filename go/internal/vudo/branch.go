package vudo

import (
	"fmt"
	"os"
)

func (c *CLI) branch(args []string) int {
	if len(args) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo branch <new|open> ...")
		return 1
	}

	switch args[0] {
	case "new":
		return c.branchNew(args[1:])
	case "open":
		return c.branchOpen(args[1:])
	default:
		fmt.Fprintf(c.Stderr, "unknown branch command: %s\n", args[0])
		return 1
	}
}

func (c *CLI) branchNew(args []string) int {
	pos := positional(args)
	if len(pos) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo branch new <branch> [--base main] [--open]")
		return 1
	}

	branch := pos[0]
	base := argValue(args, "--base", "origin/main")
	open := hasFlag(args, "--open")

	repoRoot, err := c.repoRoot()
	if err != nil {
		fmt.Fprintln(c.Stderr, err)
		return 1
	}

	path := worktreePath(repoRoot, branch)
	if err := os.MkdirAll(worktreeDir(repoRoot), 0755); err != nil {
		fmt.Fprintf(c.Stderr, "create .worktree: %v\n", err)
		return 1
	}

	commands := []command{
		{Dir: repoRoot, Name: "git", Args: []string{"fetch", "origin"}},
		{Dir: repoRoot, Name: "git", Args: []string{"worktree", "add", "-b", branch, path, base}},
	}
	if open {
		commands = append(commands, c.openCommand(path))
	}

	for _, cmd := range commands {
		fmt.Fprintf(c.Stdout, "running: %s\n", cmd.String())
		if err := c.runner().Run(cmd); err != nil {
			fmt.Fprintf(c.Stderr, "%s failed: %v\n", cmd.String(), err)
			return 1
		}
	}

	if !open {
		fmt.Fprintln(c.Stdout, path)
	}
	return 0
}

func (c *CLI) branchOpen(args []string) int {
	pos := positional(args)
	if len(pos) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo branch open <branch>")
		return 1
	}

	repoRoot, err := c.repoRoot()
	if err != nil {
		fmt.Fprintln(c.Stderr, err)
		return 1
	}

	cmd := c.openCommand(worktreePath(repoRoot, pos[0]))
	fmt.Fprintf(c.Stdout, "running: %s\n", cmd.String())
	if err := c.runner().Run(cmd); err != nil {
		fmt.Fprintf(c.Stderr, "%s failed: %v\n", cmd.String(), err)
		return 1
	}
	return 0
}

func (c *CLI) openCommand(path string) command {
	editor := envValue(c.Env, "EDITOR")
	if editor == "" {
		editor = "nvim"
	}
	return command{Name: editor, Args: []string{path}}
}
