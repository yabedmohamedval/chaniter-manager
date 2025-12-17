package istic.mmm.chantier_manager_api.controllers;


import istic.mmm.chantier_manager_api.dto.ChangeStatutRequest;
import istic.mmm.chantier_manager_api.dto.CreateAnomalieRequest;
import istic.mmm.chantier_manager_api.entities.*;
import istic.mmm.chantier_manager_api.repositories.ChantierRepository;
import istic.mmm.chantier_manager_api.repositories.UtilisateurRepository;
import istic.mmm.chantier_manager_api.services.ChantierService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/chantiers")
@RequiredArgsConstructor
@CrossOrigin
public class ChantierController {

    private final ChantierService chantierService;
    private final ChantierRepository chantierRepository;
    private final UtilisateurRepository utilisateurRepository;



    @GetMapping
    @PreAuthorize("hasAnyRole('CHEF_CHANTIER','RESPONSABLE_CHANTIERS')")
    public List<Chantier> getChantiers(Authentication authentication) {

        // ✅ on récupère l'email du user :
        String email = authentication.getName();

        // ✅ on recharge l'utilisateur depuis la base
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Utilisateur non trouvé"
                ));

        RoleUtilisateur role = user.getRole();

        if (role == RoleUtilisateur.RESPONSABLE_CHANTIERS) {
            // le responsable voit tout
            return chantierService.findAll();
        }

        if (role == RoleUtilisateur.CHEF_CHANTIER) {
            // le chef ne voit que ses chantiers
            return chantierRepository.findByChefId(user.getId());
        }

        // les autres rôles n'ont pas le droit
        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Accès refusé");
    }

    @GetMapping("/{id}")
    public ResponseEntity<Chantier> getById(@PathVariable Long id) {
        return ResponseEntity.ok(chantierService.findById(id));
    }

    @PatchMapping("/{id}/statut")
    @PreAuthorize("hasAnyRole('CHEF_CHANTIER','RESPONSABLE_CHANTIERS')")
    public Chantier changeStatut(@PathVariable Long id,
                                 @RequestBody ChangeStatutRequest request,
                                 Authentication authentication) {

        String email = authentication.getName();
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Utilisateur non trouvé"
                ));

        return chantierService.changeStatut(id, request.statut(), user);
    }

    @PostMapping
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<Chantier> create(@RequestBody Chantier chantier) {
        return ResponseEntity.ok(chantierService.create(chantier));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<Chantier> update(@PathVariable Long id,
                                           @RequestBody Chantier chantier) {
        return ResponseEntity.ok(chantierService.update(id, chantier));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('RESPONSABLE_CHANTIERS')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        chantierService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/anomalies")
    @PreAuthorize("hasAnyRole('CHEF_CHANTIER','RESPONSABLE_CHANTIERS')")
    public List<Anomalie> getAnomalies(@PathVariable Long id,
                                       Authentication authentication) {

        String email = authentication.getName();
        var auth = SecurityContextHolder.getContext().getAuthentication();
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Utilisateur non trouvé"
                ));

        Chantier chantier = chantierService.findById(id);

        // Si CHEF : il doit être chef de ce chantier
        //if (user.getRole() == RoleUtilisateur.CHEF_CHANTIER) {
        //    if (chantier.getChef() == null ||
        //            !chantier.getChef().getId().equals(user.getId())) {
        //        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Accès refusé");
        //    }
        //}

        return chantier.getAnomalies().stream().toList();
    }


    @PostMapping("/{id}/anomalies")
    @PreAuthorize("hasAnyRole('CHEF_CHANTIER','RESPONSABLE_CHANTIERS')")
    public Anomalie createAnomalie(@PathVariable Long id,
                                   @RequestBody CreateAnomalieRequest request,
                                   Authentication authentication) {

        String email = authentication.getName();
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Utilisateur non trouvé"
                ));

        return chantierService.createAnomalie(id, request.description(), user);
    }

}
