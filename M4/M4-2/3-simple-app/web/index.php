<html>
<head>
</head>
<body>
Hello! I have been visited: 
<?php

$host = "mongo-host";

$connection = new MongoClient( "mongodb://".$host.":27017" );

$db = $connection->selectDB('test');

$collection = $db->selectCollection('counters');

$collection->update(array('counter' => 'visits'), array('$inc' => array('total' => 1)));

$results = $collection->findOne(array('counter' => 'visits'));

echo $results['total']." ";

?>
time(s) so far.
<br /><br /><br />
<i>Powered by <b>MongoDB</b></i>
</body>
</html>
