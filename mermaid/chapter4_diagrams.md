# Mermaid Diagrams for Chapter 4

## AMIgo_Integration_Architecture

```mermaid
flowchart TB
    subgraph External_Systems
        Shopify[Shopify\nE-commerce]
        CegidY2_HQ[Cegid Y2\nHQ]
        CegidY2_JP[Cegid Y2\nJapan]
    end
    
    subgraph Salesforce_Ecosystem
        RCU[Référentiel Client Unifié\nSalesforce Service Cloud]
        DataCloud[Salesforce\nData Cloud]
        MCE[Marketing Cloud\nEngagement]
    end
    
    Shopify -->|Webhooks| RCU
    RCU -->|API Calls| Shopify
    
    CegidY2_HQ -->|Business Notifications| RCU
    RCU -->|API Calls| CegidY2_HQ
    
    CegidY2_JP -->|Business Notifications| RCU
    RCU -->|API Calls| CegidY2_JP
    
    RCU <-->|Data Sync| DataCloud
    RCU <-->|Contact Sync| MCE
    
    DataCloud <-.->|Insights| MCE
    
    classDef primary fill:#f9f,stroke:#333,stroke-width:2px
    class RCU primary
```

## Cegid_to_ServiceCloud_Sequence

```mermaid
sequenceDiagram
    participant Cegid
    participant Webhook
    participant ServiceCloud
    
    Cegid->>Webhook: 1. HTTP Post
    Webhook-->>Cegid: ResponseMessage
    Webhook->>ServiceCloud: 2. JSON Payload
    activate ServiceCloud
    ServiceCloud->>ServiceCloud: EventListener()
    ServiceCloud-->>Webhook: 2a. Authorize
    Webhook-->>ServiceCloud: 2b. Return Token
    ServiceCloud->>Cegid: 3. API - GET CallbackURL
    Cegid-->>ServiceCloud: 4.RequestResponse
    ServiceCloud->>ServiceCloud: Insert() or Update()
    deactivate ServiceCloud
```

## ServiceCloud_to_Cegid_Sequence

```mermaid
sequenceDiagram
    participant ServiceCloud
    participant API_Gateway
    participant Cegid
    
    activate ServiceCloud
    ServiceCloud->>ServiceCloud: Account Trigger
    ServiceCloud->>API_Gateway: 1. HTTP Request with Auth Token
    API_Gateway->>Cegid: 2. Transformed REST API Call
    Cegid-->>API_Gateway: 3. Response
    API_Gateway-->>ServiceCloud: 4. Status Code & Response
    ServiceCloud->>ServiceCloud: Log Result
    deactivate ServiceCloud
```

## Shopify_to_ServiceCloud_Sequence

```mermaid
sequenceDiagram
    participant Shopify
    participant WebhookEndpoint
    participant ServiceCloud
    
    Shopify->>WebhookEndpoint: 1. HTTP POST (Customer/Order Event)
    WebhookEndpoint-->>Shopify: 200 OK Response
    WebhookEndpoint->>ServiceCloud: 2. Process Webhook Payload
    activate ServiceCloud
    ServiceCloud->>ServiceCloud: Transform Data via SystemFieldMapping
    ServiceCloud->>ServiceCloud: Match & Deduplicate Records
    ServiceCloud->>ServiceCloud: Create/Update Records
    ServiceCloud->>ServiceCloud: Log Transaction
    deactivate ServiceCloud
```

## ServiceCloud_to_Shopify_Sequence

```mermaid
sequenceDiagram
    participant ServiceCloud
    participant ShopifySyncService
    participant Shopify
    
    activate ServiceCloud
    ServiceCloud->>ServiceCloud: Account Trigger
    ServiceCloud->>ShopifySyncService: Sync Request (Account with ShopifyID)
    ShopifySyncService->>Shopify: 1. REST API Call with OAuth
    Shopify-->>ShopifySyncService: 2. Response
    ShopifySyncService-->>ServiceCloud: 3. Process Result
    ServiceCloud->>ServiceCloud: Log Sync Status
    deactivate ServiceCloud
```

## ETL_Process_Flow

```mermaid
flowchart TD
    subgraph "Extraction Phase"
        CegidExtractor[CegidCustomerExtractor]
        ShopifyExtractor[ShopifyCustomerExtractor]
    end
    
    subgraph "Transformation Phase"
        Normalization[Name/Email/Phone\nNormalization]
        Enrichment[Data Enrichment]
        Deduplication[Preliminary\nDeduplication]
    end
    
    subgraph "Loading Phase"
        BulkAPI[Bulk API 2.0]
        ValidationRules[Validation Rules]
        Logging[Error Logging]
    end
    
    CegidExtractor --> |Raw Data| Normalization
    ShopifyExtractor --> |Raw Data| Normalization
    
    Normalization --> Enrichment
    Enrichment --> Deduplication
    Deduplication --> BulkAPI
    
    BulkAPI --> ValidationRules
    ValidationRules --> |Success| Logging
    ValidationRules --> |Failure| Normalization
    
    classDef extraction fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef transformation fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    classDef loading fill:#fff8e1,stroke:#ff8f00,stroke-width:2px
    
    class CegidExtractor,ShopifyExtractor extraction
    class Normalization,Enrichment,Deduplication transformation
    class BulkAPI,ValidationRules,Logging loading
```

