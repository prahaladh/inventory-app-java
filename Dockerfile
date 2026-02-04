# STAGE 1: Build with Java 25 Early Access JDK
FROM openjdk:26-ea-jdk-slim AS builder
WORKDIR /app

# Install Maven inside the Java 25 image
RUN apt-get update && apt-get install -y maven

COPY pom.xml .
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# STAGE 2: Run with Java 25 Early Access Runtime
FROM openjdk:26-ea-jre-slim
WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]