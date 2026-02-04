# This image is usually the most stable "latest" Java 25 source
FROM container-registry.oracle.com/java/openjdk:25 AS runtime

WORKDIR /app

# Step 3: Copy the JAR we just built in Step 1
COPY target/inventory-app-java-1.0-SNAPSHOT.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]