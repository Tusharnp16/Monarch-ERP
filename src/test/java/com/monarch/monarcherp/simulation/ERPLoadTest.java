//package com.monarch.monarcherp.simulation;
//
//import static io.gatling.javaapi.core.CoreDsl.*;
//import static io.gatling.javaapi.http.HttpDsl.*;
//import static org.springframework.security.config.web.server.ServerHttpSecurity.http;
//import static sun.java2d.cmm.ColorTransform.Simulation;
//
//import io.gatling.javaapi.core.*;
//import io.gatling.javaapi.http.*;
//
//public class ERPLoadTest extends Simulation {
//
//    HttpProtocolBuilder httpProtocol = http
//            .baseUrl("http://localhost:8080")
//            .acceptHeader("application/json");
//
//    ScenarioBuilder scn = scenario("ERP Stress Test")
//            .exec(http("Get Products Request")
//                    .get("/api/products"));
//
//    {
//        setUp(
//                scn.injectOpen(atOnceUsers(50))
//        ).protocols(httpProtocol);
//    }
//}