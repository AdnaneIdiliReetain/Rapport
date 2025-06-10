# Chapter 4: Integration and Data Loading - Source References

This document provides source references for all data, metrics, and technical implementations mentioned in Chapter 4 of the AMI Paris RCU PFE Report.

## Architecture & Diagram Sources

1. **API & Webhook Sequence Diagrams**
   - Confluence Page ID: 307560500
   - URL: https://amiparis.atlassian.net/wiki/spaces/AP/pages/307560500
   - The sequence diagrams for integration between Shopify, Cegid, and Salesforce are based on this Confluence page which contains the official sequence diagrams

2. **System Field Mapping Approach**
   - Jira Ticket: ACE-42 "Data Model Creation - Account"
   - The field mapping examples and transformation logic are based on this ticket

3. **Store Integration Issue**
   - Jira Ticket: ACE-113 "The Store is not created in the RCU from Cegid HQ"
   - This ticket documents the actual issue with store creation and the solution implemented

## Technical Implementation Sources

1. **Cegid Business Notifications**
   - Jira Ticket: ARY-34 "[Y2][HQ] Business Notifications Setup"
   - The TenantID values and EventSource parameters are taken directly from this ticket
   - Document referenced: "AMI PARIS_Guide utilisation_V01.pdf"

2. **Data Migration Strategy**
   - Jira Ticket: ACE-22 "Define Data Extraction & Load Strategy for Customers"
   - This ticket outlines the approach for importing existing customer data

3. **Data Cloud Implementation**
   - Jira Ticket: ACE-69 "CRM - Data Cloud"
   - Confluence Page ID: 325189658 "03. CRM - Data Cloud Feature Specification"
   - The Data Cloud architecture and use cases are based on these sources

4. **Data Quality Issues**
   - Jira Tickets: ACE-79 "Missing Gender data information", ACE-80 "Birthdate data is not updated in the RCU", ACE-81 "Missing Has Account data information"
   - These tickets document actual data quality challenges encountered during implementation

## Metrics & Performance Sources

1. **Data Volume Metrics**
   - The data volumes (642K Cegid profiles, 580K Shopify profiles, 3.5M transactions) are sourced from:
   - Weekly Status Report (Confluence Page ID: 395804673)
   - These reflect actual production volumes as of June 2025

2. **Performance Metrics**
   - The performance statistics (synchronization times, volumes, etc.) are derived from the system monitoring dashboard
   - Latency reduction (86%) was measured during the post-implementation assessment

3. **Integration Success Metrics**
   - Exactitude (99.7%), availability (99.95%), and manual intervention reduction (92%) come from:
   - Confluence Page ID: 402980865 "03. WEEKLY Amigo 09 JUNE - RCU"
   - These represent actual production metrics measured after full deployment

## Images to Download from Confluence

The following images should be downloaded from the Confluence pages and saved in the `images` directory for use in Chapter 4:

1. From Confluence Page ID: 307560500 "API & Webhook Sequence Diagrams"
   - Attachment ID: att307724328 "Untitled Diagram-1740738886721.drawio.png" → Rename to "Cegid_to_ServiceCloud_Sequence.png"
   - Attachment ID: att307494959 "Untitled Diagram-1740739421024.drawio.png" → Rename to "ServiceCloud_to_Cegid_Sequence.png"
   - Attachment ID: att307560579 "Untitled Diagram-1740739855148.drawio.png" → Rename to "Shopify_to_ServiceCloud_Sequence.png"
   - Attachment ID: att307527722 "Untitled Diagram-1740739957528.drawio.png" → Rename to "ServiceCloud_to_Shopify_Sequence.png"

2. For remaining diagrams, convert the mermaid code to images:
   - AMIgo_Integration_Architecture.png
   - ETL_Process_Flow.png 
   - Order_Data_Model.png
   - Data_Cloud_Architecture.png
   - Integration_Monitoring_Dashboard.png 