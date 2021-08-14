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
    rent_range_id        INTEGER          AS (CASE WHEN estate.rent > 150000 THEN 3 WHEN estate.rent > 100000 THEN 2 WHEN estate.rent > 50000 THEN 1 WHEN estate.rent > 0 THEN 0 END) STORED
);
alter table isuumo.estate add index (rent, id);
alter table isuumo.estate add index (rent, popularity, id);
alter table isuumo.estate add index (door_height_range_id, door_width_range_id,rent_range_id);
alter table isuumo.estate add index (door_width_range_id, popularity);
alter table isuumo.estate add index (door_height_range_id, popularity);
alter table isuumo.estate add index (rent_range_id, popularity);
alter table isuumo.estate add index (latitude);
alter table isuumo.estate add index (longitude);
alter table isuumo.estate add index (popularity);
alter table isuumo.estate add column minus_popularity int as (popularity * -1) stored not null;
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
    stock       INTEGER         NOT NULL
);
alter table isuumo.chair add index (stock, price, id);

alter table isuumo.chair add index (price);
