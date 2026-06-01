package vudo

import (
	"bytes"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

func TestHelp(t *testing.T) {
	var stdout bytes.Buffer
	cli := &CLI{Stdout: &stdout, Stderr: &bytes.Buffer{}}

	if code := cli.Run([]string{"help"}); code != 0 {
		t.Fatalf("expected exit code 0, got %d", code)
	}
	if !strings.Contains(stdout.String(), "Usage:") {
		t.Fatalf("expected help output, got %q", stdout.String())
	}
}

func TestVersion(t *testing.T) {
	var stdout bytes.Buffer
	cli := &CLI{Stdout: &stdout, Stderr: &bytes.Buffer{}}

	if code := cli.Run([]string{"version"}); code != 0 {
		t.Fatalf("expected exit code 0, got %d", code)
	}
	if got := strings.TrimSpace(stdout.String()); got != "vudo "+Version {
		t.Fatalf("expected version output, got %q", got)
	}
}

func TestPathPrefersDotfilesDir(t *testing.T) {
	var stdout bytes.Buffer
	cli := &CLI{
		Stdout: &stdout,
		Stderr: &bytes.Buffer{},
		Env:    []string{"DOTFILES_DIR=/tmp/dotfiles", "HOME=/home/example"},
	}

	if code := cli.Run([]string{"path"}); code != 0 {
		t.Fatalf("expected exit code 0, got %d", code)
	}
	if got := strings.TrimSpace(stdout.String()); got != "/tmp/dotfiles" {
		t.Fatalf("expected DOTFILES_DIR path, got %q", got)
	}
}

func TestInteractivePlaceholder(t *testing.T) {
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cli := &CLI{Stdout: &stdout, Stderr: &stderr}

	if code := cli.Run([]string{"interactive"}); code != 1 {
		t.Fatalf("expected exit code 1, got %d", code)
	}
	if !strings.Contains(stderr.String(), "interactive mode is not implemented yet") {
		t.Fatalf("expected interactive placeholder error, got %q", stderr.String())
	}
}

func TestBranchNewDoesNotOpenByDefault(t *testing.T) {
	repoDir := "/tmp/example-repo"
	var stdout bytes.Buffer
	runner := &recordingRunner{
		outputs: map[string][]byte{
			"git rev-parse --show-toplevel": []byte(repoDir + "\n"),
		},
	}
	cli := &CLI{
		Stdout: &stdout,
		Stderr: &bytes.Buffer{},
		Env:    []string{"EDITOR=nvim"},
		Runner: runner,
	}

	if code := cli.Run([]string{"branch", "new", "feature/foo"}); code != 0 {
		t.Fatalf("expected exit code 0, got %d", code)
	}

	want := []string{
		"git fetch origin",
		"git worktree add -b feature/foo " + filepath.Join(repoDir, ".worktree", "feature-foo") + " origin/main",
	}
	if !reflect.DeepEqual(runner.commands, want) {
		t.Fatalf("expected commands %v, got %v", want, runner.commands)
	}
	if !strings.Contains(stdout.String(), filepath.Join(repoDir, ".worktree", "feature-foo")) {
		t.Fatalf("expected worktree path in stdout, got %q", stdout.String())
	}
}

func TestBranchNewOpenRunsEditor(t *testing.T) {
	repoDir := "/tmp/example-repo"
	runner := &recordingRunner{
		outputs: map[string][]byte{
			"git rev-parse --show-toplevel": []byte(repoDir + "\n"),
		},
	}
	cli := &CLI{
		Stdout: &bytes.Buffer{},
		Stderr: &bytes.Buffer{},
		Env:    []string{"EDITOR=code"},
		Runner: runner,
	}

	if code := cli.Run([]string{"branch", "new", "feature/foo", "--open"}); code != 0 {
		t.Fatalf("expected exit code 0, got %d", code)
	}

	path := filepath.Join(repoDir, ".worktree", "feature-foo")
	want := []string{
		"git fetch origin",
		"git worktree add -b feature/foo " + path + " origin/main",
		"code " + path,
	}
	if !reflect.DeepEqual(runner.commands, want) {
		t.Fatalf("expected commands %v, got %v", want, runner.commands)
	}
}

func TestUnknownCommand(t *testing.T) {
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cli := &CLI{Stdout: &stdout, Stderr: &stderr}

	if code := cli.Run([]string{"wat"}); code != 1 {
		t.Fatalf("expected exit code 1, got %d", code)
	}
	if !strings.Contains(stderr.String(), "unknown command: wat") {
		t.Fatalf("expected unknown command error, got %q", stderr.String())
	}
}

type recordingRunner struct {
	commands []string
	outputs  map[string][]byte
}

func (r *recordingRunner) Run(cmd command) error {
	r.commands = append(r.commands, cmd.String())
	return nil
}

func (r *recordingRunner) Output(cmd command) ([]byte, error) {
	if r.outputs == nil {
		return nil, nil
	}
	return r.outputs[cmd.String()], nil
}
