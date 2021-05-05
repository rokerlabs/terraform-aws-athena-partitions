package main

import (
	"testing"

	"github.com/aws/aws-lambda-go/events"
)

func TestLambdaHandler(t *testing.T) {
	t.Run("Successful event", func(t *testing.T) {
		s := server{}

		err := s.handler(events.CloudWatchEvent{})
		if err != nil {
			t.Fatal("Lambda handler failed", err)
		}
	})
}
