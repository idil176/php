-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 27 Haz 2025, 15:32:56
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `room_reservation`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password_hash`, `created_at`) VALUES
(5, 'idil', 'idiltemel826@gmail.com', '$2y$10$r.IIHVJPJijkmn9zuGuvveRkQOQDRKtxPMcro16zPet8zMS8/28mO', '2025-06-24 14:55:17');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `lecturers`
--

CREATE TABLE `lecturers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `lecturers`
--

INSERT INTO `lecturers` (`id`, `name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'öykü', 'idiltemel@gmail.com', '$2y$10$G8EC7w1Yi1/QV57zKc7h3Ok9fuj1luiNyEetZvbdGkb54yH2nt28u', '2025-06-24 14:49:24'),
(2, 'ali', 'ali@gmail.com', '$2y$10$HbqY9HaZ1iq.GOFKxMwKp.GQDhHoSgeTFwWiPk6tfdQBF1lTxrSh.', '2025-06-24 14:49:50');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  `features` text NOT NULL,
  `building` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `capacity`, `features`, `building`, `is_active`) VALUES
(4, 'aile odası', 4, '', 'b blok', 0),
(5, 'tek kişilik ', 1, '', '', 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `room_reservations`
--

CREATE TABLE `room_reservations` (
  `id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `room_reservations`
--

INSERT INTO `room_reservations` (`id`, `lecturer_id`, `room_id`, `date`, `start_time`, `end_time`, `status`, `created_at`) VALUES
(5, 0, 0, '0000-00-00', '00:00:00', '00:00:00', 'approved', '2025-06-25 14:24:21'),
(6, 1, 4, '2025-12-01', '10:00:00', '12:00:00', 'approved', '2025-06-25 15:26:43'),
(7, 5, 1, '2025-12-01', '10:00:00', '12:00:00', 'pending', '2025-06-25 15:32:04'),
(8, 5, 3, '2025-07-21', '08:00:00', '10:00:00', 'pending', '2025-06-25 15:46:53');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `room_unavailable_times`
--

CREATE TABLE `room_unavailable_times` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Tablo için indeksler `lecturers`
--
ALTER TABLE `lecturers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Tablo için indeksler `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `room_reservations`
--
ALTER TABLE `room_reservations`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `room_unavailable_times`
--
ALTER TABLE `room_unavailable_times`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `lecturers`
--
ALTER TABLE `lecturers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `room_reservations`
--
ALTER TABLE `room_reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `room_unavailable_times`
--
ALTER TABLE `room_unavailable_times`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
