package com.monarch.monarcherp.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.MediaType;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.testcontainers.containers.KafkaContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.util.Map;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.awaitility.Awaitility.await;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
@AutoConfigureMockMvc
public class FullFlowIT {

    // 1. SPINS UP REAL POSTGRES
    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");
    // 2. SPINS UP REAL KAFKA
    @Container
    static KafkaContainer kafka = new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:latest"));
    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private ObjectMapper objectMapper;

    // Connect Kafka container to Spring properties
    @DynamicPropertySource
    static void overrideProps(DynamicPropertyRegistry registry) {
        registry.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
    }

    @Test
    void testFullSystemFlow() throws Exception {
        // --- DATA PREP ---
        Map<String, String> userData = Map.of(
                "name", "Monarch User",
                "email", "test@monarch.com"
        );

        // --- STEP 1: API (The Entry Point) ---
        mockMvc.perform(post("/api/users") // Replace with your actual endpoint
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(userData)))
                .andExpect(status().isCreated());

        // --- STEP 2: DB (The Persistence) ---
        // Here you would use your UserRepository to assert the data exists in Postgres
        // Example: assertTrue(userRepository.existsByEmail("test@monarch.com"));

        // --- STEP 3: KAFKA (The Logical Challenge) ---
        // Use Awaitility to wait for the message to be processed/published
        await().atMost(5, SECONDS).untilAsserted(() -> {
            // Check if Kafka message was sent.
            // In a real test, you'd use a Test Kafka Consumer here.
            System.out.println("Verifying Kafka message delivery...");
        });
    }
}