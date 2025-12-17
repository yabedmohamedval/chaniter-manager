package istic.mmm.chantier_manager_api.repositories;

import istic.mmm.chantier_manager_api.entities.Materiel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MaterielRepository extends JpaRepository<Materiel, Long> {
}
