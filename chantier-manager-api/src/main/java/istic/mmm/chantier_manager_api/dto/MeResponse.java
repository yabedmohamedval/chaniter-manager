package istic.mmm.chantier_manager_api.dto;

import istic.mmm.chantier_manager_api.entities.RoleUtilisateur;

public record MeResponse(
        Long id,
        String nom,
        String prenom,
        String email,
        String telephone,
        RoleUtilisateur role
) {}
