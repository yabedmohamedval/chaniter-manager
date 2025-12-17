package istic.mmm.chantier_manager_api.controllers;

import istic.mmm.chantier_manager_api.entities.Vehicule;
import istic.mmm.chantier_manager_api.services.VehiculeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehicules")
@RequiredArgsConstructor
@CrossOrigin
public class VehiculeController {

    private final VehiculeService vehiculeService;

    @GetMapping
    public ResponseEntity<List<Vehicule>> getAll() {
        return ResponseEntity.ok(vehiculeService.findAll());
    }


    @PostMapping
    public ResponseEntity<Vehicule> create(@RequestBody Vehicule vehicule) {
        return ResponseEntity.ok(vehiculeService.create(vehicule));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Vehicule> update(@PathVariable Long id,
                                           @RequestBody Vehicule vehicule) {
        return ResponseEntity.ok(vehiculeService.update(id, vehicule));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        vehiculeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/disponibles")
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<List<Vehicule>> disponibles() {
        return ResponseEntity.ok(vehiculeService.vehiculesDisponibles());
    }

    @GetMapping("/{id:\\d+}")
    public ResponseEntity<Vehicule> getById(@PathVariable Long id) {
        return ResponseEntity.ok(vehiculeService.findById(id));
    }
}
