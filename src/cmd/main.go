package main

import (
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type server struct{}

func (s *server) handler(event events.CloudWatchEvent) error {
	stringEvent, _ := json.Marshal(event)
	log.Printf("level=debug %s", string(stringEvent))

	return nil
}

func main() {
	s := server{}
	lambda.Start(s.handler)
}
