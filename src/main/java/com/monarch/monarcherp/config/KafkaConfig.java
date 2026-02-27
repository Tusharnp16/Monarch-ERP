package com.monarch.monarcherp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.KafkaOperations;
import org.springframework.kafka.listener.CommonErrorHandler;
import org.springframework.kafka.listener.DeadLetterPublishingRecoverer;
import org.springframework.kafka.listener.DefaultErrorHandler;
import org.springframework.util.backoff.FixedBackOff;

@Configuration
public class KafkaConfig {

    @Bean
    public CommonErrorHandler errorHandler(KafkaOperations<Object, Object> template) {

        DeadLetterPublishingRecoverer recoverer = new DeadLetterPublishingRecoverer(template);

        FixedBackOff backOff = new FixedBackOff(2000L, 2);

        return new DefaultErrorHandler(recoverer, backOff);
    }
}