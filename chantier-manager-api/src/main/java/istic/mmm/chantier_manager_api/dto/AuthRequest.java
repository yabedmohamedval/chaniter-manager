package istic.mmm.chantier_manager_api.dto;

import lombok.Data;

@Data
public class AuthRequest {
    private String email;
    private String password;
}