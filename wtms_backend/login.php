<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

if (!isset($_POST['email']) || !isset($_POST['password'])) {
    echo json_encode(['status' => 'failed', 'message' => 'Missing parameters']);
    exit;
}

include_once "db.php";

$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "SELECT * FROM `workers_table` WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $worker = $result->fetch_assoc();  
    $response = array('status' => 'success', 'data' => $worker);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
