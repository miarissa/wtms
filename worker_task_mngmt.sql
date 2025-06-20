-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2025 at 04:50 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `worker_task_mngmt`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_submissions`
--

CREATE TABLE `tbl_submissions` (
  `submission_ID` int(11) NOT NULL,
  `work_ID` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `submission_text` text NOT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_submissions`
--

INSERT INTO `tbl_submissions` (`submission_ID`, `work_ID`, `id`, `submission_text`, `submitted_at`) VALUES
(1, 1, 1, 'All material A have been prepared', '2025-06-18 23:10:12'),
(2, 4, 4, 'A few of batch 4\'s circuit has been tested', '2025-06-20 02:45:11');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_works`
--

CREATE TABLE `tbl_works` (
  `work_ID` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `date_assigned` date NOT NULL,
  `due_date` date NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT '''pending'''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_works`
--

INSERT INTO `tbl_works` (`work_ID`, `title`, `description`, `assigned_to`, `date_assigned`, `due_date`, `status`) VALUES
(1, 'Prepare Material A', 'Prepare raw material A for assembly', 1, '2025-05-25', '2025-05-28', 'completed'),
(2, 'Inspect Machine X', 'Conduct inspection for machine X', 2, '2025-05-25', '2025-05-29', 'pending'),
(3, 'Clean Area B', 'Deep clean work area B before audit', 3, '2025-05-25', '2025-05-30', 'pending'),
(4, 'Test Circuit Board', 'Perform unit test for circuit batch 4', 4, '2025-05-25', '2025-05-28', 'completed'),
(5, 'Document Process', 'Write SOP for packaging unit', 5, '2025-05-25', '2025-05-29', 'pending'),
(6, 'Paint Booth Check', 'Routine check on painting booth ', 1, '2025-05-25', '2025-05-30', 'pending'),
(7, 'Label Inventory ', 'Label all boxes in section C', 2, '2025-05-25', '2025-05-28', 'pending'),
(8, 'Update Database', 'Update inventory in MySQL system', 3, '2025-05-25', '2025-05-29', 'pending'),
(9, 'Maintain Equipment', 'Oil and tune cutting machine ', 4, '2025-05-25', '2025-05-30', 'pending'),
(10, 'Prepare Report ', 'Prepare monthly performance report ', 5, '2025-05-25', '2025-05-30', 'pending');

-- --------------------------------------------------------

--
-- Table structure for table `workers_table`
--

CREATE TABLE `workers_table` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `workers_table`
--

INSERT INTO `workers_table` (`id`, `full_name`, `email`, `password`, `phone`, `address`, `profile_pic`) VALUES
(1, 'Siti Maisyarah Binti Halid', 'maisyarah@gmail.com', 'e2254a74928a2cc947c22afdbe76bd2828d2b09d', '0123456789', 'Slim River', '6855748cf1f72_29.jpg'),
(2, 'Shaqirah', 'shaqirah@gmail.com', 'e2b132d09fd577007f1c107f5d5b7a6bdc19e5b8', '', '', NULL),
(4, 'Normazuana', 'normazuana@gmail.com', '78925f13779a05a8bf5f73477a862e1dd8056f17', '0132456789', 'Shah Alam', '685452060a542_29.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  ADD PRIMARY KEY (`submission_ID`);

--
-- Indexes for table `tbl_works`
--
ALTER TABLE `tbl_works`
  ADD PRIMARY KEY (`work_ID`);

--
-- Indexes for table `workers_table`
--
ALTER TABLE `workers_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  MODIFY `submission_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_works`
--
ALTER TABLE `tbl_works`
  MODIFY `work_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `workers_table`
--
ALTER TABLE `workers_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
