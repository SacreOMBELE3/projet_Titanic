# Titanic — Guide Business Intelligence

Ce guide complète le [README principal](./README.md) et explique comment exploiter les données du projet dans Power BI pour créer un tableau de bord descriptif sur les passagers du Titanic.

## Objectif du tableau de bord

Le rapport doit permettre de répondre à des questions telles que :

- Combien de passagers sont présents dans le jeu d'entraînement ?
- Quelle part des passagers a survécu ?
- Comment le taux de survie varie-t-il selon le sexe ou la classe du billet ?
- Comment l'âge et le tarif des billets se répartissent-ils dans l'échantillon ?
- Quels ports d'embarquement sont représentés ?

Les résultats décrivent les données disponibles ; ils ne démontrent pas de lien de causalité.

## Ressources du projet

| Ressource | Rôle |
| --- | --- |
| `reports/page 1.pbix` | Rapport Power BI fourni avec le projet. |
| `data/bronze/train.csv` | Données d'entraînement, avec la colonne `Survived`. |
| `data/bronze/test.csv` | Passagers du jeu de test ; le statut de survie n'est pas fourni. |
| `data/bronze/gender_submission.csv` | Exemple de prédictions, pas une vérité terrain pour le jeu de test. |
| `sql/gold/01_create_tables.sql` | Crée la vue `gold.vw_train` à partir de `silver.train`. |

La vue `gold.vw_train` expose les colonnes suivantes :

| Colonne dans la vue | Signification |
| --- | --- |
| `PassengerID` | Identifiant du passager. |
| `Survivant` | Cible de survie : `1` = oui, `0` = non. |
| `Classe_Passager` | Classe du billet (1re, 2e ou 3e classe). |
| `Nom_Passager` | Nom du passager. |
| `Sexe` | Sexe indiqué dans les données. |
| `Age` | Âge en années. |
| `Frere_soeur_epoux_bord` | Nombre de frères, sœurs ou conjoints à bord. |
| `Parent_enfant_bord` | Nombre de parents ou d'enfants à bord. |
| `Number_ticket` | Référence du billet. |
| `Fare` | Tarif du billet. |
| `Cabin` | Cabine, lorsqu'elle est renseignée. |
| `Port_enbarquement` | Port d'embarquement. |

## Préparer la source SQL

La vue Gold lit `silver.train` dans la base `Titanic`. Avant de connecter Power BI :

1. Vérifiez que SQL Server est accessible et que la base `Titanic` contient les données de `silver.train`.
2. Créez la vue en exécutant `sql/gold/01_create_tables.sql` dans SQL Server Management Studio (SSMS).
3. Vérifiez que `gold.vw_train` retourne les données attendues.

**Attention :** le script `sql/00_init_database.sql` supprime puis recrée la base `Titanic` si elle existe. Ne l'exécutez pas sur une base contenant des données à conserver.

Les scripts et le README principal ne sont pas entièrement alignés sur le nom de la base ni sur les étapes d'initialisation. Pour ce guide, les scripts SQL existants font foi : ils utilisent la base `Titanic`.

## Connecter Power BI à SQL Server

1. Ouvrez `reports/page 1.pbix` dans Power BI Desktop, ou créez un nouveau rapport.
2. Sélectionnez **Accueil > Obtenir les données > SQL Server**.
3. Saisissez le nom du serveur et la base `Titanic`, puis choisissez le mode d'authentification autorisé dans votre environnement.
4. Sélectionnez la vue `gold.vw_train` dans le navigateur.
5. Pour ce jeu de données de taille modeste, le mode **Importer** est adapté à un rapport local. Sélectionnez **DirectQuery** seulement si votre environnement exige une interrogation directe de SQL Server.
6. Chargez la vue, vérifiez les types de données, puis actualisez le rapport après tout rechargement de Silver.

Ne placez pas de mot de passe ou de chaîne de connexion contenant des secrets dans le rapport ou dans le dépôt. Utilisez les paramètres d'identification gérés par Power BI.

## Indicateurs DAX suggérés

Créez ces mesures dans Power BI sur la table correspondant à `gold.vw_train` :

```DAX
Passagers = COUNTROWS('vw_train')

Survivants = SUM('vw_train'[Survivant])

Non-survivants = [Passagers] - [Survivants]

Taux de survie = DIVIDE([Survivants], [Passagers], 0)

Tarif moyen = AVERAGE('vw_train'[Fare])
```

Formatez **Taux de survie** en pourcentage. Si Power BI a attribué un autre nom à la table importée, remplacez `'vw_train'` par le nom affiché dans le volet **Données**. Selon les paramètres régionaux de Power BI, les séparateurs d'arguments DAX peuvent être des points-virgules plutôt que des virgules.

## Direction artistique et règles communes

Appliquez le même système visuel aux quatre pages pour donner au rapport une apparence cohérente et soignée :

| Élément | Recommandation |
| --- | --- |
| Format | Page 16:9, fond clair `#F4F6F8` et marges régulières. |
| Couleurs | Bleu nuit `#12304A` pour les titres, turquoise `#2A9D8F` pour les survivants, corail doux `#C96B64` pour les non-survivants, et gris `#64748B` pour les informations secondaires. |
| Typographie | Une seule famille sans empattement ; titres de page 24–28 pt, titres de visuels 13–16 pt, étiquettes lisibles. |
| Mise en page | Bandeau de titre en haut, filtres dans une zone stable, visuels alignés sur une grille et espacements constants. Évitez les bordures, ombres et éléments décoratifs superflus. |
| Couleurs des résultats | Gardez les mêmes couleurs pour survivant et non-survivant sur toutes les pages. Ajoutez des libellés ou des icônes : la couleur ne doit pas être le seul moyen de distinguer les catégories. |
| Contexte | Ajoutez un sous-titre explicatif, les unités, les effectifs et une note de source ou de périmètre lorsque nécessaire. |

