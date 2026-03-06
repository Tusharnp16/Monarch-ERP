# STAGE 1 & 2 (Keep as they are)
FROM maven:3.9-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Build a Custom, Tiny JRE
FROM eclipse-temurin:17-alpine AS jre-builder
WORKDIR /app

# Added java.compiler to the list to fix the SourceVersion error
RUN $JAVA_HOME/bin/jlink \
    --module-path "$JAVA_HOME/jmods" \
    --add-modules java.base,java.desktop,java.instrument,java.management,java.naming,java.prefs,java.rmi,java.scripting,java.security.jgss,java.sql,jdk.httpserver,jdk.unsupported,java.xml,jdk.crypto.ec,java.compiler \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /custom-jre
# ... STAGES 1 & 2 remain the same ...

# STAGE 3: Final Minimal Image
FROM alpine:latest
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Explicitly set the workdir
WORKDIR /app

# Copy the JRE
COPY --from=jre-builder /custom-jre $JAVA_HOME

# Create user
RUN addgroup -S spring && adduser -S spring -G spring

# Copy the JAR and force it into /app/app.jar
COPY --from=build --chown=spring:spring /app/target/*.war /app/app.war

USER spring:spring

# Use the absolute path to ensure no "Not Found" errors
ENTRYPOINT ["java", "-jar", "/app/app.war"]