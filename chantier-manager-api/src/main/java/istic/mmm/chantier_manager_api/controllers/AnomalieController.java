package istic.mmm.chantier_manager_api.controllers;

import istic.mmm.chantier_manager_api.dto.CreateAnomalieRequest;
import istic.mmm.chantier_manager_api.entities.Anomalie;
import istic.mmm.chantier_manager_api.entities.Chantier;
import istic.mmm.chantier_manager_api.entities.RoleUtilisateur;
import istic.mmm.chantier_manager_api.entities.Utilisateur;
import istic.mmm.chantier_manager_api.repositories.AnomalieRepository;
import istic.mmm.chantier_manager_api.repositories.ChantierRepository;
import istic.mmm.chantier_manager_api.repositories.UtilisateurRepository;
import istic.mmm.chantier_manager_api.services.AnomalieService;
import istic.mmm.chantier_manager_api.services.ChantierService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/chantiers")
@RequiredArgsConstructor
@CrossOrigin
public class AnomalieController {

    private final AnomalieRepository anomalieRepository;
    private final ChantierRepository chantierRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final ChantierService chantierService;



}
