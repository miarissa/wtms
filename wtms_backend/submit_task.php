<?php
include 'db.php';

$work_id = $_POST['work_ID'];
$worker_id = $_POST['id'];
$submission_text = $_POST['submission_text'];

$query = "INSERT INTO tbl_submissions (work_ID, id, submission_text) VALUES (?,?,?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("iis", $work_id, $worker_id, $submission_text);

if ($stmt->execute()) {
    $updateQuery="UPDATE tbl_works SET status = 'completed' WHERE work_ID = ?";
    $updatestmt = $conn->prepare($updateQuery);
    $updatestmt->bind_param("i", $work_id);
    $updatestmt->execute();
    
    echo json_encode(['success' => true, 'message' => 'Submission successfull']);
} else {
    echo json_encode(['success' => false, 'message' => 'Error submitting task']);
}

$stmt->close();
$conn->close();
?>