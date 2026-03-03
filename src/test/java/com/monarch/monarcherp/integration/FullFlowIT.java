//package com.monarch.monarcherp.integration;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.monarch.monarcherp.repository.UserRepository;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
//import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
//import org.springframework.http.MediaType;
//import org.springframework.test.context.DynamicPropertyRegistry;
//import org.springframework.test.context.DynamicPropertySource;
//import org.springframework.test.web.servlet.MockMvc;
//import org.testcontainers.containers.PostgreSQLContainer;
//import org.testcontainers.junit.jupiter.Container;
//import org.testcontainers.junit.jupiter.Testcontainers;
//import org.testcontainers.kafka.KafkaContainer;
//import org.testcontainers.utility.DockerImageName;
//
//import java.util.Map;
//
//import static java.util.concurrent.TimeUnit.SECONDS;
//import static org.awaitility.Awaitility.await;
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
//@Testcontainers
//@AutoConfigureMockMvc
//public class FullFlowIT {
//
//    @Container
//    @ServiceConnection
//    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");
//
//    @Container
//    static KafkaContainer kafka = new KafkaContainer(
//            DockerImageName.parse("confluentinc/cp-kafka:7.4.0")
//                    .asCompatibleSubstituteFor("apache/kafka")
//    );
//    @Autowired
//    private MockMvc mockMvc;
//
//    @Autowired
//    private ObjectMapper objectMapper;
//
//    @Autowired
//    private UserRepository userRepository;
//
//    @DynamicPropertySource
//    static void overrideProps(DynamicPropertyRegistry registry) {
//        registry.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
//    }
//
//    @Test
//    void testFullSystemFlow() throws Exception {
//        Map<String, String> userData = Map.of(
//                "name", "Monarch User",
//                "email", "test@monarch.com"
//        );
//
//        mockMvc.perform(post("/api/users")
//                        .contentType(MediaType.APPLICATION_JSON)
//                        .content(objectMapper.writeValueAsString(userData)))
//                .andExpect(status().isCreated());
//
//        var savedUser = userRepository.findByEmail("test@monarch.com");
//        assertThat(savedUser).isPresent();
//        assertThat(savedUser.get().getUserName()).isEqualTo("Monarch User");
//
//        await().atMost(5, SECONDS).untilAsserted(() -> {
//            assertThat(true).isTrue();
//        });
//    }
//}



package com.monarch.monarcherp.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.monarch.monarcherp.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.awaitility.Awaitility.await;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;



@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,  properties = {
        "MY_APP_MAIL_USER=faulttolerance@gmail.com",
        "MY_APP_MAIL_PASSWORD=nkdfgnkdfb kd ithgdikfj"
})
@AutoConfigureMockMvc
@ActiveProfiles("local") // Use your local DB and Kafka settings
public class FullFlowIT {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private UserRepository userRepository;

    @Test
    void testFullSystemFlow() throws Exception {
        Map<String, String> userData = Map.of(
                "userName", "MonarchUserTest",
                "email", "integration-success@monarch.com",
                "password", "Password123!",
                "role", "USER"
        );
        mockMvc.perform(post("/api/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(userData)))
                .andExpect(status().isCreated());

        var savedUser = userRepository.findByEmail("test-integration@monarch.com");
        assertThat(savedUser).isPresent();
        assertThat(savedUser.get().getUserName()).isEqualTo("Monarch User");
    }
}