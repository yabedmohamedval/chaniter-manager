package istic.mmm.chantier_manager_api.dto;

import java.util.Set;

public record EquipeResponse(
        Long id,
        String nom,
        UtilisateurLight chef,
        Set<UtilisateurLight> membres
) {}
