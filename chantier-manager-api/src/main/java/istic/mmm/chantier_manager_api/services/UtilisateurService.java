package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.Utilisateur;
import istic.mmm.chantier_manager_api.repositories.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class UtilisateurService {

    private final UtilisateurRepository utilisateurRepository;

    public List<Utilisateur> findAll() {
        return utilisateurRepository.findAll();
    }

    public Utilisateur findById(Long id) {
        return utilisateurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec id = " + id));
    }

    public Utilisateur create(Utilisateur utilisateur) {
        utilisateur.setId(null); // pour être sûr de créer
        return utilisateurRepository.save(utilisateur);
    }

    public Utilisateur update(Long id, Utilisateur updated) {
        Utilisateur existing = findById(id);
        existing.setNom(updated.getNom());
        existing.setPrenom(updated.getPrenom());
        existing.setEmail(updated.getEmail());
        existing.setTelephone(updated.getTelephone());
        existing.setRole(updated.getRole());
        // motDePasseHash sera géré dans la partie sécurité
        return utilisateurRepository.save(existing);
    }

    public void delete(Long id) {
        utilisateurRepository.deleteById(id);
    }
}
