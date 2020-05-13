FROM golang:1.10.0
RUN go get github.com/codegangsta/negroni \
           github.com/gorilla/mux \
           github.com/xyproto/simpleredis
WORKDIR /app
ADD ./main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

FROM scratch
WORKDIR /app
COPY --from=0 /app/main .
COPY ./website/index.html public/index.html
COPY ./website/script.js public/script.js
COPY ./website/style.css public/style.css
CMD ["/app/main"]
EXPOSE 3000