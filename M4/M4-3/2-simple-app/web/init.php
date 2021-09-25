<?php

$cluster   = Cassandra::cluster()->withContactPoints('cassandra-host')->build();

$session   = $cluster->connect();

$statement = new Cassandra\SimpleStatement("CREATE KEYSPACE catalog WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};");

$result    = $session->execute($statement);

$session   = $cluster->connect("catalog"); 

$statement = new Cassandra\SimpleStatement("CREATE TABLE magazines (title text, year int, copies int, price decimal, categories list <text>, PRIMARY KEY (year, title));");
$result    = $session->execute($statement);

$statement = new Cassandra\SimpleStatement("INSERT INTO catalog.magazines (title, year, copies, price, categories) VALUES ('Magazine 1', 2018, 150, 5.40, ['IT', 'Development']);");
$result    = $session->execute($statement);

$statement = new Cassandra\SimpleStatement("INSERT INTO catalog.magazines (title, year, copies, price, categories) VALUES ('Magazine 2', 2018, 450, 4.80, ['Lifestyle', 'Women']);");
$result    = $session->execute($statement);

$statement = new Cassandra\SimpleStatement("INSERT INTO catalog.magazines (title, year, copies, price, categories) VALUES ('Magazine 3', 2018, 236, 3.80, ['Lifestyle', 'Fashion', 'Women']);");
$result    = $session->execute($statement);

$statement = new Cassandra\SimpleStatement("INSERT INTO catalog.magazines (title, year, copies, price, categories) VALUES ('Magazine 1', 2017, 50, 5.40, ['IT', 'Development']);");
$result    = $session->execute($statement);

$statement = new Cassandra\SimpleStatement("INSERT INTO catalog.magazines (title, year, copies, price, categories) VALUES ('Magazine 2', 2017, 410, 4.80, ['Lifestyle', 'Women']);");
$result    = $session->execute($statement);

echo "Data loaded.";

?>