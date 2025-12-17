package istic.mmm.chantier_manager_api.dto;

import istic.mmm.chantier_manager_api.entities.StatutChantier;

public record ChangeStatutRequest(StatutChantier statut) {
}
