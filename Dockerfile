# Step 1: Build Stage
FROM gradle:8.5-jdk21 AS build

WORKDIR /home/app

COPY --chown=gradle:gradle . .

RUN chmod +x gradlew

RUN ./gradlew clean build -x test

# Step 2: Runtime Stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /

EXPOSE 8080

COPY --from=build /home/app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
