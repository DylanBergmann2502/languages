package main

// go.uber.org/zap — high-performance structured logging.
//
// Why zap over slog?
//   - Significantly faster (zero-allocation hot path with zap.Logger)
//   - Two APIs: Logger (typed fields, fastest) and SugaredLogger (printf-style, convenient)
//   - Rich built-in presets and encoder options
//   - Still the dominant choice in high-throughput Go services
//
// Two logger types:
//   zap.Logger        — explicit typed fields: zap.String("k","v"), zap.Int("n",1)
//   zap.SugaredLogger — printf style: Sugar().Infow("msg", "k", "v") or Infof("fmt", args...)
//
// dep: go.uber.org/zap

import (
	"errors"
	"time"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func main() {
	basicUsage()
	sugaredLogger()
	customLogger()
	logLevels()
	structuredFields()
	childLoggers()
	errorLogging()
	sampledLogger()
}

// -----------------------------------------------------------------------
// 1. Basic usage — preset loggers
// -----------------------------------------------------------------------

func basicUsage() {
	// zap.NewExample — JSON output, debug level, no timestamps (good for tests/docs)
	logger := zap.NewExample()
	defer logger.Sync()

	logger.Info("hello from zap",
		zap.String("library", "zap"),
		zap.Int("version", 2),
	)
	logger.Warn("this is a warning", zap.Bool("recoverable", true))

	// zap.NewDevelopment — human-readable, colorized, debug level, caller info
	dev, _ := zap.NewDevelopment()
	defer dev.Sync()
	dev.Info("development logger", zap.String("env", "local"))

	// zap.NewProduction — JSON, info level, timestamps, caller, stacktrace on error+
	prod, _ := zap.NewProduction()
	defer prod.Sync()
	prod.Info("production logger", zap.String("env", "prod"))
}

// -----------------------------------------------------------------------
// 2. SugaredLogger — more convenient, slightly slower
// -----------------------------------------------------------------------

func sugaredLogger() {
	logger := zap.NewExample().Sugar()
	defer logger.Sync()

	// Infow — structured key-value pairs (like slog)
	logger.Infow("user logged in",
		"user_id", 42,
		"ip", "192.168.1.1",
		"method", "oauth",
	)

	// Infof — printf style
	logger.Infof("processed %d items in %s", 100, "2s")

	// Info — simple message (like fmt.Println)
	logger.Info("simple message")

	// Desugar — convert back to Logger when you need max performance in a hot path
	_ = logger.Desugar()
}

// -----------------------------------------------------------------------
// 3. Custom logger — full encoder control
// -----------------------------------------------------------------------

func customLogger() {
	cfg := zap.Config{
		Level:       zap.NewAtomicLevelAt(zapcore.DebugLevel),
		Development: false,
		Encoding:    "json", // "json" or "console"
		EncoderConfig: zapcore.EncoderConfig{
			TimeKey:        "ts",
			LevelKey:       "level",
			NameKey:        "logger",
			CallerKey:      "caller",
			MessageKey:     "msg",
			StacktraceKey:  "stacktrace",
			LineEnding:     zapcore.DefaultLineEnding,
			EncodeLevel:    zapcore.LowercaseLevelEncoder,
			EncodeTime:     zapcore.ISO8601TimeEncoder,
			EncodeDuration: zapcore.StringDurationEncoder,
			EncodeCaller:   zapcore.ShortCallerEncoder,
		},
		OutputPaths:      []string{"stdout"},
		ErrorOutputPaths: []string{"stderr"},
	}

	logger, _ := cfg.Build()
	defer logger.Sync()

	logger.Info("custom encoder config",
		zap.String("format", "iso8601 timestamps"),
	)
}

// -----------------------------------------------------------------------
// 4. Log levels
// -----------------------------------------------------------------------

func logLevels() {
	logger := zap.NewExample()
	defer logger.Sync()

	logger.Debug("debug — verbose detail, disabled in production")
	logger.Info("info — normal operational events")
	logger.Warn("warn — unexpected but recoverable")
	logger.Error("error — failed operation, execution continues",
		zap.Error(errors.New("db timeout")),
	)
	// logger.Fatal — logs then calls os.Exit(1)
	// logger.Panic — logs then panics
	// Both exist but use sparingly — prefer returning errors up the call stack

	// Dynamic level — change at runtime without restart
	atom := zap.NewAtomicLevel()
	atom.SetLevel(zapcore.WarnLevel)

	cfg := zap.NewProductionConfig()
	cfg.Level = atom
	logger2, _ := cfg.Build()
	defer logger2.Sync()

	logger2.Debug("this won't print — below warn level")
	logger2.Warn("this will print")

	atom.SetLevel(zapcore.DebugLevel) // lower the level at runtime
	logger2.Debug("now debug prints again")
}

// -----------------------------------------------------------------------
// 5. Strongly typed fields — the zap.Logger advantage
// -----------------------------------------------------------------------

func structuredFields() {
	logger := zap.NewExample()
	defer logger.Sync()

	// Each field type has its own constructor — zero allocation, no reflection
	logger.Info("typed fields",
		zap.String("name", "Alice"),
		zap.Int("age", 30),
		zap.Float64("score", 98.6),
		zap.Bool("active", true),
		zap.Duration("elapsed", 42*time.Millisecond),
		zap.Time("at", time.Now()),
		zap.Strings("tags", []string{"go", "logging"}),
		zap.Any("meta", map[string]int{"requests": 100}), // escape hatch
	)

	// zap.Object — log a struct without reflection, implement zapcore.ObjectMarshaler
	logger.Info("request",
		zap.Object("user", zapcore.ObjectMarshalerFunc(func(enc zapcore.ObjectEncoder) error {
			enc.AddString("id", "u-42")
			enc.AddString("role", "admin")
			return nil
		})),
	)
}

// -----------------------------------------------------------------------
// 6. Child loggers — inherit fields, add context
// -----------------------------------------------------------------------

func childLoggers() {
	logger := zap.NewExample()
	defer logger.Sync()

	// With — creates a child that always includes these fields
	requestLogger := logger.With(
		zap.String("request_id", "req-abc123"),
		zap.String("user_id", "u-42"),
	)

	// All messages from requestLogger carry request_id and user_id automatically
	requestLogger.Info("handler started")
	requestLogger.Info("db query executed", zap.Int("rows", 5))
	requestLogger.Info("handler completed", zap.Duration("latency", 12*time.Millisecond))

	// Named — adds a "logger" field for component identification
	dbLogger := logger.Named("database")
	dbLogger.Info("connection established", zap.String("host", "localhost"))

	cacheLogger := logger.Named("cache")
	cacheLogger.Info("cache miss", zap.String("key", "user:42"))
}

// -----------------------------------------------------------------------
// 7. Error logging
// -----------------------------------------------------------------------

func errorLogging() {
	logger := zap.NewExample()
	defer logger.Sync()

	err := errors.New("connection refused")

	// zap.Error — the right way to log errors
	logger.Error("failed to connect", zap.Error(err))

	// zap.NamedError — when you have multiple errors in one log line
	err2 := errors.New("timeout")
	logger.Error("multiple issues",
		zap.NamedError("primary", err),
		zap.NamedError("secondary", err2),
	)

	// DPanic — panics in development, logs error in production
	// Useful for catching programmer errors in dev without crashing prod
	devLogger, _ := zap.NewDevelopment(zap.WithCaller(false))
	defer devLogger.Sync()
	// devLogger.DPanic("this would panic in dev mode")
	_ = devLogger
}

// -----------------------------------------------------------------------
// 8. Sampled logger — rate-limit noisy log lines
// -----------------------------------------------------------------------

func sampledLogger() {
	base := zap.NewExample()
	defer base.Sync()

	// First 3 identical messages per second pass through, then 1-in-10
	logger := zap.New(
		zapcore.NewSamplerWithOptions(
			base.Core(),
			time.Second, // tick
			3,           // first N per tick
			10,          // thereafter 1-in-N
		),
	)
	defer logger.Sync()

	// Simulates a hot loop where the same message fires 20 times
	for range 20 {
		logger.Info("frequent event", zap.String("type", "cache_miss"))
	}
	// Only ~3 lines print — sampler drops the rest
}
