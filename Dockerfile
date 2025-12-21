# ==== Build stage: Maven builds Spring Boot + React ====
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /workspace

# Copy Maven descriptor first to leverage cache
COPY pom.xml .

# Copy frontend and backend sources
COPY src ./src
COPY frontend ./frontend

# Build the project (frontend-maven-plugin will handle Node/React build)
RUN mvn -B -DskipTests clean package

# ==== Runtime stage: just the JRE + fat jar ====
FROM eclipse-temurin:17-jre AS runtime

WORKDIR /app

# Copy the fat jar built in the previous stage
# pom.xml uses <finalName>app</finalName>, so the jar is app.jar
COPY --from=build /workspace/target/app.jar /app/app.jar

EXPOSE 8080

# Optional: allow JAVA_OPTS override
ENV JAVA_OPTS=""

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
