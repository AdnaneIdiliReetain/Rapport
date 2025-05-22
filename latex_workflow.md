# Documentation du Workflow LaTeX pour le Rapport PFE

Ce document détaille le workflow LaTeX mis en place pour la génération du rapport PFE basé sur le modèle d'Ayoub. Il spécifie les fichiers utilisés, leur rôle, et les fichiers qui ne sont pas actuellement utilisés.

## Structure du Projet LaTeX

```
Project_PFE_Windsurf/
├── latex/                      # Répertoire principal pour les fichiers LaTeX
│   ├── main.tex                # Fichier principal du document LaTeX
│   ├── chapters/               # Répertoire contenant les chapitres du rapport
│   │   ├── chapitre1.tex       # Chapitre 1 (non utilisé actuellement)
│   │   ├── chapitre2.tex       # Chapitre 2 (AMIgo Client Engagement 2.0)
│   ├── references.bib          # Fichier de références bibliographiques
├── images/                     # Répertoire pour les images
│   ├── logos/                  # Logos utilisés dans le rapport
│   │   ├── logo_ami.png        # Logo AMI Paris
│   │   ├── logo_reetain.png    # Logo Reetain
│   │   ├── logo_school.png     # Logo de l'école
├── convert_to_latex.bat        # Script pour convertir le contenu Markdown en LaTeX
├── generate_latex_report.bat   # Script pour compiler le document LaTeX en PDF
└── src/
    └── convert_to_latex.py     # Script Python pour la conversion Markdown vers LaTeX
```

## Fichiers Actifs et Leur Rôle

### Fichiers LaTeX Principaux

| Fichier | Statut | Description |
|---------|--------|-------------|
| `latex/main.tex` | **ACTIF** | Fichier principal qui définit la structure du document, les packages utilisés, et inclut tous les chapitres. Contient également la page de couverture et les pages préliminaires. |
| `latex/chapters/chapitre2.tex` | **ACTIF** | Contient le chapitre sur AMIgo Client Engagement 2.0, incluant l'évolution du projet, l'architecture technique, les fonctionnalités innovantes, etc. |
| `latex/references.bib` | **ACTIF** | Fichier BibTeX contenant les références bibliographiques pour le rapport. |

### Scripts et Fichiers de Support

| Fichier | Statut | Description |
|---------|--------|-------------|
| `convert_to_latex.bat` | **ACTIF** | Script batch qui exécute le script Python pour convertir le contenu Markdown en LaTeX. |
| `generate_latex_report.bat` | **ACTIF** | Script batch qui compile le document LaTeX en PDF en utilisant pdflatex et bibtex. |
| `src/convert_to_latex.py` | **ACTIF** | Script Python qui convertit le contenu Markdown en LaTeX, crée la structure de répertoires, et prépare les fichiers nécessaires. |

### Ressources

| Fichier | Statut | Description |
|---------|--------|-------------|
| `images/logos/logo_ami.png` | **ACTIF** | Logo AMI Paris utilisé dans la page de couverture. |
| `images/logos/logo_school.png` | **ACTIF** | Logo de l'école utilisé dans la page de couverture. |
| `images/logos/logo_reetain.png` | **INACTIF** | Logo Reetain disponible mais non utilisé actuellement dans le rapport. |

## Fichiers Inactifs ou En Attente

| Fichier | Statut | Description |
|---------|--------|-------------|
| `latex/chapters/chapitre1.tex` | **INACTIF** | Fichier créé mais commenté dans main.tex. Contient une structure de base pour le chapitre 1 mais n'est pas actuellement inclus dans la compilation. |
| `latex/chapters/chapitre3.tex` | **NON CRÉÉ** | Référencé dans main.tex (commenté) mais pas encore créé. Prévu pour contenir l'analyse métier. |
| `latex/chapters/chapitre4.tex` | **NON CRÉÉ** | Référencé dans main.tex (commenté) mais pas encore créé. Prévu pour contenir l'architecture technique détaillée. |

## Workflow de Compilation

Le workflow de compilation du rapport LaTeX suit ces étapes :

1. **Préparation du contenu** :
   - Création/édition des fichiers de chapitres dans `latex/chapters/`
   - Mise à jour du fichier principal `main.tex` si nécessaire

2. **Compilation du document** :
   - Exécution de `generate_latex_report.bat` qui lance la séquence :
     - `pdflatex main.tex` (première passe)
     - `bibtex main` (traitement des références)
     - `pdflatex main.tex` (deuxième passe)
     - `pdflatex main.tex` (troisième passe pour résoudre toutes les références)

3. **Résultat** :
   - Le fichier PDF final est généré dans le répertoire `latex/` sous le nom `main.pdf`

## Conversion Markdown vers LaTeX

Si vous avez du contenu en format Markdown que vous souhaitez convertir en LaTeX :

1. Placez vos fichiers Markdown dans `data/markdown/fr/` (pour le français) ou `data/markdown/en/` (pour l'anglais)
2. Exécutez `convert_to_latex.bat`
3. Les fichiers LaTeX générés seront placés dans `latex/chapters/`

## Problèmes Connus et Solutions

1. **Erreur de chemin pour les chapitres** :
   - Problème : Les chemins dans `\input{latex/chapters/...}` sont incorrects
   - Solution : Utilisez `\input{chapters/...}` car la compilation se fait depuis le répertoire `latex/`

2. **Erreurs liées aux packages manquants** :
   - Problème : Certains packages LaTeX peuvent être manquants lors de la compilation
   - Solution : Installez les packages manquants via le gestionnaire MiKTeX

3. **Erreurs avec les commandes de couleur** :
   - Problème : Erreurs avec `\rowcolor` et autres commandes de couleur
   - Solution : Assurez-vous que le package `colortbl` est chargé avant d'utiliser ces commandes

## Prochaines Étapes

1. Créer les chapitres manquants (3, 4, 5, 6)
2. Ajouter des diagrammes techniques dans les chapitres appropriés
3. Compléter les références bibliographiques
4. Finaliser les annexes
5. Ajouter un glossaire et une liste d'abréviations

## Remarques

- Le workflow LaTeX est conçu pour être modulaire, permettant l'ajout facile de nouveaux chapitres
- Les styles et la mise en page sont configurés dans `main.tex` pour maintenir une cohérence visuelle
- Pour ajouter de nouvelles images, placez-les dans `images/` et référencez-les avec le chemin relatif approprié
