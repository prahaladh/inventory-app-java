# Step 1: Use a lightweight OpenJDK 21 or 25 image
# Using 21 as it is the stable LTS, but 25 works if your repo supports it
FROM eclipse-temurin:21-jre-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the Fat JAR from your target folder to the container
COPY target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

# Step 4: Expose the port your API is listening on
EXPOSE 8081

# Step 5: Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]