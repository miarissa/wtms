<?php
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "worker_task_mngmt";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode(['status' => 'failed', 'message' => 'DB connection failed']);
    exit;
}
?>
