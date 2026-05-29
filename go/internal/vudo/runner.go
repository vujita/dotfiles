package vudo

import (
	"os"
	"os/exec"
	"strings"
)

type Runner interface {
	Run(command) error
	Output(command) ([]byte, error)
}

type command struct {
	Dir  string
	Name string
	Args []string
}

func (c command) String() string {
	return strings.Join(append([]string{c.Name}, c.Args...), " ")
}

type ExecRunner struct{}

func (c *CLI) runner() Runner {
	if c.Runner == nil {
		return ExecRunner{}
	}
	return c.Runner
}

func (ExecRunner) Run(command command) error {
	cmd := exec.Command(command.Name, command.Args...)
	cmd.Dir = command.Dir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func (ExecRunner) Output(command command) ([]byte, error) {
	cmd := exec.Command(command.Name, command.Args...)
	cmd.Dir = command.Dir
	cmd.Stderr = os.Stderr
	return cmd.Output()
}
