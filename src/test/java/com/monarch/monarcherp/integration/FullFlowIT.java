////package com.monarch.monarcherp.integration;
////
////import com.fasterxml.jackson.databind.ObjectMapper;
////import com.monarch.monarcherp.model.User;
////import com.monarch.monarcherp.repository.UserRepository;
////import org.junit.jupiter.api.Test;
////import org.springframework.beans.factory.annotation.Autowired;
////import org.springframework.boot.test.context.SpringBootTest;
////import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
////import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
////import org.springframework.http.MediaType;
////import org.springframework.security.test.context.support.WithMockUser;
////import org.springframework.test.context.DynamicPropertyRegistry;
////import org.springframework.test.context.DynamicPropertySource;
////import org.springframework.test.web.servlet.MockMvc;
////import org.testcontainers.containers.PostgreSQLContainer;
////import org.testcontainers.junit.jupiter.Container;
////import org.testcontainers.junit.jupiter.Testcontainers;
////import org.testcontainers.kafka.KafkaContainer;
////import org.testcontainers.utility.DockerImageName;
////
////import static java.util.concurrent.TimeUnit.SECONDS;
////import static org.awaitility.Awaitility.await;
////import static org.assertj.core.api.Assertions.assertThat;
////import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
////import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
////import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
////
////@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
////@Testcontainers
////@AutoConfigureMockMvc
////public class FullFlowIT {
////
////    @Container
////    @ServiceConnection
////    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");
////
////
////    @Container
////    static KafkaContainer kafka = new KafkaContainer(
////            DockerImageName.parse("confluentinc/cp-kafka:7.4.0")
////                    .asCompatibleSubstituteFor("apache/kafka")
////    );
////
////    @Autowired
////    private MockMvc mockMvc;
////
////    @Autowired
////    private ObjectMapper objectMapper;
////
////    @Autowired
////    private UserRepository userRepository;
////
////    @DynamicPropertySource
////    static void overrideProps(DynamicPropertyRegistry registry) {
////        registry.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
////        registry.add("MY_APP_MAIL_USER", () -> "tusharparmaroff16@gmail.com");
////        registry.add("MY_APP_MAIL_PASSWORD", () -> "nnoufftfgsghuwhg");
////    }
////
////    @Test
////    @WithMockUser(username = "admin", roles = {"ADMIN"})
////    void testFullSystemFlow() throws Exception {
////
////        User userPayload = User.builder()
////                .userName("Monarch User")
////                .email("test@monarch.com")
////                .password("Password123!")
////                .role("USER")
////                .build();
////
////        mockMvc.perform(post("/api/users")
////                        .contentType(MediaType.APPLICATION_JSON)
////                        .content(objectMapper.writeValueAsString(userPayload)))
////                .andDo(print())
////                .andExpect(status().isCreated());
////
////        var savedUser = userRepository.findByEmail("test@monarch.com");
////        assertThat(savedUser).isPresent();
////        assertThat(savedUser.get().getUserName()).isEqualTo("Monarch User");
////
////
////        await().atMost(5, SECONDS).untilAsserted(() -> {
////            var userAfterProcessing = userRepository.findByEmail("test@monarch.com");
////            assertThat(userAfterProcessing).isPresent();
////        });
////    }
////}
//
//
//
//package com.monarch.monarcherp.integration;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.monarch.monarcherp.model.User;
//import com.monarch.monarcherp.repository.UserRepository;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
//import org.springframework.http.MediaType;
//import org.springframework.security.test.context.support.WithMockUser;
//import org.springframework.test.context.ActiveProfiles;
//import org.springframework.test.web.servlet.MockMvc;
//
//import java.util.Map;
//
//import static java.util.concurrent.TimeUnit.SECONDS;
//import static org.awaitility.Awaitility.await;
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
//import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//
//
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,  properties = {
//        "MY_APP_MAIL_USER=tusharparmaroff16@gmail.com",
//        "MY_APP_MAIL_PASSWORD=nnoufftfgsghuwhg"
//})
//@AutoConfigureMockMvc
//@ActiveProfiles("local")
//public class FullFlowIT {
//
//    @Autowired
//    private MockMvc mockMvc;
//
//    private final ObjectMapper objectMapper = new ObjectMapper();
//
//    @Autowired
//    private UserRepository userRepository;
//
//    @Test
//    @WithMockUser(username = "admin", roles = {"ADMIN"})
//    void testFullSystemFlow() throws Exception {
//        User userPayload = User.builder()
//                .userName("Monarch User 5")
//                .email("integration-success5@monarch.com")
//                .password("Password123!")
//                .role("USER")
//                .build();
//
//        mockMvc.perform(post("/api/users")
//                        .contentType(MediaType.APPLICATION_JSON)
//                        .content(objectMapper.writeValueAsString(userPayload)))
//                .andDo(print())
//                .andExpect(status().isCreated());
//
//        var savedUser = userRepository.findByEmail("integration-success5@monarch.com");
//
//        assertThat(savedUser).isPresent();
//        assertThat(savedUser.get().getUserName()).isEqualTo("Monarch User 5");
//    }
//}