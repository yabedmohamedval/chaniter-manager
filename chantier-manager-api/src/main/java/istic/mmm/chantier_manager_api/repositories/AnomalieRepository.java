package istic.mmm.chantier_manager_api.repositories;

import istic.mmm.chantier_manager_api.entities.Anomalie;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AnomalieRepository extends JpaRepository<Anomalie, Long> {
    List<Anomalie> findByChantierId(Long chantierId);

}
