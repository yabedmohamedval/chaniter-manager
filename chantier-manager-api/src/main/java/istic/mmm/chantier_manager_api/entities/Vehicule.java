package istic.mmm.chantier_manager_api.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "vehicules")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vehicule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String immatriculation;

    private String type;    // camion, utilitaire...

    private String libelle; // ex: "Camion benne 12T"

    private boolean disponible;

    //@ManyToMany(mappedBy = "vehicules")
    //@Builder.Default
    //private Set<Chantier> chantiers = new HashSet<>();
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chantier_id")
    @JsonIgnoreProperties({"vehicules"})
    private Chantier chantier;
}
