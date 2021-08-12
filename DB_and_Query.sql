CREATE TABLE `brand_category` (
  `id` varchar(36) NOT NULL,
  `category` varchar(45) NOT NULL,
  `categoryCode` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `brand` (
  `id` varchar(36) NOT NULL,
  `barcode` int NOT NULL,
  `brandCode` varchar(45) DEFAULT NULL,
  `categoryId` varchar(36) NOT NULL,
  `cpg` varchar(36) DEFAULT NULL,
  `topBrand` bit(1) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_barcode` (`barcode`),
  KEY `FK_category_of_brand` (`categoryId`),
  CONSTRAINT `FK_category_of_brand` FOREIGN KEY (`categoryId`) REFERENCES `brand_category` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `item` (
  `id` varchar(36) NOT NULL,
  `barcode` int NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `finalPrice` decimal(6,2) DEFAULT NULL,
  `itemPrice` decimal(6,2) DEFAULT NULL,
  `needsFetchReview` bit(1) DEFAULT NULL,
  `partnerItemId` int DEFAULT NULL,
  `pointsNotAwardedReason` varchar(1000) DEFAULT NULL,
  `pointsPayerId` varchar(36) DEFAULT NULL,
  `preventTargetGapPoints` bit(1) DEFAULT NULL,
  `quantityPurchased` int DEFAULT NULL,
  `rewardsGroup` varchar(1000) DEFAULT NULL,
  `rewardsProductPartnerId` varchar(36) DEFAULT NULL,
  `targetPrice` decimal(6,2) DEFAULT NULL,
  `userFlaggedBarcode` int DEFAULT NULL,
  `userFlaggedNewItem` bit(1) DEFAULT NULL,
  `userFlaggedPrice` decimal(6,2) DEFAULT NULL,
  `userFlaggedQuantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `barcode_UNIQUE` (`barcode`)
) ENGINE=InnoDB;

CREATE TABLE `brand_item_map` (
  `brandId` varchar(36) NOT NULL,
  `itemId` varchar(36) NOT NULL,
  KEY `FK_brand_barcode` (`brandId`),
  KEY `FK_item_barcode` (`itemId`),
  CONSTRAINT `FK_brand_barcode` FOREIGN KEY (`brandId`) REFERENCES `brand` (`id`),
  CONSTRAINT `FK_item_barcode` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `user` (
  `id` varchar(36) NOT NULL,
  `state` varchar(2) NOT NULL,
  `createdDate` datetime(6) NOT NULL,
  `lastLogin` datetime(6) DEFAULT NULL,
  `role` varchar(45) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `receipts` (
  `id` varchar(36) NOT NULL,
  `bonusPointsEarned` int DEFAULT NULL,
  `bonusPointsEarnedReason` varchar(256) DEFAULT NULL,
  `createDate` datetime(6) DEFAULT NULL,
  `dateScanned` datetime(6) DEFAULT NULL,
  `finishedDate` datetime(6) DEFAULT NULL,
  `modifyDate` datetime(6) DEFAULT NULL,
  `pointsAwardedDate` datetime(6) DEFAULT NULL,
  `pointsEarned` int DEFAULT NULL,
  `purchaseDate` datetime(6) DEFAULT NULL,
  `purchasedItemCount` int DEFAULT NULL,
  `rewardsReceiptStatus` varchar(45) DEFAULT NULL,
  `totalSpent` decimal(6,2) DEFAULT NULL,
  `userId` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user_of_receipt` (`userId`),
  CONSTRAINT `FK_user_of_receipt` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `receipt_item_list` (
  `receiptId` varchar(36) NOT NULL,
  `itemId` varchar(36) NOT NULL,
  KEY `FK_receipt` (`receiptId`),
  KEY `FK_item` (`itemId`),
  CONSTRAINT `FK_item` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`),
  CONSTRAINT `FK_receipt` FOREIGN KEY (`receiptId`) REFERENCES `receipts` (`id`)
) ENGINE=InnoDB;


-- Query for 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

select r.rewardsReceiptStatus 'Status', sum(r.purchasedItemCount) 'Total Items Purchased'
from receipts r
inner join receipt_item_list ri on ri.receiptId = r.id
inner join item i on i.id = ri.itemId
where r.rewardsReceiptStatus in ('ACCEPTED', 'REJECTED')
group by r.rewardsReceiptStatus
order by 2 desc
limit 1;