package main

import (
	"errors"
	"fmt"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/athena"
	"github.com/aws/aws-sdk-go/service/athena/athenaiface"
)

type mockedStartQueryExecution struct {
	athenaiface.AthenaAPI
	Response athena.StartQueryExecutionOutput
}

func (a mockedStartQueryExecution) StartQueryExecution(input *athena.StartQueryExecutionInput) (*athena.StartQueryExecutionOutput, error) {
	year, month, day := time.Now().Date()

	if *input.QueryString == fmt.Sprintf("ALTER TABLE logs ADD PARTITION (year=\"%d\", month=\"%d\", day=\"%d\") LOCATION \"s3://logs%d/%d/%d/\"", year, int(month), day, year, int(month), day) {
		return &a.Response, errors.New("Failed")
	}

	return &a.Response, nil
}

func TestQueryString(t *testing.T) {
	t.Run("Correct query string", func(t *testing.T) {
		query := queryString(partitionEvent{
			Database:            "test",
			Table:               "alb_logs",
			Location:            "s3://logs-012345678900/AWSLogs/012345678900/elasticloadbalancing/us-east-1/",
			QueryResultLocation: "s3://aws-athena-query-results-012345678900-us-east-1/",
		})

		year, month, day := time.Now().Date()

		if *query != fmt.Sprintf("ALTER TABLE alb_logs ADD PARTITION (year=\"%d\", month=\"%d\", day=\"%d\") LOCATION \"s3://logs-012345678900/AWSLogs/012345678900/elasticloadbalancing/us-east-1/%d/%d/%d/\"", year, int(month), day, year, int(month), day) {
			t.Fatal("Incorrect query string", *query)
		}
	})
}

func TestLambdaHandler(t *testing.T) {
	t.Run("Successful event", func(t *testing.T) {
		m := mockedStartQueryExecution{
			Response: athena.StartQueryExecutionOutput{
				QueryExecutionId: aws.String("abc-123"),
			},
		}

		s := server{
			Athena: m,
		}

		err := s.handler(partitionEvent{})
		if err != nil {
			t.Fatal("Lambda handler failed", err)
		}
	})

	t.Run("Failed query execution", func(t *testing.T) {
		m := mockedStartQueryExecution{
			Response: athena.StartQueryExecutionOutput{
				QueryExecutionId: aws.String("abc-123"),
			},
		}

		s := server{
			Athena: m,
		}

		err := s.handler(partitionEvent{
			Database:            "test",
			Table:               "logs",
			Location:            "s3://logs",
			QueryResultLocation: "s3://results",
		})
		if err == nil {
			t.Fatal("Lambda handler should have failed", err)
		}
	})
}
