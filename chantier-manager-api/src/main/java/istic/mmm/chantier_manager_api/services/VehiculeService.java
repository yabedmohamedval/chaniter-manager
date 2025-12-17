package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.Vehicule;
import istic.mmm.chantier_manager_api.repositories.VehiculeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VehiculeService {

    private final VehiculeRepository vehiculeRepository;

    public List<Vehicule> findAll() {
        return vehiculeRepository.findAll();
    }

    public Vehicule findById(Long id) {
        return vehiculeRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Véhicule introuvable"));
    }

    public Vehicule create(Vehicule vehicule) {
        vehicule.setId(null);
        return vehiculeRepository.save(vehicule);
    }

    public Vehicule update(Long id, Vehicule updated) {
        Vehicule existing = findById(id);
        existing.setImmatriculation(updated.getImmatriculation());
        existing.setType(updated.getType());
        existing.setLibelle(updated.getLibelle());
        existing.setDisponible(updated.isDisponible());
        return vehiculeRepository.save(existing);
    }

    public void delete(Long id) {
        vehiculeRepository.deleteById(id);
    }

    public List<Vehicule> vehiculesDisponibles() {
        return vehiculeRepository.findByChantierIsNullAndDisponibleTrue();
    }
}
