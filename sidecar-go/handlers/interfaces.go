package handlers

import (
	"context"

	"github.com/sibukixxx/load-inspector/sidecar-go/models"
	"github.com/sibukixxx/load-inspector/sidecar-go/storage"
)

// Storage defines the operations handlers need from a metrics store.
// Defined here (consumer side) per the "accept interfaces" Go convention.
type Storage interface {
	AddEvent(event models.Event)
	AddEvents(events []models.Event)
	BufferSize() int
	Flush() (int, error)
	GetDBFile() string
	GetStats() (*storage.MetricsStats, error)
}

// Uploader defines the operations handlers need for remote file upload.
type Uploader interface {
	IsConfigured() bool
	UploadFile(ctx context.Context, key, filePath string) error
}
