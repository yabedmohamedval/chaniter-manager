package istic.mmm.chantier_manager_api.dto;

import java.util.Set;

public record EquipeCreateRequest(
        String nom,
        Long chefId,
        Set<Long> membreIds
) {}
