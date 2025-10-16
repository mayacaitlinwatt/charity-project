# Charity Ontology Documentation

## Overview
This project implements a semantic web solution for a charity servicing people with epilepsy. It includes enterprise-level ontology design and data integration with Wikidata.

There's also a traditional database implementation with queries in the relational-database folder.

## Files

- **charity_ontology.ttl** - OWL ontology defining the charity's main concepts and relationships, written in Turtle.

- **ontology_validation.py** - Python script using RDFLib for OWL reasoning and validation.

- **charity_data.ttl** - data, instantiated using Turtle.

- **charity_shapes.ttl** - SHACL shapes for data validation and business rule enforcement.

- **federated_queries.sparql** - federated SPARQL queries connecting information to Wikidata.

- **relational-database/charity_schema.sql** - 3NF-compliant relational database schema.

- **relational-database/charity_data.sql** - data.

- **relational-database/charity_queries.sql** - SQL queries for checking data integrity and compliance.

## Implementation
charity_ontology.ttl, charity_data.ttl and charity_shapes.ttl can be uploaded and validated in metaphactory, along with the queries in federated_queries.sparql, which can be copy-pasted into metaphactory's SPARQL UI.
