package vudo

import "fmt"

func (c *CLI) sync(args []string) int {
	repoRoot, err := c.repoRoot()
	if err != nil {
		fmt.Fprintln(c.Stderr, err)
		return 1
	}

	if hasFlag(args, "--av") {
		avArgs := []string{"sync", "--push=yes", "--prune=yes", "--rebase-to-trunk"}
		if hasFlag(args, "--all") {
			avArgs = append(avArgs, "--all")
		}
		return c.runCommands([]command{{Dir: repoRoot, Name: "av", Args: avArgs}})
	}

	return c.runCommands([]command{
		{Dir: repoRoot, Name: "git", Args: []string{"fetch", "--all", "--prune"}},
		{Dir: repoRoot, Name: "git", Args: []string{"pull", "--rebase"}},
	})
}

func (c *CLI) runCommands(commands []command) int {
	for _, cmd := range commands {
		fmt.Fprintf(c.Stdout, "running: %s\n", cmd.String())
		if err := c.runner().Run(cmd); err != nil {
			fmt.Fprintf(c.Stderr, "%s failed: %v\n", cmd.String(), err)
			return 1
		}
	}
	return 0
}
