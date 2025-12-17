package istic.mmm.chantier_manager_api.config;

import istic.mmm.chantier_manager_api.entities.Chantier;
import istic.mmm.chantier_manager_api.entities.Equipe;
import istic.mmm.chantier_manager_api.entities.Utilisateur;
import istic.mmm.chantier_manager_api.entities.StatutChantier;
import istic.mmm.chantier_manager_api.repositories.ChantierRepository;
import istic.mmm.chantier_manager_api.repositories.EquipeRepository;
import istic.mmm.chantier_manager_api.repositories.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;

@Configuration
@RequiredArgsConstructor
public class DataInitializer {

    private final UtilisateurRepository utilisateurRepository;
    private final ChantierRepository chantierRepository;
    private final EquipeRepository equipeRepository;

    @Bean
    public CommandLineRunner initData() {
        return args -> {
            // S'il y a déjà des chantiers, on ne fait rien
            if (chantierRepository.count() > 0) {
                return;
            }

            // ⚠️ adapte cet email à celui que TU utilises vraiment
            String chefEmail = "jean.dupont@example.com";

            Utilisateur chef = utilisateurRepository.findByEmail(chefEmail)
                    .orElse(null);

            if (chef == null) {
                System.out.println("=== [DataInitializer] Aucun utilisateur chef avec l'email "
                        + chefEmail + " -> on ne crée PAS de chantiers ===");
                return;
            }

            // Création d'une équipe simple
            Equipe equipeA = new Equipe();
            equipeA.setNom("Équipe A");
            equipeA = equipeRepository.save(equipeA);

            // Chantier 1
            Chantier c1 = new Chantier();
            c1.setObjet("Rénovation bureaux Rennes");
            c1.setLieu("Rennes");
            c1.setDateDebut(LocalDate.of(2025, 11, 20));
            c1.setNbDemiJournees(6);
            c1.setContactClientNom("Entreprise ABC");
            c1.setContactClientTelephone("0601020304");
            c1.setStatut(StatutChantier.EN_COURS);
            c1.setChef(chef);
            c1.setEquipe(equipeA);
            chantierRepository.save(c1);

            // Chantier 2
            Chantier c2 = new Chantier();
            c2.setObjet("Réfection toiture entrepôt");
            c2.setLieu("St-Malo");
            c2.setDateDebut(LocalDate.of(2025, 12, 1));
            c2.setNbDemiJournees(10);
            c2.setContactClientNom("Logistique Ouest");
            c2.setContactClientTelephone("0605060708");
            c2.setStatut(StatutChantier.NON_REALISE);
            c2.setChef(chef);
            c2.setEquipe(equipeA);
            chantierRepository.save(c2);

            // Chantier 3
            Chantier c3 = new Chantier();
            c3.setObjet("Aménagement boutique centre-ville");
            c3.setLieu("Rennes");
            c3.setDateDebut(LocalDate.of(2025, 10, 5));
            c3.setNbDemiJournees(4);
            c3.setContactClientNom("Boutique Luma");
            c3.setContactClientTelephone("0611223344");
            c3.setStatut(StatutChantier.TERMINE);
            c3.setChef(chef);
            c3.setEquipe(equipeA);
            chantierRepository.save(c3);

            System.out.println("=== [DataInitializer] 3 chantiers de démo créés ===");
        };
    }
}
