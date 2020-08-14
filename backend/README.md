## A backend to flex your platform muscles with

The backend is an API created using Spring Boot. Its purpose is Listing and Registering clients. 
It has some endpoints to check the health of this api as described below.

Make it run ` ./mvnw spring-boot:run`

Go to http://localhost:8080/ to see the REST API Swagger interface

You get these metrics:

* http://localhost:8080/actuator/health   <- returns 200 + UP or something else

* http://localhost:8080/actuator/metrics <- list all metrics exported, which you can access like: 

* http://localhost:8080/actuator/metrics/system.cpu.usage

How to shutdown the api via request:

curl -X POST http://localhost:8080/actuator/shutdown

You can test the API by running: ` ./mvnw test`
