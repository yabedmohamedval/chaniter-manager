package istic.mmm.chantier_manager_api.entities;


import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "chantiers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Chantier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String objet;

    private LocalDate dateDebut;

    private int nbDemiJournees;

    private String lieu;

    private String contactClientNom;

    private String contactClientTelephone;

    @Enumerated(EnumType.STRING)
    private StatutChantier statut;

    // Chef de chantier
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chef_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Utilisateur chef;

    // Equipe affectée
    @ManyToOne
    @JoinColumn(name = "equipe_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Equipe equipe;

    // Véhicules utilisés
    //@ManyToMany
    //@JoinTable(
    //        name = "chantiers_vehicules",
    //        joinColumns = @JoinColumn(name = "chantier_id"),
    //        inverseJoinColumns = @JoinColumn(name = "vehicule_id")
    //)
    //@Builder.Default
    //private Set<Vehicule> vehicules = new HashSet<>();
    @OneToMany(mappedBy = "chantier")
    @JsonIgnore // ou @JsonIgnoreProperties pour éviter recursion
    private List<Vehicule> vehicules = new ArrayList<>();

    // Matériel affecté
    @ManyToMany
    @JoinTable(
            name = "chantiers_materiels",
            joinColumns = @JoinColumn(name = "chantier_id"),
            inverseJoinColumns = @JoinColumn(name = "materiel_id")
    )
    @Builder.Default
    private Set<Materiel> materiels = new HashSet<>();

    // Anomalies remontées sur ce chantier
    @OneToMany(mappedBy = "chantier", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    @JsonIgnore
    private Set<Anomalie> anomalies = new HashSet<>();

    // Photos globales du chantier
    @OneToMany(mappedBy = "chantier", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    @JsonIgnore
    private Set<PhotoChantier> photos = new HashSet<>();
}
