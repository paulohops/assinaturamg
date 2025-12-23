<?php
require_once 'config.php';

$base = preg_replace('/[^A-Z0-9_]/', '', $_GET['f']);
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<title>Download da Assinatura</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
</head>
<body>
<div class="container" style="margin-top:30px">
  <h3>Clique para baixar sua assinatura</h3><br>

  <p><strong>Gmail</strong></p>
  <a href="output/<?= $base ?>_gmail.png" download>
    <img src="output/<?= $base ?>_gmail.png" style="max-width:100%">
  </a>

  <hr>

  <p><strong>Webmail</strong></p>
  <a href="output/<?= $base ?>_webmail.png" download>
    <img src="output/<?= $base ?>_webmail.png" style="max-width:100%">
  </a>
</div>
</body>
</html>
