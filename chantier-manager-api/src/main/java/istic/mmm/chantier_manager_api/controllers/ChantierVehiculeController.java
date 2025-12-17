package istic.mmm.chantier_manager_api.controllers;

import istic.mmm.chantier_manager_api.entities.Vehicule;
import istic.mmm.chantier_manager_api.services.ChantierService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@CrossOrigin
@RequestMapping("/api/chantiers")
public class ChantierVehiculeController {

    private final ChantierService service;

    // A) véhicules d'un chantier
    @GetMapping("/{chantierId}/vehicules")
    @PreAuthorize("hasAnyRole('RESPONSABLE_CHANTIERS','CHEF_CHANTIER')")
    public ResponseEntity<List<Vehicule>> getVehiculesDuChantier(@PathVariable Long chantierId) {
        return ResponseEntity.ok(service.vehiculesDuChantier(chantierId));
    }

    // C) affecter véhicule
    @PostMapping("/{chantierId}/vehicules/{vehiculeId}")
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<Vehicule> affecter(@PathVariable Long chantierId,
                                             @PathVariable Long vehiculeId) {
        return ResponseEntity.ok(service.affecter(chantierId, vehiculeId));
    }

    // D) désaffecter véhicule
    @DeleteMapping("/{chantierId}/vehicules/{vehiculeId}")
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<Void> desaffecter(@PathVariable Long chantierId,
                                            @PathVariable Long vehiculeId) {
        service.desaffecter(chantierId, vehiculeId);
        return ResponseEntity.noContent().build();
    }
}
