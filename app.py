import os
import py2neo
from flask import Flask

app = Flask(__name__)

STATEMENT_PEOPLE_FRAMEWORKS = """
MATCH
  (dept:Department {name: "IT Department"})
   <-[:WORKS_AT]-(people:Person)-[:LIKES]->
  (framework:Framework)
RETURN framework.name, people.name
ORDER BY framework.name
"""

STATEMENT_RECOMMEND = """
MATCH (subject:Person)
WHERE subject.name=$person_name

MATCH
     (dept:Department {name: "IT Department"})
     -[:WORKS_AT]-
     (people:Person)
     -[:LIKES]-
     (likeable_framework:Framework)
     -[:LANGUAGE]-
     (:Language {name: "Python"})

WHERE NOT (subject)-[:LIKES]->(likeable_framework)

RETURN DISTINCT likeable_framework.name
"""

graph = py2neo.Graph("bolt://localhost:7687", password=os.getenv("PASSWORD"))


@app.route("/")
def people():
    results = graph.run(STATEMENT_PEOPLE_FRAMEWORKS).data()
    display, framework = "", ""
    for result in results:
        if not framework == result["framework.name"]:
            prefix = "<br>"
        else:
            prefix = ""
        framework = result["framework.name"]
        display = display + f"""{prefix}<div><b>{result['people.name']}</b> likes <b>{framework}</b></div>\n"""

    display = display + "</p>"
    for result in graph.match(r_type="WORKS_AT").all():
        name = result.nodes[0]["name"]
        display = display + f"""<div>Recommend framework for <a href="/recommend_framework/{name}">{name}</a></div>\n"""
    display = display + "</p>"
    return display


@app.route("/recommend_framework/<person_name>")
def recommend(person_name):
    recommendation = graph.run(STATEMENT_RECOMMEND, person_name=person_name).data()
    if recommendation:
        return f"""<div><b>{person_name}</b> should try: <b>{recommendation[0]['likeable_framework.name']}</b></div>"""
    else:
        return "No recommendations!"
