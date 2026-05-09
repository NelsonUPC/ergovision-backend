FROM maven:3.9.9-eclipse-temurin-21-alpine as build

WORKDIR /opt/app/
COPY pom.xml .
RUN mvn dependency:go-offline

COPY ./src ./src
RUN mvn clean install -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /opt/app/

COPY --from=build /opt/app/target/ergovision-0.0.1-SNAPSHOT.jar ergovision.jar

RUN apk add --no-cache curl

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "ergovision.jar"]
