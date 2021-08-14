DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id                   INTEGER          NOT NULL PRIMARY KEY,
    name                 VARCHAR(64)      NOT NULL,
    description          VARCHAR(4096)    NOT NULL,
    thumbnail            VARCHAR(128)     NOT NULL,
    address              VARCHAR(128)     NOT NULL,
    latitude             DOUBLE PRECISION NOT NULL,
    longitude            DOUBLE PRECISION NOT NULL,
    `point`              POINT AS (POINT(latitude, longitude)) STORED NOT NULL,
    rent                 INTEGER          NOT NULL,
    door_height          INTEGER          NOT NULL,
    door_width           INTEGER          NOT NULL,
    features             VARCHAR(64)      NOT NULL,
    popularity           INTEGER          NOT NULL,
    door_height_range_id INTEGER          AS (CASE WHEN estate.door_height > 150 THEN 3 WHEN estate.door_height > 110 THEN 2 WHEN estate.door_height > 80 THEN 1 WHEN estate.door_height > 0 THEN 0 END) STORED,
    door_width_range_id  INTEGER          AS (CASE WHEN estate.door_width > 150 THEN 3 WHEN estate.door_width > 110 THEN 2 WHEN estate.door_width > 80 THEN 1 WHEN estate.door_width > 0 THEN 0 END) STORED,
    rent_range_id        INTEGER          AS (CASE WHEN estate.rent > 150000 THEN 3 WHEN estate.rent > 100000 THEN 2 WHEN estate.rent > 50000 THEN 1 WHEN estate.rent > 0 THEN 0 END) STORED,
    minus_popularity int as (popularity * -1) stored not null
);
alter table isuumo.estate add index (rent, id);
alter table isuumo.estate add index (rent, popularity, id);
alter table isuumo.estate add index (door_width_range_id);
alter table isuumo.estate add index (door_height_range_id);
alter table isuumo.estate add index (rent_range_id);
alter table isuumo.estate add index (latitude);
alter table isuumo.estate add index (longitude);
alter table isuumo.estate add index (popularity);
alter table isuumo.estate add index (minus_popularity, id);
alter table isuumo.estate add spatial index (point);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    minus_popularity int as (popularity * -1) stored not null,
    stock       INTEGER         NOT NULL
);

alter table isuumo.chair add column height_range_id int as (case 
when height >= -1 and height < 80 then 0
when height >= 80 and height < 110 then 1
when height >= 110 and height < 150 then 2
when height >= 150 then 3
END) stored not null;

alter table isuumo.chair add column width_range_id int as (case 
when width >= -1 and width < 80 then 0
when width >= 80 and width < 110 then 1
when width >= 110 and width < 150 then 2
when width >= 150 then 3
END) stored not null;

alter table isuumo.chair add column depth_range_id int as (case 
when depth >= -1 and depth < 80 then 0
when depth >= 80 and depth < 110 then 1
when depth >= 110 and depth < 150 then 2
when depth >= 150 then 3
END) stored not null;

alter table isuumo.chair add column price_range_id int as (case
when price >= -1 and price < 3000 then 0
when price >= 3000 and price < 6000 then 1
when price >= 6000 and price < 9000 then 2
when price >= 9000 and price < 12000 then 3
when price >= 12000 and price < 15000 then 4
when price >= 15000 then 5
END) stored not null;

alter table isuumo.chair add index (price);
alter table isuumo.chair add index (minus_popularity, id);
alter table isuumo.chair add index (price_range_id, height_range_id, depth_range_id, color, stock);