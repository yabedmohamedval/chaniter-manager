package istic.mmm.chantier_manager_api.dto;

import istic.mmm.chantier_manager_api.entities.RoleUtilisateur;
import lombok.Data;

@Data
public class RegisterRequest {
    private String nom;
    private String prenom;
    private String email;
    private String telephone;
    private String password;
    private RoleUtilisateur role; // tu peux le fixer côté back si tu veux
}