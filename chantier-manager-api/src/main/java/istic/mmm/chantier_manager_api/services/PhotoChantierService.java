package istic.mmm.chantier_manager_api.services;

import istic.mmm.chantier_manager_api.entities.PhotoChantier;
import istic.mmm.chantier_manager_api.repositories.PhotoChantierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PhotoChantierService {


    private final PhotoChantierRepository photoChantierRepository;

    public List<PhotoChantier> findAll() {
        return photoChantierRepository.findAll();
    }

    public PhotoChantier findById(Long id) {
        return photoChantierRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Photo non trouvée avec id = " + id));
    }

    public PhotoChantier create(PhotoChantier photo) {
        photo.setId(null);
        return photoChantierRepository.save(photo);
    }

    public PhotoChantier update(Long id, PhotoChantier updated) {
        PhotoChantier existing = findById(id);
        existing.setUrl(updated.getUrl());
        existing.setDatePrise(updated.getDatePrise());
        existing.setCommentaire(updated.getCommentaire());
        existing.setChantier(updated.getChantier());
        existing.setAnomalie(updated.getAnomalie());
        return photoChantierRepository.save(existing);
    }

    public void delete(Long id) {
        photoChantierRepository.deleteById(id);
    }
}
