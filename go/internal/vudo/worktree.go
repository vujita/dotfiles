package vudo

import "fmt"

func (c *CLI) worktree(args []string) int {
	if len(args) == 0 {
		fmt.Fprintln(c.Stderr, "usage: vudo wt <list|clean|prune>")
		return 1
	}

	switch args[0] {
	case "list":
		return c.runInRepo("git", []string{"worktree", "list"})
	case "prune":
		return c.runInRepo("git", []string{"worktree", "prune"})
	case "clean":
		return c.worktreeClean(args[1:])
	default:
		fmt.Fprintf(c.Stderr, "unknown worktree command: %s\n", args[0])
		return 1
	}
}

func (c *CLI) worktreeClean(args []string) int {
	if !hasFlag(args, "--apply") {
		fmt.Fprintln(c.Stdout, "dry run: use `vudo wt clean --apply` to prune stale git worktree metadata")
		return c.runInRepo("git", []string{"worktree", "prune", "--dry-run"})
	}
	return c.runInRepo("git", []string{"worktree", "prune"})
}
