package istic.mmm.chantier_manager_api.repositories;

import istic.mmm.chantier_manager_api.entities.Vehicule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VehiculeRepository extends JpaRepository<Vehicule, Long> {
    List<Vehicule> findByChantierId(Long chantierId);
    List<Vehicule> findByChantierIsNullAndDisponibleTrue();
}
