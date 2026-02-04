# STAGE 1: Build using the exact JDK tag available
FROM eclipse-temurin:25.0.1_8-jdk-ubi10 AS build
WORKDIR /app

# UBI images use microdnf for package management
RUN microdnf install -y maven

# Copy and build
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Runtime using the exact JRE tag you pulled
FROM eclipse-temurin:25.0.1_8-jre-ubi10-minimal
WORKDIR /app

# Copy the Fat JAR
COPY --from=build /app/target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]