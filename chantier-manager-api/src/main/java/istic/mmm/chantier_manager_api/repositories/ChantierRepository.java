package istic.mmm.chantier_manager_api.repositories;

import istic.mmm.chantier_manager_api.entities.Chantier;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChantierRepository extends JpaRepository<Chantier, Long> {
    List<Chantier> findByChefId(Long chefId);
}
