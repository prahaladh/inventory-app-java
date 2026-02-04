# STAGE 1: Build the JAR using JDK 25
FROM eclipse-temurin:25.0.1_8-jdk-ubi10 AS build
WORKDIR /app

# Install Maven using microdnf (available in UBI images)
RUN microdnf install -y maven

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# STAGE 2: Final Runtime using your pulled image
FROM eclipse-temurin:25.0.1_8-jre-ubi10-minimal
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

# Expose the API port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]