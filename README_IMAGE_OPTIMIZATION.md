# Guide d'Optimisation des Images pour le Rapport PFE

Ce guide explique comment utiliser le système d'optimisation d'images mis en place pour améliorer la vitesse de compilation du rapport LaTeX.

## Prérequis

Pour utiliser le script d'optimisation d'images, vous devez installer ImageMagick:
1. Téléchargez et installez ImageMagick depuis: https://imagemagick.org/script/download.php
2. Assurez-vous que la commande `magick` est disponible dans votre terminal

## Utilisation du Script d'Optimisation

### Option 1: Optimisation séparée des images

Pour optimiser toutes les images sans compiler le document:

```powershell
.\compress_images.ps1
```

Ce script:
- Analyse tous les fichiers images dans le dossier `latex\images`
- Crée des versions optimisées dans `latex\images_optimized`
- Compresse et rasterise les images pour une meilleure performance

### Option 2: Optimisation lors de la compilation

Le script `fast.ps1` a été amélioré avec plusieurs options:

```powershell
# Compilation rapide standard
.\fast.ps1

# Compilation avec optimisation des images
.\fast.ps1 -OptimizeImages

# Compilation complète (non-draft)
.\fast.ps1 -Draft:$false

# Nettoyage des fichiers auxiliaires avant compilation
.\fast.ps1 -Clean
```

Vous pouvez combiner ces options:
```powershell
# Optimisation des images, nettoyage et compilation complète
.\fast.ps1 -OptimizeImages -Clean -Draft:$false
```

## Comment ça fonctionne

1. Les images sont redimensionnées à une taille maximale de 1200x1200 pixels
2. La résolution est fixée à 150 DPI (bon équilibre qualité/taille)
3. La qualité JPEG est réglée à 85% (compression efficace sans perte visible)
4. Les métadonnées sont supprimées pour réduire la taille
5. Les canaux alpha sont retirés pour une meilleure compatibilité PDF

Le fichier `main.tex` a été configuré pour chercher d'abord les images dans le dossier `images_optimized` avant d'utiliser les originales dans `images`.

## Avantages

- **Compilation plus rapide**: Les images optimisées accélèrent considérablement la compilation
- **PDF plus léger**: Le document final sera plus petit et plus facile à partager
- **Meilleure performance**: Moins de risques de problèmes de mémoire lors de la compilation
- **Processus non-destructif**: Les images originales restent intactes

## Remarques

- La première optimisation peut prendre du temps selon le nombre d'images
- Les optimisations suivantes seront plus rapides car seules les nouvelles images seront traitées
- Pour les images très complexes, vous pouvez ajuster les paramètres dans le script `compress_images.ps1`
