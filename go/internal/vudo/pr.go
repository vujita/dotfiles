package vudo

import (
	"fmt"
	"os"
)

func (c *CLI) pr(args []string) int {
	if len(args) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo pr <create|open|view|list|checkout> ...")
		return 1
	}

	switch args[0] {
	case "create":
		return c.runInRepo("gh", append([]string{"pr", "create", "--fill"}, args[1:]...))
	case "open":
		return c.runInRepo("gh", append([]string{"pr", "view", "--web"}, args[1:]...))
	case "view":
		return c.runInRepo("gh", append([]string{"pr", "view"}, args[1:]...))
	case "list":
		return c.runInRepo("gh", append([]string{"pr", "list"}, args[1:]...))
	case "checkout":
		return c.prCheckout(args[1:])
	default:
		fmt.Fprintf(c.Stderr, "unknown pr command: %s\n", args[0])
		return 1
	}
}

func (c *CLI) prCheckout(args []string) int {
	pos := positional(args)
	if len(pos) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo pr checkout <number> [--open]")
		return 1
	}

	repoRoot, err := c.repoRoot()
	if err != nil {
		fmt.Fprintln(c.Stderr, err)
		return 1
	}

	number := pos[0]
	path := worktreePath(repoRoot, "pr-"+number)
	if err := os.MkdirAll(worktreeDir(repoRoot), 0755); err != nil {
		fmt.Fprintf(c.Stderr, "create .worktree: %v\n", err)
		return 1
	}

	commands := []command{
		{Dir: repoRoot, Name: "git", Args: []string{"worktree", "add", "--detach", path, "HEAD"}},
		{Dir: path, Name: "gh", Args: []string{"pr", "checkout", number}},
	}
	if hasFlag(args, "--open") {
		commands = append(commands, c.openCommand(path))
	}

	for _, cmd := range commands {
		fmt.Fprintf(c.Stdout, "running: %s\n", cmd.String())
		if err := c.runner().Run(cmd); err != nil {
			fmt.Fprintf(c.Stderr, "%s failed: %v\n", cmd.String(), err)
			return 1
		}
	}
	return 0
}

func (c *CLI) runInRepo(name string, args []string) int {
	repoRoot, err := c.repoRoot()
	if err != nil {
		fmt.Fprintln(c.Stderr, err)
		return 1
	}

	cmd := command{Dir: repoRoot, Name: name, Args: args}
	fmt.Fprintf(c.Stdout, "running: %s\n", cmd.String())
	if err := c.runner().Run(cmd); err != nil {
		fmt.Fprintf(c.Stderr, "%s failed: %v\n", cmd.String(), err)
		return 1
	}
	return 0
}
