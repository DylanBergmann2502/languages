package main

// github.com/charmbracelet/bubbletea — TUI framework for Go using The Elm Architecture.
//
// Go is the dominant language for CLI/TUI tools (kubectl, gh, lazygit, k9s all use it).
// bubbletea is the modern standard for interactive terminal UIs.
//
// The Elm Architecture (TEA) — three functions:
//   Model  — immutable state struct
//   Update — pure function: (Model, Msg) -> (Model, Cmd)
//   View   — pure function: Model -> string (what to render)
//
// Key types:
//   tea.Model  — interface: Init(), Update(), View()
//   tea.Msg    — any value (keyboard events, timer ticks, HTTP responses, ...)
//   tea.Cmd    — func() tea.Msg — async side effect (returns a message later)
//   tea.Program — runs the event loop
//
// dep: github.com/charmbracelet/bubbletea
//      github.com/charmbracelet/lipgloss  (optional: styling)

import (
	"fmt"
	"os"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
)

// -----------------------------------------------------------------------
// Example 1: Counter — simplest possible TUI
// -----------------------------------------------------------------------

type CounterModel struct {
	count int
}

type incrementMsg struct{}
type decrementMsg struct{}

func (m CounterModel) Init() tea.Cmd {
	return nil // no initial side effects
}

func (m CounterModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "up", "k":
			m.count++
		case "down", "j":
			m.count--
		case "r":
			m.count = 0
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m CounterModel) View() string {
	return fmt.Sprintf(
		"Counter: %d\n\n↑/k: increment  ↓/j: decrement  r: reset  q: quit\n",
		m.count,
	)
}

// -----------------------------------------------------------------------
// Example 2: Timer — uses tea.Cmd for async ticking
// -----------------------------------------------------------------------

type TimerModel struct {
	duration time.Duration
	elapsed  time.Duration
	running  bool
}

type tickMsg time.Time

func tick() tea.Cmd {
	// tea.Cmd is a function that returns a tea.Msg
	// tea.Every/tea.Tick handle repeated ticking
	return tea.Tick(time.Second, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}

func (m TimerModel) Init() tea.Cmd {
	return tick() // start ticking immediately
}

func (m TimerModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tickMsg:
		_ = msg
		if m.running {
			m.elapsed += time.Second
			if m.elapsed >= m.duration {
				m.running = false
				return m, tea.Quit
			}
		}
		return m, tick() // schedule next tick

	case tea.KeyMsg:
		switch msg.String() {
		case " ":
			m.running = !m.running // toggle pause
		case "r":
			m.elapsed = 0
			m.running = true
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m TimerModel) View() string {
	remaining := m.duration - m.elapsed
	bar := progressBar(m.elapsed, m.duration, 30)
	status := "running"
	if !m.running {
		status = "paused"
	}
	return fmt.Sprintf(
		"Timer [%s] %s\n%s\n\nspace: pause/resume  r: restart  q: quit\n",
		status, remaining.Round(time.Second), bar,
	)
}

func progressBar(elapsed, total time.Duration, width int) string {
	if total == 0 {
		return strings.Repeat("░", width)
	}
	filled := int(float64(elapsed) / float64(total) * float64(width))
	if filled > width {
		filled = width
	}
	return "[" + strings.Repeat("█", filled) + strings.Repeat("░", width-filled) + "]"
}

// -----------------------------------------------------------------------
// Example 3: List selector — navigate a list, select an item
// -----------------------------------------------------------------------

type ListModel struct {
	items    []string
	cursor   int
	selected map[int]struct{}
}

func (m ListModel) Init() tea.Cmd { return nil }

func (m ListModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}
		case "down", "j":
			if m.cursor < len(m.items)-1 {
				m.cursor++
			}
		case " ", "enter": // toggle selection
			if _, ok := m.selected[m.cursor]; ok {
				delete(m.selected, m.cursor)
			} else {
				m.selected[m.cursor] = struct{}{}
			}
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m ListModel) View() string {
	var sb strings.Builder
	sb.WriteString("Choose your languages (space to select, q to quit):\n\n")
	for i, item := range m.items {
		cursor := "  "
		if m.cursor == i {
			cursor = "→ "
		}
		checked := "○"
		if _, ok := m.selected[i]; ok {
			checked = "●"
		}
		sb.WriteString(fmt.Sprintf("%s%s %s\n", cursor, checked, item))
	}
	if len(m.selected) > 0 {
		sb.WriteString("\nSelected: ")
		for i := range m.selected {
			sb.WriteString(m.items[i] + " ")
		}
		sb.WriteString("\n")
	}
	return sb.String()
}

// -----------------------------------------------------------------------
// Main — pick which demo to run via CLI arg
// -----------------------------------------------------------------------

func main() {
	demo := "list"
	if len(os.Args) > 1 {
		demo = os.Args[1]
	}

	var p *tea.Program

	switch demo {
	case "counter":
		fmt.Println("Running counter demo (q to quit)...")
		p = tea.NewProgram(CounterModel{})

	case "timer":
		fmt.Println("Running timer demo (q to quit)...")
		p = tea.NewProgram(TimerModel{
			duration: 10 * time.Second,
			running:  true,
		})

	default:
		fmt.Println("Running list demo (q to quit)...")
		p = tea.NewProgram(ListModel{
			items:    []string{"Go", "Elixir", "Rust", "TypeScript", "Python"},
			selected: make(map[int]struct{}),
		})
	}

	if _, err := p.Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

// Usage:
//   go run bubbletea.go          # list selector
//   go run bubbletea.go counter  # counter
//   go run bubbletea.go timer    # countdown timer
