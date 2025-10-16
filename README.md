# Charity Ontology Documentation

## Overview
This project implements a semantic web solution for a charity servicing people with epilepsy. It includes enterprise-level ontology design and data integration with Wikidata.

There's also a traditional database implementation with queries in the relational-database folder.

## Skills demonstrated
This project showcases skills in:
- Semantic fundamentals: RDF/Turtle serialisation and ontologies
- SPARQL query development, including federated queries
- SHACL validation
- OWL reasoning using RDFLib
- Integration with metaphactory

- Relational database design (third normal form)
- SQL querying

## Files

- **charity_ontology.ttl** - OWL ontology defining the charity's main concepts and relationships.

- **ontology_validation.py** - Python script using RDFLib for OWL reasoning and validation.

- **charity_data.ttl** - mock data

- **charity_shapes.ttl** - SHACL shapes for data validation and business rule enforcement.

- **federated_queries.sparql** - SPARQL queries connecting epilepsy information to Wikidata.

- **relational-database/charity_schema.sql** - 3NF-compliant relationsal database schema.

- **relational-database/charity_data.sql** - mock data

- **relational-database/charity_queries.sql** - SQL queries for checking data integrity and compliance.
