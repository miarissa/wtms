<?php
include 'db.php';

$id = $_GET['id'];

$query = "SELECT * FROM tbl_works WHERE assigned_to = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt ->get_result();

$tasks = [];
while($row = $result->fetch_assoc()) {
    $tasks[] = $row;
}
echo json_encode(['tasks' => $tasks]);

$stmt -> close();
$conn -> close();
?>