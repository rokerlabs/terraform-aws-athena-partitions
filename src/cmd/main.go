package main

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/athena"
	"github.com/aws/aws-sdk-go/service/athena/athenaiface"
)

type partitionEvent struct {
	events.CloudWatchEvent
	Database            string `json:"database"`
	Table               string `json:"table"`
	Location            string `json:"location"`
	QueryResultLocation string `json:"query_result_location"`
}

type server struct {
	Athena athenaiface.AthenaAPI
}

func (s *server) handler(event partitionEvent) error {
	stringEvent, _ := json.Marshal(event)
	log.Printf("level=debug %s", string(stringEvent))

	result, err := s.Athena.StartQueryExecution(&athena.StartQueryExecutionInput{
		QueryExecutionContext: &athena.QueryExecutionContext{
			Database: &event.Database,
		},
		QueryString: queryString(event, time.Now()),
		ResultConfiguration: &athena.ResultConfiguration{
			OutputLocation: &event.QueryResultLocation,
		},
	})

	if err != nil {
		log.Printf("level=error %s", err)
		return err
	}

	log.Printf("level=info query_execution_id=%s", *result.QueryExecutionId)
	return nil
}

func queryString(event partitionEvent, t time.Time) *string {
	partition := t.Format("year=\"2006\", month=\"01\", day=\"02\"")
	partitionLocation := t.Format("2006/01/02/")
	query := fmt.Sprintf("ALTER TABLE %s ADD PARTITION (%s) LOCATION \"%s%s\"", event.Table, partition, event.Location, partitionLocation)
	log.Printf("level=debug %s", query)

	return &query
}

func main() {
	sess := session.Must(session.NewSession())

	s := server{
		Athena: athena.New(sess),
	}

	lambda.Start(s.handler)
}
