# Stage 1: Build using JDK 25
# (Note: Using 'openjdk' here as it's often the first to have the latest versions)
FROM openjdk:25-slim AS build
WORKDIR /app

# Install Maven manually if the image doesn't have it, 
# or use a Maven image that supports 25 if available
RUN apt-get update && apt-get install -y maven

COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run using JRE 25
FROM openjdk:25-slim
WORKDIR /app
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]