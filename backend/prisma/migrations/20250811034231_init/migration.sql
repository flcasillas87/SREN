/*
  Warnings:

  - You are about to drop the `Consummo` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE `Consummo`;

-- CreateTable
CREATE TABLE `Central` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `ubicacion` VARCHAR(191) NULL,

    UNIQUE INDEX `Central_nombre_key`(`nombre`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Consumo` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `centralId` INTEGER NOT NULL,
    `fecha` DATETIME(3) NOT NULL,
    `valorGJ` DOUBLE NOT NULL,

    UNIQUE INDEX `Consumo_centralId_fecha_key`(`centralId`, `fecha`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Consumo` ADD CONSTRAINT `Consumo_centralId_fkey` FOREIGN KEY (`centralId`) REFERENCES `Central`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
