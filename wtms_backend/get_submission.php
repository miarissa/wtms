<?php
error_log("DEBUG: Incoming POST = " . json_encode($_POST));

include 'db.php';

$worker_id = $_POST['worker_id'] ?? $_GET['worker_id'] ?? null;

if (!$worker_id) {
    echo json_encode(['success' => false, 'message' => 'Missing worker_id']);
    exit;
}

$worker_id = (int)$worker_id; // cast to integer

$query = "
    SELECT s.submission_ID AS id, w.title AS task_title, s.submission_text AS text, s.submitted_at AS date_submitted
    FROM tbl_submissions s
    JOIN tbl_works w ON s.work_ID = w.work_ID
    WHERE s.id = ?
    ORDER BY s.submitted_at DESC
";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$submissions = [];
while ($row = $result->fetch_assoc()) {
    $submitted_time = strtotime($row['date_submitted']);
    $current_time = time();
    $time_diff_hours = ($current_time - $submitted_time) / 3600;

    $can_edit = $time_diff_hours <= 48;

    $submissions[] = [
        'id' => $row['id'],
        'task_title' => $row['task_title'],
        'text' => $row['text'],
        'date' => $row['date_submitted'],
        'can_edit' => $can_edit,
        'hours_elapsed' => round($time_diff_hours, 2),
    ];
}

echo json_encode($submissions);

$stmt->close();
$conn->close();
?>
