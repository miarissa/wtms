<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);
include 'db.php';

// Fix for undefined key:
$workerId = $_POST['id'] ?? $_POST['worker_id'] ?? null;

if (!$workerId) {
    echo json_encode(["error" => "Missing worker ID"]);
    exit;
}

$query = "SELECT full_name, email, phone, address, profile_pic FROM workers_table WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $workerId);
$stmt->execute();

$result = $stmt->get_result(); // Only call once!

if ($row = $result->fetch_assoc()) {
    echo json_encode($row);
} else {
    echo json_encode(["error" => "User not found"]);
}

$stmt->close();
$conn->close();
?>