Limitez chaque page aux visuels qui répondent à son objectif. Préférez les graphiques en barres pour comparer des catégories, triez-les dans un ordre logique et évitez les graphiques 3D ou les jauges décoratives. Utilisez des titres qui donnent le sujet et la mesure, par exemple « Taux de survie par classe » plutôt que « Graphique 1 ». N'affichez pas de courbe de tendance temporelle : ces données ne décrivent pas une série chronologique.

Gardez une navigation par boutons ou onglets avec les quatre mêmes intitulés sur chaque page. Synchronisez les segments `Sexe`, `Classe_Passager` et `Port_enbarquement` lorsque cela est pertinent ; rendez visible toute sélection active et prévoyez une façon simple de réinitialiser les filtres. Utilisez `PassengerID` comme identifiant, jamais comme indicateur.

## Structure professionnelle : 4 pages minimum

Les quatre pages ci-dessous ont chacune une finalité distincte. Utilisez une même bande de navigation et des filtres cohérents sur l'ensemble du rapport.

### Page 1 — Vue d'ensemble

**Question à laquelle elle répond :** quelle est la composition générale de l'échantillon et quelle part a survécu ?

- Bandeau : titre « Titanic — Synthèse des passagers », sous-titre « Jeu d'entraînement · 891 passagers attendus » (vérifier le nombre après actualisation).
- Première rangée : quatre cartes KPI — `Passagers`, `Survivants`, `Non-survivants` et `Taux de survie`. Formatez le taux en pourcentage et les nombres sans décimales inutiles.
- Zone principale : barres horizontales comparant survivants et non-survivants, avec nombre et pourcentage.
- Zone latérale ou basse : répartition des passagers par classe.
- Filtres : sexe, classe et port. Ajoutez un bouton « Effacer les filtres » si les segments peuvent être modifiés.
- Note de bas de page : « Données d'entraînement ; résultats descriptifs, non causaux. »

### Page 2 — Profil des passagers

**Question à laquelle elle répond :** qui compose l'échantillon ?

- Cartes compactes : âge moyen et tarif moyen, en précisant que les valeurs manquantes peuvent influencer ces mesures.
- Barres : nombre de passagers par classe, sexe et port d'embarquement.
- Histogramme : distribution des âges, avec des classes d'âge explicites et une catégorie « Non renseigné » si utile.
- Infobulles : effectif et part du total pour les catégories.
- Filtres communs : sexe, classe et port ; évitez d'ajouter un filtre sur l'identifiant ou le nom.

### Page 3 — Analyse de la survie

**Question à laquelle elle répond :** comment la survie observée varie-t-elle entre les groupes ?

- Visuel principal : taux de survie par classe, en pourcentage.
- Comparaison : taux par sexe, avec le nombre de passagers affiché dans les étiquettes ou les infobulles.
- Matrice : classe en lignes, sexe en colonnes, taux dans les valeurs et effectifs en info-bulle.
- Code couleur constant : turquoise pour survivants, corail doux pour non-survivants ; fournissez aussi les valeurs numériques.
- Filtres communs : classe, sexe et port. Rappelez que les groupes de petits effectifs doivent être interprétés avec prudence.

### Page 4 — Âge, famille et tarifs

**Question à laquelle elle répond :** quelles différences descriptives observe-t-on selon l'âge, la famille à bord et le tarif ?

- Distribution des âges par statut de survie, en affichant clairement les effectifs et le traitement des âges manquants.
- Comparaison du tarif par classe avec un diagramme en boîte si ce visuel est disponible ; sinon, utilisez des barres de médiane ou de moyenne et indiquez la mesure retenue.
- Barres ou nuage de points sur le nombre de proches à bord, construit à partir de `Frere_soeur_epoux_bord` et `Parent_enfant_bord`.
- Infobulles : âge, classe, tarif et effectif du groupe ; évitez de présenter les noms, billets ou cabines comme catégories principales.
- Note d'interprétation : ces associations ne prouvent pas de causalité.

Avant publication, vérifiez l'alignement des visuels, les titres, les unités, les filtres réinitialisés, le contraste des textes et la lisibilité à taille normale. Une page de détail peut être ajoutée, mais ne remplace pas ces quatre pages d'analyse.

## Limites d'interprétation

- `gold.vw_train` est fondée sur le jeu d'entraînement et contient la cible `Survivant`. Les mesures de survie ne s'appliquent donc pas au jeu de test.
- `gender_submission.csv` fournit une baseline de prédictions ; elle ne permet pas de mesurer la justesse des prédictions sans les étiquettes réelles.
- Les comparaisons par classe, sexe, âge ou tarif sont descriptives et ne prouvent pas de causalité.
- `Name`, `Number_ticket` et `Cabin` sont des attributs de détail ; évitez de les utiliser comme catégories principales avec de nombreux éléments distincts.
- La vue présente les valeurs de Silver telles qu'elles sont stockées. Vérifiez le traitement des valeurs manquantes avant de publier des graphiques sur l'âge, le tarif ou le port.

## Actualiser et partager

Après la mise à jour des données SQL, actualisez le modèle dans Power BI Desktop et vérifiez les totaux ainsi que les filtres avant de publier ou de partager le rapport. La connexion à SQL Server et les droits d'accès doivent être configurés pour chaque environnement de publication.
