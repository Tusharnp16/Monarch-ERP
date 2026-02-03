package com.monarch.monarcherp.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ApiResponse<T> {

    private boolean success;
    private String message;
    private T data;
    private Long timeStamp;

    public static <T> ApiResponse<T> success(T data,String message){
            ApiResponse<T> response=new ApiResponse<>();
            response.success=true;
            response.message=message;
            response.data=data;
            response.timeStamp=System.currentTimeMillis();
            return response;
    }

    public static <T> ApiResponse<T> error(String message){
        ApiResponse<T> response=new ApiResponse<>();
        response.success=false;
        response.message=message;
        response.data=null;
        response.timeStamp=System.currentTimeMillis();
        return response;
    }

}
