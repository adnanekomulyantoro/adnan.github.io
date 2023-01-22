-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jan 2023 pada 18.24
-- Versi server: 10.4.21-MariaDB
-- Versi PHP: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rental0130`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `denda`
--

CREATE TABLE `denda` (
  `id` int(11) NOT NULL,
  `transaksi_id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `denda` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jeniskendaraan`
--

CREATE TABLE `jeniskendaraan` (
  `id` int(11) NOT NULL,
  `bentuk_kendaraan` varchar(255) NOT NULL,
  `keterangan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `jeniskendaraan`
--

INSERT INTO `jeniskendaraan` (`id`, `bentuk_kendaraan`, `keterangan`) VALUES
(1, 'Bus', 'Isi 60 kursi'),
(2, 'Mobil ', 'Isi 2 kursi'),
(6, 'Travel', 'isi 15 kursi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kendaraan`
--

CREATE TABLE `kendaraan` (
  `id` int(11) NOT NULL,
  `kode_kendaraan` char(8) NOT NULL,
  `nama_kendaraan` varchar(255) NOT NULL,
  `tahun_kendaraan` date NOT NULL,
  `jumlah_kendaraan` int(11) NOT NULL,
  `jeniskendaraan_id` int(11) NOT NULL,
  `cover` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `kendaraan`
--

INSERT INTO `kendaraan` (`id`, `kode_kendaraan`, `nama_kendaraan`, `tahun_kendaraan`, `jumlah_kendaraan`, `jeniskendaraan_id`, `cover`) VALUES
(8, 'KB-00002', 'Jazz', '2022-12-02', 14, 2, '1672308026_9e692a287bf2d61fe505.jpeg'),
(11, 'KB-00003', 'PAJERO', '2023-01-02', 10, 2, '1673977604_c6e15e9716827aba8c89.jpg'),
(12, 'KB-00004', 'ANGKOT', '2023-01-01', 10, 1, '1673974562_26431eeee169d0a319db.jpg'),
(17, 'KB-00001', 'ANGKOT', '2023-01-17', 20, 6, '1673977412_65566154762b2ad21be6.jpg'),
(18, 'KB-00005', 'Brio', '2023-01-26', 20, 2, '1673978141_c375a064a383f3c0db9b.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `kode_transaksi` char(10) NOT NULL,
  `jeniskendaraan_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tanggal_pinjam` date NOT NULL,
  `tanggal_kembali` date NOT NULL,
  `status` enum('pinjam','kembali') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id`, `kode_transaksi`, `jeniskendaraan_id`, `user_id`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(42, 'KP-0000001', 8, 4, '2023-01-03', '0000-00-00', 'pinjam'),
(43, 'KP-0000002', 8, 4, '2022-12-01', '2023-01-03', 'kembali');

--
-- Trigger `transaksi`
--
DELIMITER $$
CREATE TRIGGER `delete_data` AFTER DELETE ON `transaksi` FOR EACH ROW BEGIN
UPDATE kendaraan SET kendaraan.jumlah_kendaraan = kendaraan.jumlah_kendaraan + '1' WHERE id = old.jeniskendaraan_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_data` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN 
UPDATE kendaraan SET kendaraan.jumlah_kendaraan=kendaraan.jumlah_kendaraan-'1'WHERE id=new.jeniskendaraan_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `kembalikan_kendaraan` AFTER UPDATE ON `transaksi` FOR EACH ROW BEGIN 
IF (new.status = 'kembali') THEN 
UPDATE kendaraan SET kendaraan.jumlah_kendaraan = kendaraan.jumlah_kendaraan + '1' WHERE id = new.jeniskendaraan_id;
ELSE
UPDATE kendaraan SET kendaraan.jumlah_kendaraan = kendaraan.jumlah_kendaraan + '0' WHERE id = new.jeniskendaraan_id;
END IF ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `username` char(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `level` enum('admin','user') NOT NULL,
  `last_login` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `username`, `password`, `level`, `last_login`) VALUES
(1, 'admin', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin', '2023-01-18 09:53:12'),
(4, 'Amira', 'Amira', '0ae39049910b110bea964228da2c9faa', 'user', '2023-01-18 09:54:15'),
(6, 'Arum', 'Arum', 'e718a5e2ce18fc2bd543f5574c8759fd', 'user', '0000-00-00 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `denda`
--
ALTER TABLE `denda`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaksi_id` (`transaksi_id`);

--
-- Indeks untuk tabel `jeniskendaraan`
--
ALTER TABLE `jeniskendaraan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `kendaraan`
--
ALTER TABLE `kendaraan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rak_id` (`jeniskendaraan_id`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaksi_ibfk_1` (`jeniskendaraan_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `denda`
--
ALTER TABLE `denda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `jeniskendaraan`
--
ALTER TABLE `jeniskendaraan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `kendaraan`
--
ALTER TABLE `kendaraan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `denda`
--
ALTER TABLE `denda`
  ADD CONSTRAINT `denda_ibfk_1` FOREIGN KEY (`transaksi_id`) REFERENCES `transaksi` (`id`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `kendaraan`
--
ALTER TABLE `kendaraan`
  ADD CONSTRAINT `kendaraan_ibfk_1` FOREIGN KEY (`jeniskendaraan_id`) REFERENCES `jeniskendaraan` (`id`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`jeniskendaraan_id`) REFERENCES `kendaraan` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
