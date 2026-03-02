package com.monarch.monarcherp.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ApiResponse<T> {


    @JsonView(Object.class)
    private boolean success;

    @JsonView(Object.class)
    private String message;

    @JsonView(Object.class)
    private T data;

    @JsonView(Object.class)
    private LocalDateTime timeStamp;

    public static <T> ApiResponse<T> success(T data, String message) {
        ApiResponse<T> response = new ApiResponse<>();
        response.success = true;
        response.message = message;
        response.data = data;
        response.timeStamp = LocalDateTime.now();
        return response;
    }

    public static <T> ApiResponse<T> error(String message) {
        ApiResponse<T> response = new ApiResponse<>();
        response.success = false;
        response.message = message;
        response.data = null;
        response.timeStamp = LocalDateTime.now();
        return response;
    }

}
