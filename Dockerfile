# Build stage.
FROM golang:1.19-alpine3.16 AS builder

WORKDIR /app

COPY . .

RUN go build -o main ./src/main.go
RUN chmod +x main

RUN apk --update --no-cache add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz
RUN curl -L https://github.com/eficode/wait-for/archive/refs/tags/v2.2.3.tar.gz | tar xvz

# Run stage.
FROM alpine:3.16

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY --from=builder /app/wait-for-2.2.3/wait-for ./wait-for

COPY app.env .
COPY scripts/start.sh .
COPY src/database/migrations ./migrations

EXPOSE 8080

CMD [ "./main" ]
ENTRYPOINT [ "./start.sh" ]
