# Step 1: Build Stage
FROM gradle:8.5-jdk21 AS build

WORKDIR /home/app

# Copy project files
COPY --chown=gradle:gradle . .

# Prevent permission issues with gradlew
RUN chmod +x gradlew

# Build application
RUN ./gradlew clean build -x test

# Step 2: Runtime Stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /

EXPOSE 8080

# Copy generated jar
COPY --from=build /home/app/build/libs/*.jar app.jar

# Run application
ENTRYPOINT ["java", "-jar", "/app.jar"]
