<?php
include 'db.php';

$workerId = $_POST['id'];
$fullName = $_POST['full_name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$removePicture = isset($_POST['remove_picture']) && $_POST['remove_picture'] == '1';

// Handle image upload
$profilePic = '';
if (!empty($_FILES['profile_pic']['name'])) {
    $uploadDir = 'uploads/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $filename = uniqid() . '_' . basename($_FILES['profile_pic']['name']);
    $targetFile = $uploadDir . $filename;

    if (move_uploaded_file($_FILES['profile_pic']['tmp_name'], $targetFile)) {
        $profilePic = $filename;
    }
}

$query = "UPDATE workers_table 
          SET full_name = ?, email = ?, phone = ?, address = ?";

if ($profilePic) {
    $query .= ", profile_pic = ?";
} elseif ($removePicture) {
    $query .= ", profile_pic = ''";
}

$query .= " WHERE id = ?";

if ($profilePic) {
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssssi", $fullName, $email, $phone, $address, $profilePic, $workerId);
} else {
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssi", $fullName, $email, $phone, $address, $workerId);
}

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
