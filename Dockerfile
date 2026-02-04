# We use a known-available Java 25 image from Oracle's registry
FROM container-registry.oracle.com/java/openjdk:25-oraclelinux9

WORKDIR /app

# Copy the JAR you just built manually in step 1
COPY target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

# Expose the API port
EXPOSE 8081

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]