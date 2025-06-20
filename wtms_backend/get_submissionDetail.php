<?php
include 'db.php';

$submission_id = $_POST['submission_id'] ?? $_GET['submission_id'] ?? null;

if (!$submission_id) {
    echo json_encode(['success' => false, 'message' => 'Missing submission_id']);
    exit;
}

$submission_id = (int)$submission_id; // cast to int !!!

$query = "SELECT submission_text, submitted_at FROM tbl_submissions WHERE submission_ID = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $submission_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $submitted_time = strtotime($row['submitted_at']);
    $current_time = time();
    $time_diff_hours = ($current_time - $submitted_time) / 3600;
    $can_edit = $time_diff_hours <= 48;

    echo json_encode([
        'success' => true,
        'text' => $row['submission_text'],
        'can_edit' => $can_edit,
        'hours_elapsed' => round($time_diff_hours, 2),
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Submission not found']);
}

$stmt->close();
$conn->close();
?>