## Order_Data_Model

```mermaid
erDiagram
    ACCOUNT ||--o{ ORDER : places
    ORDER ||--o{ ORDER_ITEM : contains
    ORDER_ITEM }o--|| PRODUCT : references
    ORDER ||--o{ PAYMENT : has
    
    ACCOUNT {
        string Id
        string FirstName
        string LastName
        string Email
        string CustomerTier
        string PreferredStore
    }
    
    ORDER {
        string Id
        string OrderNumber
        date OrderDate
        decimal TotalAmount
        string Channel
        string Currency
        string Status
        string BillingAddress
        string ShippingAddress
    }
    
    ORDER_ITEM {
        string Id
        string OrderId
        string ProductId
        int Quantity
        decimal UnitPrice
        decimal TotalPrice
        decimal Discount
        decimal Tax
        string Size
        string Color
    }
    
    PRODUCT {
        string Id
        string SKU
        string Name
        string Category
        string Collection
        string Season
        string Gender
        string Description
    }
    
    PAYMENT {
        string Id
        string OrderId
        string Method
        decimal Amount
        string Status
        date Date
        string TransactionID
        string Currency
    }
```

## Data_Cloud_Architecture

```mermaid
flowchart TD
    subgraph DataSources["Data Sources"]
        direction LR
        CRM["Salesforce CRM"]
        Shopify["Shopify"]
        CegidY2["Cegid Y2"]
        Marketing["Marketing Cloud"]
        Web["Web Interactions"]
    end
    
    subgraph DataCloud["Salesforce Data Cloud"]
        direction LR
        DataLake["Data Lake"]
        IDResolution["Identity Resolution"]
        DataModel["Unified Data Model"]
        Segments["Segmentation Engine"]
        Metrics["Calculated Metrics"]
    end
    
    subgraph Activation["Activation Layer"]
        direction LR
        MCJourneys["Marketing Journeys"]
        ClientelingApp["Clienteling App"]
        PersonalizationEngine["Personalization Engine"]
    end
    
    CRM --> DataLake
    Shopify --> DataLake
    CegidY2 --> DataLake
    Marketing --> DataLake
    Web --> DataLake
    
    DataLake --> IDResolution
    IDResolution --> DataModel
    DataModel --> Segments
    DataModel --> Metrics
    
    Segments --> MCJourneys
    Segments --> ClientelingApp
    Segments --> PersonalizationEngine
    
    Metrics --> MCJourneys
    Metrics --> ClientelingApp
    Metrics --> PersonalizationEngine
    
    classDef sources fill:#e3f2fd,stroke:#1565c0,stroke-width:1px
    classDef datacloud fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef activation fill:#f9fbe7,stroke:#827717,stroke-width:1px
    
    class CRM,Shopify,CegidY2,Marketing,Web sources
    class DataLake,IDResolution,DataModel,Segments,Metrics datacloud
    class MCJourneys,ClientelingApp,PersonalizationEngine activation
```

## Integration_Monitoring_Dashboard

```mermaid
graph TB
    subgraph Dashboard
        direction LR
        
        subgraph VolumeMetrics["Volume Metrics"]
            VM1[Daily Transaction Volume]
            VM2[Source System Breakdown]
            VM3[Peak Hour Analysis]
        end
        
        subgraph PerformanceMetrics["Performance Metrics"]
            PM1[Avg Response Time]
            PM2[SLA Compliance]
            PM3[Error Rate]
        end
        
        subgraph Alerts["Real-time Alerts"]
            A1[Critical Errors]
            A2[Performance Degradation]
            A3[System Availability]
        end
        
        subgraph TrendAnalysis["Trend Analysis"]
            TA1[Weekly Volume Trend]
            TA2[Monthly Success Rate]
            TA3[Top Error Types]
        end
    end
    
    classDef metrics fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px
    classDef performance fill:#e1f5fe,stroke:#0277bd,stroke-width:1px
    classDef alerts fill:#ffebee,stroke:#c62828,stroke-width:1px
    classDef trends fill:#fff8e1,stroke:#ff8f00,stroke-width:1px
    
    class VM1,VM2,VM3 metrics
    class PM1,PM2,PM3 performance
    class A1,A2,A3 alerts
    class TA1,TA2,TA3 trends
``` 