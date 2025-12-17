package istic.mmm.chantier_manager_api.controllers;

import istic.mmm.chantier_manager_api.entities.Materiel;
import istic.mmm.chantier_manager_api.services.MaterielService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/materiels")
@RequiredArgsConstructor
@CrossOrigin
public class MaterielController {

    private final MaterielService materielService;

    @GetMapping
    public ResponseEntity<List<Materiel>> getAll() {
        return ResponseEntity.ok(materielService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Materiel> getById(@PathVariable Long id) {
        return ResponseEntity.ok(materielService.findById(id));
    }

    @PostMapping
    public ResponseEntity<Materiel> create(@RequestBody Materiel materiel) {
        return ResponseEntity.ok(materielService.create(materiel));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Materiel> update(@PathVariable Long id,
                                           @RequestBody Materiel materiel) {
        return ResponseEntity.ok(materielService.update(id, materiel));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        materielService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
