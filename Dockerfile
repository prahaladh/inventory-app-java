# Try using the Oracle container registry for Java 25
FROM container-registry.oracle.com/java/openjdk:25 AS build
WORKDIR /app

# Install Maven
RUN microdnf install maven

COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM container-registry.oracle.com/java/openjdk:25
WORKDIR /app
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]