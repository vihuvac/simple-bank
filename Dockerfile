# Build stage.
FROM golang:1.20-alpine3.17 AS builder

WORKDIR /app

COPY . .

RUN apk --update --no-cache add curl

RUN go mod download && go mod verify

RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

RUN go build -o main ./src/main.go
RUN chmod +x main

# Run stage.
FROM alpine:3.17

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate

COPY app.env .
COPY scripts/start.sh .
COPY src/database/migrations ./migrations

EXPOSE 8080

CMD [ "./main" ]
ENTRYPOINT [ "./start.sh" ]
