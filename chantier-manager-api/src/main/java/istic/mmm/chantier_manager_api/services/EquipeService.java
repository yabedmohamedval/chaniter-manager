package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.dto.EquipeCreateRequest;
import istic.mmm.chantier_manager_api.dto.EquipeResponse;
import istic.mmm.chantier_manager_api.dto.EquipeUpdateRequest;
import istic.mmm.chantier_manager_api.dto.UtilisateurLight;
import istic.mmm.chantier_manager_api.entities.Equipe;
import istic.mmm.chantier_manager_api.entities.RoleUtilisateur;
import istic.mmm.chantier_manager_api.entities.Utilisateur;
import istic.mmm.chantier_manager_api.repositories.EquipeRepository;
import istic.mmm.chantier_manager_api.repositories.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Service
@RequiredArgsConstructor
public class EquipeService {

    private final EquipeRepository equipeRepository;
    private final UtilisateurRepository utilisateurRepository;

    public List<EquipeResponse> findAll() {
        return equipeRepository.findAll().stream().map(this::toResponse).toList();
    }

    public EquipeResponse findById(Long id) {
        return toResponse(getEquipe(id));
    }

    public EquipeResponse create(EquipeCreateRequest req) {
        Equipe equipe = new Equipe();
        equipe.setNom(req.nom());

        if (req.chefId() != null) {
            Utilisateur chef = getUser(req.chefId());
            assertChefRole(chef);
            equipe.setChef(chef);
        }

        equipe.setMembres(loadAndValidateMembres(req.membreIds(), equipe.getChef()));
        return toResponse(equipeRepository.save(equipe));
    }

    public EquipeResponse update(Long id, EquipeUpdateRequest req) {
        Equipe existing = getEquipe(id);
        existing.setNom(req.nom());

        Utilisateur chef = null;
        if (req.chefId() != null) {
            chef = getUser(req.chefId());
            assertChefRole(chef);
        }
        existing.setChef(chef);

        existing.setMembres(loadAndValidateMembres(req.membreIds(), chef));
        return toResponse(equipeRepository.save(existing));
    }

    public void delete(Long id) {
        equipeRepository.delete(getEquipe(id));
    }

    // ---- endpoints métier ----

    public EquipeResponse addMembre(Long equipeId, Long userId) {
        Equipe equipe = getEquipe(equipeId);
        Utilisateur u = getUser(userId);
        assertMembreRole(u);
        if (equipe.getChef() != null && equipe.getChef().getId().equals(u.getId())) {
            throw new RuntimeException("Le chef ne peut pas être membre.");
        }
        equipe.getMembres().add(u);
        return toResponse(equipeRepository.save(equipe));
    }

    public EquipeResponse removeMembre(Long equipeId, Long userId) {
        Equipe equipe = getEquipe(equipeId);
        equipe.getMembres().removeIf(u -> u.getId().equals(userId));
        return toResponse(equipeRepository.save(equipe));
    }

    public EquipeResponse changeChef(Long equipeId, Long chefId) {
        Equipe equipe = getEquipe(equipeId);
        Utilisateur chef = getUser(chefId);
        assertChefRole(chef);

        // éviter chef dans membres
        equipe.getMembres().removeIf(u -> u.getId().equals(chefId));

        equipe.setChef(chef);
        return toResponse(equipeRepository.save(equipe));
    }

    // ---- helpers ----

    private Equipe getEquipe(Long id) {
        return equipeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Equipe non trouvée id=" + id));
    }

    private Utilisateur getUser(Long id) {
        return utilisateurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé id=" + id));
    }

    private void assertChefRole(Utilisateur u) {
        if (u.getRole() != RoleUtilisateur.CHEF_CHANTIER) {
            throw new RuntimeException("Le chef doit avoir le rôle CHEF_CHANTIER.");
        }
    }

    private void assertMembreRole(Utilisateur u) {
        if (u.getRole() != RoleUtilisateur.EQUIPIER) {
            throw new RuntimeException("Un membre doit avoir le rôle EQUIPIER.");
        }
    }

    private Set<Utilisateur> loadAndValidateMembres(Set<Long> membreIds, Utilisateur chef) {
        if (membreIds == null || membreIds.isEmpty()) return new HashSet<>();

        Set<Utilisateur> membres = new HashSet<>(utilisateurRepository.findAllById(membreIds));

        // check ids manquants
        if (membres.size() != new HashSet<>(membreIds).size()) {
            throw new RuntimeException("Un ou plusieurs membreIds sont invalides.");
        }

        for (Utilisateur m : membres) assertMembreRole(m);

        if (chef != null) {
            membres.removeIf(m -> m.getId().equals(chef.getId())); // interdire chef dans membres
        }
        return membres;
    }

    private EquipeResponse toResponse(Equipe e) {
        UtilisateurLight chef = (e.getChef() == null) ? null :
                new UtilisateurLight(e.getChef().getId(), e.getChef().getNom(), e.getChef().getPrenom(), e.getChef().getRole());

        Set<UtilisateurLight> membres = e.getMembres().stream()
                .map(u -> new UtilisateurLight(u.getId(), u.getNom(), u.getPrenom(), u.getRole()))
                .collect(java.util.stream.Collectors.toSet());

        return new EquipeResponse(e.getId(), e.getNom(), chef, membres);
    }
}
