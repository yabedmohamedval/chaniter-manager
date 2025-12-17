package istic.mmm.chantier_manager_api.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "photos_chantier")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhotoChantier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String url; // ou chemin local

    private LocalDateTime datePrise;

    private String commentaire;

    // Photo liée à un chantier (vue générale)
    @ManyToOne
    @JoinColumn(name = "chantier_id")
    private Chantier chantier;

    // Optionnellement liée à une anomalie précise
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "anomalie_id")
    @JsonIgnore
    private Anomalie anomalie;
}
