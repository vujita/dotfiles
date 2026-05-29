package vudo

import (
	"fmt"
	"path/filepath"
	"strings"
)

func (c *CLI) repoRoot() (string, error) {
	out, err := c.runner().Output(command{Name: "git", Args: []string{"rev-parse", "--show-toplevel"}})
	if err != nil {
		return "", fmt.Errorf("find git repo root: %w", err)
	}
	return strings.TrimSpace(string(out)), nil
}

func worktreeDir(repoRoot string) string {
	return filepath.Join(repoRoot, ".worktree")
}

func worktreePath(repoRoot, name string) string {
	return filepath.Join(worktreeDir(repoRoot), sanitizeWorktreeName(name))
}

func sanitizeWorktreeName(name string) string {
	replacer := strings.NewReplacer("/", "-", "\\", "-", " ", "-")
	return replacer.Replace(strings.TrimSpace(name))
}

func hasFlag(args []string, flag string) bool {
	for _, arg := range args {
		if arg == flag {
			return true
		}
	}
	return false
}

func argValue(args []string, flag, fallback string) string {
	for i, arg := range args {
		if arg == flag && i+1 < len(args) {
			return args[i+1]
		}
	}
	return fallback
}

func positional(args []string) []string {
	var out []string
	for i := 0; i < len(args); i++ {
		if strings.HasPrefix(args[i], "--") {
			if i+1 < len(args) && !strings.HasPrefix(args[i+1], "--") {
				i++
			}
			continue
		}
		out = append(out, args[i])
	}
	return out
}
