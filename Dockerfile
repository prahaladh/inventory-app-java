# Stage 1: Build the JAR
FROM maven:3.9.6-eclipse-temurin-25 AS build
WORKDIR /app
# Copy the pom and source code
COPY pom.xml .
COPY src ./src
# Build the JAR
RUN mvn clean package -DskipTests

# Stage 2: Final Image
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app
# Copy the JAR from the 'build' stage
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]