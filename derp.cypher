// DERP
CREATE (i)
CREATE (j)
CREATE (k)
CREATE (l)
CREATE
(i)-[:DERP]->
(j)-[:DERP]->
(k)-[:DERP]->(l)
RETURN i, j, k, l

// HERP
CREATE (i)
CREATE (j)
CREATE (k)
CREATE (l)
CREATE
(i)-[:HERP]->
(j)-[:DERP]->
(k)-[:HERP]->
(l)-[:DERP]->(i)
RETURN i, j, k, l

// HERPDERP
CREATE (i)
CREATE (j)
CREATE (k)
CREATE (l)
CREATE
(i)-[:HERP]->(j)-[:DERP]->
(k)-[:HERP]->(l)-[:DERP]->(i)
CREATE (i)-[:HERPDERP]->(k)
CREATE (j)-[:HERPDERP]->(l)
RETURN i, j, k, l
