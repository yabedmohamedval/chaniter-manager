package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.Anomalie;
import istic.mmm.chantier_manager_api.repositories.AnomalieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnomalieService {

    private final AnomalieRepository anomalieRepository;

    public List<Anomalie> findAll() {
        return anomalieRepository.findAll();
    }

    public Anomalie findById(Long id) {
        return anomalieRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Anomalie non trouvée avec id = " + id));
    }

    public Anomalie create(Anomalie anomalie) {
        anomalie.setId(null);
        return anomalieRepository.save(anomalie);
    }

    public Anomalie update(Long id, Anomalie updated) {
        Anomalie existing = findById(id);
        existing.setDescription(updated.getDescription());
        existing.setChantier(updated.getChantier());
        existing.setAuteur(updated.getAuteur());
        return anomalieRepository.save(existing);
    }

    public void delete(Long id) {
        anomalieRepository.deleteById(id);
    }
}
