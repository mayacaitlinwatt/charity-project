# Charity ontology documentation

## Overview
This project implements a semantic web solution for a charity servicing people with epilepsy. It includes enterprise-level ontology design and data integration. 

## Skills demonstrated
This project showcases skills in:
- Semantic fundamentals: RDF/Turtle serialisation and OWL ontologies
- SPARQL query development, including federated queries for external data integration
- SHACL validation for enforcing business rules
- OWL reasoning using RDFLib for logical consistency checks
- Relational database design (third normal form) with SQL queries
- Integration with the semantic web platform metaphactory

## Files

- **charity_ontology.ttl** - OWL ontology defining the charity's main concepts and relationships.

- **ontology_validation.py** - Python script using RDFLib for OWL reasoning and validation.

- **charity_shapes.ttl** - SHACL shapes for data validation and business rule enforcement.

- **federated_queries.sparql** - SPARQL queries connecting epilepsy instances to epilepsy information in the Wikidata database.

- **charity_schema.sql** - 3NF-compliant relationsal database schema.

- **charity_queries.sql** - SQL queries for checking data integrity and compliance.

## Testing
Sample datasets are provided in the 'data/' folder for testing scripts:

- **charity_data.ttl**: RDF test data in Turtle format (load into metaphactory or a triple store, along with charity_ontology.ttl)

- **charity_data.sql**: SQL test data
