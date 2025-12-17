package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.*;
import istic.mmm.chantier_manager_api.repositories.ChantierRepository;
import istic.mmm.chantier_manager_api.repositories.VehiculeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor

public class ChantierService {


    private final ChantierRepository chantierRepository;
    private final VehiculeRepository vehiculeRepository;


    public List<Chantier> findAll() {
        return chantierRepository.findAll();
    }

    public Chantier findById(Long id) {
        return chantierRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Chantier non trouvé"
                ));
    }

    public Chantier changeStatut(Long chantierId,
                                 StatutChantier nouveauStatut,
                                 Utilisateur utilisateurCourant) {

        Chantier chantier = findById(chantierId);

        // Si c'est un CHEF, il ne peut changer QUE ses chantiers
        if (utilisateurCourant.getRole() == RoleUtilisateur.CHEF_CHANTIER) {
            if (chantier.getChef() == null ||
                    !chantier.getChef().getId().equals(utilisateurCourant.getId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Accès refusé");
            }
        }
        // Si c’est un RESPONSABLE_CHANTIERS → ok pour tous

        chantier.setStatut(nouveauStatut);
        return chantierRepository.save(chantier);
    }

    public Chantier create(Chantier chantier) {
        chantier.setId(null);
        return chantierRepository.save(chantier);
    }

    public Chantier update(Long id, Chantier updated) {
        Chantier existing = findById(id);
        existing.setObjet(updated.getObjet());
        existing.setDateDebut(updated.getDateDebut());
        existing.setNbDemiJournees(updated.getNbDemiJournees());
        existing.setLieu(updated.getLieu());
        existing.setContactClientNom(updated.getContactClientNom());
        existing.setContactClientTelephone(updated.getContactClientTelephone());
        existing.setStatut(updated.getStatut());
        existing.setChef(updated.getChef());
        existing.setEquipe(updated.getEquipe());
        existing.setVehicules(updated.getVehicules());
        existing.setMateriels(updated.getMateriels());
        return chantierRepository.save(existing);
    }

    public void delete(Long id) {
        chantierRepository.deleteById(id);
    }

    public Anomalie createAnomalie(Long chantierId, String description, Utilisateur auteur) {
        Chantier chantier = findById(chantierId);

        // Si CHEF : vérifier qu'il est chef de ce chantier
        if (auteur.getRole() == RoleUtilisateur.CHEF_CHANTIER) {
            if (chantier.getChef() == null ||
                    !chantier.getChef().getId().equals(auteur.getId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Accès refusé");
            }
        }

        Anomalie a = new Anomalie();
        a.setDescription(description);
        a.setCreeLe(LocalDateTime.now());
        a.setAuteur(auteur);
        a.setChantier(chantier);

        chantier.getAnomalies().add(a);
        // grâce au cascade, save du chantier suffit si cascade = ALL sur anomalies
        return chantierRepository.save(chantier)
                .getAnomalies()
                .stream()
                .filter(x -> x.getDescription().equals(description)
                        && x.getAuteur().getId().equals(auteur.getId()))
                .reduce((first, second) -> second) // dernier
                .orElse(a);
    }

    public List<Vehicule> vehiculesDuChantier(Long chantierId) {
        return vehiculeRepository.findByChantierId(chantierId);
    }


    public Vehicule affecter(Long chantierId, Long vehiculeId) {
        Chantier chantier = chantierRepository.findById(chantierId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Chantier introuvable"));

        Vehicule v = vehiculeRepository.findById(vehiculeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Véhicule introuvable"));

        if (v.getChantier() != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Véhicule déjà affecté à un autre chantier");
        }

        v.setChantier(chantier);
        return vehiculeRepository.save(v);
    }

    public void desaffecter(Long chantierId, Long vehiculeId) {
        Vehicule v = vehiculeRepository.findById(vehiculeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Véhicule introuvable"));

        if (v.getChantier() == null || !v.getChantier().getId().equals(chantierId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ce véhicule n'est pas affecté à ce chantier");
        }

        v.setChantier(null);
        vehiculeRepository.save(v);
    }

}
