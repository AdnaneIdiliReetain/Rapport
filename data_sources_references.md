# Sources des données analytiques et métriques

Ce document référence les sources de toutes les données quantitatives et métriques utilisées dans le rapport.

## Chapitre 3: RCU - Métriques de fusion des données

### Profils clients et complétude

| Métrique | Valeur | Source |
|----------|--------|--------|
| Comptes incomplets avant fusion | 32% | Analyse de la base client Salesforce (Sept 2024) - Rapport "Data Quality Dashboard" |
| Comptes complets avant fusion | 68% | Analyse de la base client Salesforce (Sept 2024) - Rapport "Data Quality Dashboard" |
| Comptes incomplets après fusion | 9% | Analyse de la base client Salesforce (Déc 2024) - Rapport "Data Quality Dashboard" |
| Comptes complets après fusion | 91% | Analyse de la base client Salesforce (Déc 2024) - Rapport "Data Quality Dashboard" |

### Identification des doublons

| Métrique | Valeur | Source |
|----------|--------|--------|
| Total doublons identifiés | 17.8% | Rapport "Merge Audit Analysis Q4-2024" - p.7 |
| Fusion automatique | 12.4% | Rapport "Merge Audit Analysis Q4-2024" - p.12 |
| Validation manuelle | 5.4% | Rapport "Merge Audit Analysis Q4-2024" - p.12 |
| Non doublons | 82.2% | Calculé (100% - 17.8%) |

### Gains opérationnels

| Métrique | Avant | Après | Variation | Source |
|----------|-------|-------|-----------|--------|
| Temps de gestion manuelle (h/semaine) | 19.5 | 3.1 | -84% | Entretiens équipe CRM (Nov 2024) et suivi d'activité |
| Valeur client moyenne (€) | 720€ | 878€ | +22% | Tableau de bord "Customer Analytics Q3-Q4 2024" |
| Taux de contacts email réussis | 62% | 88% | +26% | Rapport Marketing Cloud "Email Campaign Effectiveness" (Déc 2024) |
| Taux d'identification en boutique | 51% | 79% | +28% | Données Cegid Y2 et rapport "In-Store Recognition" (Jan 2025) |

### Seuils de correspondance

| Paramètre | Valeur | Source |
|-----------|--------|--------|
| Seuil fusion automatique | >=85% | Configuration AccountTriggerHandler (ligne 142) |
| Seuil validation manuelle | >=70% | Configuration AccountTriggerHandler (ligne 145) |
| Seuil absence action | <70% | Configuration AccountTriggerHandler (ligne 148) |

## Autres sources de données

- **Jira**: Ticket ACE-44 "CRM RCU - Data Merge Process"
- **Confluence**: Pages "CRM RCU DATA MODEL" (ID: 271253536) et "Merge Process - Data Cloud Supporting Features" (ID: 326369294)
- **Salesforce**: Objet MergeAudit__c pour le suivi des opérations de fusion
- **Interviews**: Sessions avec l'équipe CRM (Oct-Nov 2024) sur les processus manuels de résolution des doublons 