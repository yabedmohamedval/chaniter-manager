package istic.mmm.chantier_manager_api.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "materiels")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Materiel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle;

    private String type; // outil, consommable...

    private int quantiteTotale;

    @ManyToMany(mappedBy = "materiels")
    @Builder.Default
    private Set<Chantier> chantiers = new HashSet<>();
}
