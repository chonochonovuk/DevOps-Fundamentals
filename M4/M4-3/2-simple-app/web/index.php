<?php

$cluster   = Cassandra::cluster()->withContactPoints('cassandra-host')->build();

$session   = $cluster->connect("catalog");

$statement = new Cassandra\SimpleStatement("SELECT * FROM magazines");

$result    = $session->execute($statement);

echo "Result contains " . $result->count() . " rows\n";

foreach ($result as $row) {
  echo $row['year'] . ": " . $row['title'] . " / " . $row['price'] . "\n";
}
?>
