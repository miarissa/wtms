<?php
header('Content-Type: application/json; charset=utf-8');
error_reporting(E_ALL);
ini_set('display_errors', 1);

include 'db.php';

error_log("DEBUG POST: " . json_encode($_POST));

$submission_id = $_POST['submission_id'] ?? null;
$updated_text = $_POST['updated_text'] ?? null;

if (!$submission_id || !$updated_text) {
    echo json_encode(['status' => 'error', 'error' => 'Missing parameters']);
    exit;
}

$stmt = $conn->prepare("UPDATE tbl_submissions SET submission_text = ? WHERE submission_ID = ?");
$stmt->bind_param("si", $updated_text, $submission_id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'error' => 'Failed to update']);
}

$stmt->close();
$conn->close();
