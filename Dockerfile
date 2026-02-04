# STAGE 1: Build using JDK 25
FROM eclipse-temurin:25-jdk-ubi10 AS build
WORKDIR /app

# Install Maven (UBI uses microdnf)
RUN microdnf install -y maven

COPY pom.xml .
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# STAGE 2: Runtime using the minimal image you pulled
# Note: Ensure you use the exact tag you found locally
FROM eclipse-temurin:25-jre-ubi10-minimal
WORKDIR /app

# Copy the Fat JAR from the build stage
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

# Expose Port 8081
EXPOSE 8081

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]