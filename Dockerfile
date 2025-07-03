# ---- Step 1: Build stage with Gradle and JDK 24 ----
FROM eclipse-temurin:24-jdk AS builder

# Download and install JDK 24 manually
# ENV JDK_DOWNLOAD_URL=https://download.oracle.com/java/24/latest/jdk-24_linux-x64_bin.tar.gz
# RUN curl -fsSL $JDK_DOWNLOAD_URL -o jdk24.tar.gz && \
#     mkdir /opt/jdk && \
#     tar -xzf jdk24.tar.gz -C /opt/jdk --strip-components=1 && \
#     rm jdk24.tar.gz

# # Set JDK 24 as the default Java
# ENV JAVA_HOME=/opt/jdk
# ENV PATH="$JAVA_HOME/bin:$PATH"

# Set work directory and copy app
WORKDIR /app
COPY . .

RUN chmod +x ./gradlew

# Build the app using JDK 24
RUN ./gradlew clean bootJar --no-daemon

# ---- Step 2: Runtime stage (minimal) ----
FROM eclipse-temurin:24-jre

# Copy the JDK 24 from build stage
# COPY --from=builder /opt/jdk /opt/jdk
# ENV JAVA_HOME=/opt/jdk
# ENV PATH="$JAVA_HOME/bin:$PATH"

# Create app directory
WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 5000

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
