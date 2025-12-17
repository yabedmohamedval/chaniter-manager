package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.Materiel;
import istic.mmm.chantier_manager_api.repositories.MaterielRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MaterielService {

    private final MaterielRepository materielRepository;

    public List<Materiel> findAll() {
        return materielRepository.findAll();
    }

    public Materiel findById(Long id) {
        return materielRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Matériel non trouvé avec id = " + id));
    }

    public Materiel create(Materiel materiel) {
        materiel.setId(null);
        return materielRepository.save(materiel);
    }

    public Materiel update(Long id, Materiel updated) {
        Materiel existing = findById(id);
        existing.setLibelle(updated.getLibelle());
        existing.setType(updated.getType());
        existing.setQuantiteTotale(updated.getQuantiteTotale());
        return materielRepository.save(existing);
    }

    public void delete(Long id) {
        materielRepository.deleteById(id);
    }
}
