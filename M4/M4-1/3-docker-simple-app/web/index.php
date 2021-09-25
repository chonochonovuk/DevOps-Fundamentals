<html>
<head>
</head>
<body>
Hello! I have been visited: 
<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

require 'Predis/Autoloader.php';

Predis\Autoloader::register();

  $host = 'redis-master';

  $client = new Predis\Client([
      'scheme' => 'tcp',
      'host'   => $host,
      'port'   => 6379,
    ]);

  $value = $client->incr("visited");
  
  print($value." ");
?>
time(s) so far.
<br /><br /><br />
<i>Powered by <b>Redis</b></i>
</body>
</html>
