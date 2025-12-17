package istic.mmm.chantier_manager_api.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "equipes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Equipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;

    // Chef de l’équipe (utilisateur avec rôle CHEF_CHANTIER normalement)
    @ManyToOne
    @JoinColumn(name = "chef_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Utilisateur chef;

    // Membres de l’équipe (équipiers)
    @ManyToMany
    @JoinTable(
            name = "equipes_membres",
            joinColumns = @JoinColumn(name = "equipe_id"),
            inverseJoinColumns = @JoinColumn(name = "utilisateur_id")
    )
    @Builder.Default
    private Set<Utilisateur> membres = new HashSet<>();

    // Chantiers affectés à cette équipe
    @OneToMany(mappedBy = "equipe")
    @Builder.Default
    @JsonIgnore
    private Set<Chantier> chantiers = new HashSet<>();
}
