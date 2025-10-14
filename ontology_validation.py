# ontology validation

import rdflib
from rdflib import Graph, Namespace, RDF, RDFS, OWL
import sys
import os

CHARITY = Namespace("https://ontology.charity.org/")

class ontologyValidator:
    def __init__(self, ontology_file):
        self.graph = Graph()
        try:
            self.graph.parse(ontology_file, format="turtle")
            print(f"Loaded ontology: {len(self.graph)} triples")
        except Exception as e:
            print(f"Error loading ontology: {e}")
            sys.exit(1)

    #checks for basic OWL structure
    def validate_syntax(self):
        classes = list(self.graph.subjects(RDF.type, OWL.Class))
        properties = list(self.graph.subjects(RDF.type, OWL.ObjectProperty))
        data_props = list(self.graph.subjects(RDF.type, OWL.DatatypeProperty))
        
        print(f"Classes: {len(classes)}, Object properties: {len(properties)}, Datatype properties: {len(data_props)}")
        
        issues = []
        if len(classes) == 0:
            issues.append("No OWL classes defined")
        return issues

   # checks for circular inheritance
    def validate_consistency(self):
        def has_cycle(cls, visited, rec_stack):
            visited.add(cls)
            rec_stack.add(cls)
            
            for subclass in self.graph.objects(cls, RDFS.subClassOf):
                if subclass not in visited:
                    if has_cycle(subclass, visited, rec_stack):
                        return True
                elif subclass in rec_stack:
                    return True
            
            rec_stack.remove(cls)
            return False
        
        visited = set()
        for cls in self.graph.subjects(RDF.type, OWL.Class):
            if cls not in visited:
                if has_cycle(cls, visited, set()):
                    return [f"Circular inheritance detected: {cls}"]
        
        return []

    #checks domain/range completeness
    def validate_completeness(self):
        issues = []
        
        for prop in self.graph.subjects(RDF.type, OWL.ObjectProperty):
            if not list(self.graph.objects(prop, RDFS.domain)):
                issues.append(f"Property missing domain: {prop}")
            if not list(self.graph.objects(prop, RDFS.range)):
                issues.append(f"Property missing range: {prop}")
        
        return issues

    # generates validation report
    def generate_report(self):
        print("Ontology Validation Report")
        print("=" * 40)
        
        syntax_issues = self.validate_syntax()
        consistency_issues = self.validate_consistency()
        completeness_issues = self.validate_completeness()
        
        total_issues = len(syntax_issues) + len(consistency_issues) + len(completeness_issues)
        
        if total_issues == 0:
            print("Validation passed: No critical issues found.")
        else:
            print(f"Issues found: {total_issues}")
            for issue in syntax_issues + consistency_issues + completeness_issues:
                print(f"- {issue}")
        
        print("Validation complete.")

def main():
    ontology_file = "charity_ontology.ttl"
    
    if not os.path.exists(ontology_file):
        print(f"Ontology file not found: {ontology_file}")
        sys.exit(1)
    
    validator = ontologyValidator(ontology_file)
    validator.generate_report()

if __name__ == "__main__":
    main()