package istic.mmm.chantier_manager_api.dto;

import istic.mmm.chantier_manager_api.entities.RoleUtilisateur;

public record UtilisateurLight(
        Long id,
        String nom,
        String prenom,
        RoleUtilisateur role
) {}