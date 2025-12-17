package istic.mmm.chantier_manager_api.controllers;


import istic.mmm.chantier_manager_api.dto.EquipeCreateRequest;
import istic.mmm.chantier_manager_api.dto.EquipeResponse;
import istic.mmm.chantier_manager_api.dto.EquipeUpdateRequest;
import istic.mmm.chantier_manager_api.services.EquipeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/equipes")
@RequiredArgsConstructor
@CrossOrigin
public class EquipeController {

    private final EquipeService equipeService;

    @GetMapping
    public ResponseEntity<List<EquipeResponse>> getAll() {
        return ResponseEntity.ok(equipeService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<EquipeResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(equipeService.findById(id));
    }

    @PostMapping
    public ResponseEntity<EquipeResponse> create(@RequestBody EquipeCreateRequest req) {
        return ResponseEntity.ok(equipeService.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<EquipeResponse> update(@PathVariable Long id,
                                                 @RequestBody EquipeUpdateRequest req) {
        return ResponseEntity.ok(equipeService.update(id, req));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        equipeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // métier
    @PostMapping("/{id}/membres/{userId}")
    public ResponseEntity<EquipeResponse> addMembre(@PathVariable Long id, @PathVariable Long userId) {
        return ResponseEntity.ok(equipeService.addMembre(id, userId));
    }

    @DeleteMapping("/{id}/membres/{userId}")
    public ResponseEntity<EquipeResponse> removeMembre(@PathVariable Long id, @PathVariable Long userId) {
        return ResponseEntity.ok(equipeService.removeMembre(id, userId));
    }

    @PutMapping("/{id}/chef/{chefId}")
    public ResponseEntity<EquipeResponse> changeChef(@PathVariable Long id, @PathVariable Long chefId) {
        return ResponseEntity.ok(equipeService.changeChef(id, chefId));
    }
}
