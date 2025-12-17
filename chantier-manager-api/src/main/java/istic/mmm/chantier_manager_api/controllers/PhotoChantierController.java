package istic.mmm.chantier_manager_api.controllers;

import istic.mmm.chantier_manager_api.entities.Anomalie;
import istic.mmm.chantier_manager_api.entities.PhotoChantier;
import istic.mmm.chantier_manager_api.repositories.AnomalieRepository;
import istic.mmm.chantier_manager_api.repositories.PhotoChantierRepository;
import istic.mmm.chantier_manager_api.services.PhotoChantierService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/anomalies")
@RequiredArgsConstructor
@CrossOrigin
public class PhotoChantierController {

    private final AnomalieRepository anomalieRepository;
    private final PhotoChantierRepository photoChantierRepository;

    private final Path rootLocation = Paths.get("uploads/anomalies");

    @PostMapping("/{anomalieId}/photos")
    @PreAuthorize("hasAnyRole('CHEF_CHANTIER','RESPONSABLE_CHANTIERS')")
    public PhotoChantier uploadPhoto(@PathVariable Long anomalieId,
                                     @RequestParam("file") MultipartFile file) throws IOException {

        Anomalie anomalie = anomalieRepository.findById(anomalieId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Anomalie introuvable"));

        // 1) Sauver le fichier sur le disque
        if (Files.notExists(rootLocation)) {
            Files.createDirectories(rootLocation);
        }

        String filename = UUID.randomUUID() + "-" + file.getOriginalFilename();
        Path destinationFile = rootLocation.resolve(filename).normalize().toAbsolutePath();
        Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);

        // 2) Sauver l'entrée DB
        PhotoChantier photo = new PhotoChantier();
        photo.setUrl("/uploads/anomalies/" + filename); // ou juste filename, selon comment tu serves les fichiers
        photo.setAnomalie(anomalie);

        photo = photoChantierRepository.save(photo);

        // 3) Ajouter dans la collection de l’anomalie (optionnel si cascade)
        anomalie.getPhotos().add(photo);

        return photo;
    }
}
