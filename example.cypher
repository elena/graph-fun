// Create Python
CREATE (guido:Person {name: "Guido"})
CREATE (python:Language {name: "Python"})
CREATE (guido)-[:CREATED]->(python)
RETURN guido, python

// --  Create Web Frameworks and authors

// Create Flask and connect to Python
MATCH (guido:Person {name: "Guido"})
MATCH (python:Language {name: "Python"})
CREATE (armin:Person {name: "Armin"})
CREATE (flask:Software:Framework {name: "Flask"})
CREATE (armin)-[:CREATED]->(flask)
CREATE (flask)-[:LANGUAGE]->(python)

// Create Django and connect to Python
CREATE (simon:Person {name: "Simon"})
CREATE (adrian:Person {name: "Adrian"})
CREATE (jacob:Person {name: "Jacob"})
CREATE (django:Software:Framework {name: "Django"})
CREATE (simon)-[:CREATED]->(django)
CREATE (adrian)-[:CREATED]->(django)
CREATE (jacob)-[:CREATED]->(django)
CREATE (django)-[:LANGUAGE]->(python)
RETURN armin, flask, simon, adrian, jacob, django, python, guido


// --  Create Alice and Bob and their work

// Create Alice and Bob
CREATE (dept:Department {name: "IT Department"})
CREATE (alice:Person {name: "Alice"})
CREATE (bob:Person {name: "Bob"})

CREATE (alice)-[:WORKS_AT]->(dept)
CREATE (bob)-[:WORKS_AT]->(dept)

RETURN alice, bob, dept


// --  Set some arbitrary properties and labels on Alice and Bob

MATCH (alice:Person {name: "Alice"})
SET
alice:Engineer:Runner:AllRoundLegend,
alice.interests=["LARPing", "running ultra"],
alice.best_100kms=time('18:47:19'),
alice.preferred_larp_system="L5r",
alice.l5r_main_char="A-Bomb the Mighty",
alice.l5r_character_type="Seeker of Enlightenment",
alice.l5r_main_skill_group="Scholar Skills",
alice.l5r_preferred_weapon="Kusarigama",
alice.l5r_preferred_clan="Phoenix Clan"
WITH alice

MATCH (bob:Person {name: "Bob"})
SET
bob.full_name="Robert Perry Smith",
bob.interests="volleyball"

RETURN alice, bob


//
// Let's make a Recommendations Engine!

// Get context and add some more

MATCH (python:Language {name: "Python"})
MATCH (flask {name: "Flask"})
MATCH (django {name: "Django"})
MATCH (dept:Department {name: "IT Department"})
MATCH (alice:AllRoundLegend {name: "Alice"})
MATCH (bob:Person {name: "Bob"})

// add another framework
CREATE (bottle:Software:Framework {name: "Bottle"})
CREATE (bottle)-[:LANGUAGE]->(python)

// add new colleague
CREATE (cris:Person {name: "Cris"})
CREATE (cris)-[:WORKS_AT]->(dept)


// define what people are known to like
CREATE (alice)-[:LIKES]->(bottle)
CREATE (bob)-[:LIKES]->(bottle)
CREATE (cris)-[:LIKES]->(bottle)

CREATE (alice)-[:LIKES]->(django)
CREATE (bob)-[:LIKES]->(django)
CREATE (cris)-[:LIKES]->(django)

CREATE (alice)-[:LIKES]->(flask)
CREATE (bob)-[:LIKES]->(flask)

RETURN alice, bob, cris, dept, django, flask, bottle


// What frameworks do people like?

MATCH
  (dept:Department {name: "IT Department"})
     <-[:WORKS_AT]-
     (people:Person)
     -[:LIKES]->
     (framework:Framework)
     -[:LANGUAGE]->
     (python:Language {name: "Python"})
RETURN framework, people
ORDER BY framework.name



// Find the missing link

:params {person_name: "Cris"}

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
RETURN likeable_framework









































MATCH (cris:Person {name: "Cris"})

MATCH (d:Department {name: "IT Department"})-[:WORKS_AT]-(p:Person)-[:LIKES]-(f:Framework)
WHERE NOT (cris)-[:LIKES]->(f)
RETURN f













MATCH (guido:Person {name: "Guido"})
MATCH (python:Language {name: "Python"})
MATCH (armin:Person {name: "Armin"})
MATCH (flask:Software:Framework {name: "Flask"})
MATCH (armin)-[:CREATED]->(flask)

MATCH (simon:Person {name: "Simon"})
MATCH (adrian:Person {name: "Adrian"})
MATCH (jacob:Person {name: "Jacob"})
MATCH (django:Software:Framework {name: "Django"})
MATCH (simon)-[:CREATED]->(django)
MATCH (adrian)-[:CREATED]->(django)
MATCH (jacob)-[:CREATED]->(django)

CREATE (flask)-[:LANGUAGE]->(python)
CREATE (django)-[:LANGUAGE]->(python)

RETURN armin, flask, simon, adrian, jacob, django


// ---
MATCH (subject:Person)
WHERE subject.name=$person_name

MATCH
     (dept:Department {name: "IT Department"})
     -[:WORKS_AT]-
     (people:Person)
     -[:LIKES]-
     (likeable_framework:Framework)
WHERE NOT (subject)-[:LIKES]->(likeable_framework)
RETURN likeable_framework









/// BAIL OUT

MERGE (adrian:Person {name: "Adrian"})
MERGE (alice:Person:Engineer:Runner:AllRoundLegend {name: "Alice"})
MERGE (armin:Person {name: "Armin"})
MERGE (bob:Person {name: "Bob"})
MERGE (bottle:Software:Framework {name: "Bottle"})
MERGE (cris:Person {name: "Cris"})
MERGE (dept:Department {name: "IT Department"})
MERGE (django:Software:Framework {name: "Django"})
MERGE (flask:Software:Framework {name: "Flask"})
MERGE (guido:Person {name: "Guido"})
MERGE (jacob:Person {name: "Jacob"})
MERGE (python:Language {name: "Python"})
MERGE (simon:Person {name: "Simon"})

MERGE (adrian)-[:CREATED]->(django)
MERGE (alice)-[:LIKES]->(bottle)
MERGE (alice)-[:LIKES]->(django)
MERGE (alice)-[:LIKES]->(flask)
MERGE (alice)-[:WORKS_AT]->(dept)
MERGE (armin)-[:CREATED]->(flask)
MERGE (bob)-[:LIKES]->(bottle)
MERGE (bob)-[:LIKES]->(django)
MERGE (bob)-[:LIKES]->(flask)
MERGE (bob)-[:WORKS_AT]->(dept)
MERGE (bottle)-[:LANGUAGE]->(python)
MERGE (cris)-[:LIKES]->(bottle)
MERGE (cris)-[:LIKES]->(django)
MERGE (cris)-[:WORKS_AT]->(dept)
MERGE (django)-[:LANGUAGE]->(python)
MERGE (flask)-[:LANGUAGE]->(python)
MERGE (guido)-[:CREATED]->(python)
MERGE (jacob)-[:CREATED]->(django)
MERGE (simon)-[:CREATED]->(django)

RETURN armin, flask, simon, adrian, jacob, django, python, guido, alice, bob, cris, dept, bottle



MATCH (alice:Person {name: "Alice"})
MATCH (bob:Person {name: "Bob"})
MATCH (dept:Department {name: "IT Department"})
MATCH (django {name: "Django"})
MATCH (flask {name: "Flask"})
MATCH (guido:Person {name: "Guido"})
MATCH (python:Language {name: "Python"})
