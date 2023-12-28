#
# Build stage
#
#FROM maven:3.9.6-amazoncorretto-17
#WORKDIR /app
#COPY . .
#RUN mvn -e clean install
#EXPOSE 8080

# LABEL authors="antonioabbatiello"

# ENTRYPOINT ["java", "-jar", "home/app/target/DietiDeals24-0.0.1-SNAPSHOT.jar"]
#CMD mvn spring-boot:run

# Use a base image with Java 17
FROM openjdk:17

# Copy the JAR package into the image
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Expose the application port
EXPOSE 8080

# Run the App
ENTRYPOINT ["java", "-jar", "/app.jar"]