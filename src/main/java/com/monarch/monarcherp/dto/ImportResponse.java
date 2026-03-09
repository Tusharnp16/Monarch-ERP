package com.monarch.monarcherp.dto;

import java.util.List;

public class ImportResponse {
    public record RowError(int row, String message) {}
    public record ValidationResponse(boolean success, List<RowError> errors) {}
}
