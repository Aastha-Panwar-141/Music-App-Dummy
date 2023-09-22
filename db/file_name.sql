PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
INSERT INTO schema_migrations VALUES('20230913121726');
INSERT INTO schema_migrations VALUES('20230913125311');
INSERT INTO schema_migrations VALUES('20230915063159');
INSERT INTO schema_migrations VALUES('20230915063908');
INSERT INTO schema_migrations VALUES('20230915064740');
INSERT INTO schema_migrations VALUES('20230915064805');
INSERT INTO schema_migrations VALUES('20230915065259');
INSERT INTO schema_migrations VALUES('20230912113932');
INSERT INTO schema_migrations VALUES('20230913122146');
INSERT INTO schema_migrations VALUES('20230913122301');
INSERT INTO schema_migrations VALUES('20230918131246');
INSERT INTO schema_migrations VALUES('20230921063635');
INSERT INTO schema_migrations VALUES('20230913122337');
INSERT INTO schema_migrations VALUES('20230922072818');
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
INSERT INTO ar_internal_metadata VALUES('environment','development','2023-09-12 11:53:41.698741','2023-09-12 11:53:41.698741');
CREATE TABLE IF NOT EXISTS "playlist_songs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "playlist_id" integer NOT NULL, "song_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_282ee7fa4c"
FOREIGN KEY ("playlist_id")
  REFERENCES "playlists" ("id")
, CONSTRAINT "fk_rails_4771edc43f"
FOREIGN KEY ("song_id")
  REFERENCES "songs" ("id")
);
INSERT INTO playlist_songs VALUES(1,2,8,'2023-09-22 07:15:19.775895','2023-09-22 07:15:19.775895');
INSERT INTO playlist_songs VALUES(2,2,9,'2023-09-22 07:43:18.475811','2023-09-22 07:43:18.475811');
INSERT INTO playlist_songs VALUES(3,3,11,'2023-09-22 07:59:30.419184','2023-09-22 07:59:30.419184');
CREATE TABLE IF NOT EXISTS "active_storage_blobs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "key" varchar NOT NULL, "filename" varchar NOT NULL, "content_type" varchar, "metadata" text, "service_name" varchar NOT NULL, "byte_size" bigint NOT NULL, "checksum" varchar, "created_at" datetime(6) NOT NULL);
INSERT INTO active_storage_blobs VALUES(2,'auxeswkuypwj2kenke3f16nowg9u','sample-3s.mp3','audio/mpeg','{"identified":true}','local',52079,'T3dNCPDD5mWUcE1r5KLQUg==','2023-09-21 06:07:43.782428');
INSERT INTO active_storage_blobs VALUES(6,'vchooemmjtg3h0ffad8i3dbtgv31','sample-3s.mp3','audio/mpeg','{"identified":true,"analyzed":true}','local',52079,'T3dNCPDD5mWUcE1r5KLQUg==','2023-09-21 06:16:06.308605');
INSERT INTO active_storage_blobs VALUES(7,'eichx12y5gk0yuoq4geqjgobd19r','sample-6s.mp3','audio/mpeg','{"identified":true,"analyzed":true}','local',103070,'syUw1M1kJs232DDAAlWxOA==','2023-09-21 09:24:07.657088');
INSERT INTO active_storage_blobs VALUES(9,'lbsbz96ynnhjguayd0vkdyw2b3n8','sample-9s.mp3','audio/mpeg','{"identified":true,"analyzed":true}','local',154062,'5p0/OL0/36dSnyjIPIW7gw==','2023-09-21 09:48:12.269634');
INSERT INTO active_storage_blobs VALUES(13,'ebimyt93bq9p0ecmduzun2pb0rye','sample-9s.mp3','audio/mpeg','{"identified":true,"analyzed":true}','local',154062,'5p0/OL0/36dSnyjIPIW7gw==','2023-09-22 06:20:03.144067');
CREATE TABLE IF NOT EXISTS "active_storage_attachments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "record_type" varchar NOT NULL, "record_id" bigint NOT NULL, "blob_id" bigint NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c3b3935057"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
INSERT INTO active_storage_attachments VALUES(2,'file','Song',6,2,'2023-09-21 06:07:43.784377');
INSERT INTO active_storage_attachments VALUES(6,'file','Song',8,6,'2023-09-21 06:16:06.310433');
INSERT INTO active_storage_attachments VALUES(7,'file','Song',4,7,'2023-09-21 09:24:07.659489');
INSERT INTO active_storage_attachments VALUES(9,'file','Song',9,9,'2023-09-21 09:48:12.272228');
INSERT INTO active_storage_attachments VALUES(13,'file','Song',11,13,'2023-09-22 06:20:03.145845');
CREATE TABLE IF NOT EXISTS "active_storage_variant_records" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "blob_id" bigint NOT NULL, "variation_digest" varchar NOT NULL, CONSTRAINT "fk_rails_993965df05"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar, "email" varchar, "password_digest" varchar, "user_type" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime(6), "unconfirmed_email" varchar);
INSERT INTO users VALUES(2,'Naman Panwar','naman@gmail.com','$2a$12$PWSmxqgnfNw4KFIvIgg45uM7HgiUeKdruYQGuio2G4CLToRX.MN8u','Artist','2023-09-18 07:16:22.588129','2023-09-18 07:16:22.588129',NULL,NULL,NULL);
INSERT INTO users VALUES(3,'Dishika Siso','dishika@gmail.com','$2a$12$uycR0NoNEbV6YgB3DOR1peRBmSXtBSFGSgtbf.ZrCt1CBn4E7roeW','Listener','2023-09-18 07:19:58.450421','2023-09-18 07:19:58.450421',NULL,NULL,NULL);
INSERT INTO users VALUES(4,'Kanan Siso','kanan@gmail.com','$2a$12$H8zVr/K5.pvp/iYzL3sth.ndDMv30II3GYAMleVAJQXUW4YdWr0VK','Listener','2023-09-18 10:28:45.016742','2023-09-18 10:28:45.016742',NULL,NULL,NULL);
INSERT INTO users VALUES(5,'Khushi Panwar','khushi@gmail.com','$2a$12$I8s1fhD.khucsL61ZHoFne89JI/JCQ2aVpU.RjZ3NYbMy4.iqoAYu','Artist','2023-09-18 11:13:49.946443','2023-09-22 06:34:29.798930',NULL,NULL,NULL);
INSERT INTO users VALUES(6,'Siya Panwar','siya@gmail.com','$2a$12$jVgsL/qxiRKrN4nXXJD1r.LvYmRyo3/Lv45GizHkFh9yDyFj1ymWe','Artist','2023-09-19 05:24:57.221956','2023-09-19 05:30:46.685287','0d52c9266c2d57a37676','2023-09-19 05:30:46.681111',NULL);
INSERT INTO users VALUES(15,'Astha Panwar','asthap@shriffle.com','$2a$12$6hbucRDvxKCxI1X5/7cF1.kxokzpbAobW6QFZxsBeInOy.CKisYaa','Artist','2023-09-19 11:33:19.433306','2023-09-19 11:33:19.433306',NULL,NULL,NULL);
INSERT INTO users VALUES(23,'sumit','sumitse@shriffle.com','$2a$12$R/N2zDrUM.WpI1dPbP2AdeekGLCC.5poez6FcCK3YT8GU2mUlsSjy','Artist','2023-09-19 13:24:00.817675','2023-09-19 13:24:00.817675',NULL,NULL,NULL);
INSERT INTO users VALUES(31,'sumitse','sumitsengar2001@gmail.com','$2a$12$zJL66VJfw5WoAc6xxcR/pexowlvL7nAomw.qXhv0Utgsx4jxoG552','Artist','2023-09-19 13:40:08.452759','2023-09-19 13:40:08.452759',NULL,NULL,NULL);
INSERT INTO users VALUES(32,'aastha','aasthasaipanwar@gmail.com','$2a$12$JqVEf9sMW8NL8IgZBiw14.8CYUIHsJMP56alBCcQMbzZQkLZr3s.2','Artist','2023-09-19 13:44:02.652674','2023-09-19 13:44:02.652674',NULL,NULL,NULL);
INSERT INTO users VALUES(33,'user 1','aasthapanwar0710@gmail.com','$2a$12$CuMkZkYyHTKjoGyxU0y1r.8B7.YklnJUinEVd7SRFzoGumKhFurKe','Artist','2023-09-21 05:20:02.363187','2023-09-21 12:30:16.442831',NULL,'2023-09-21 12:28:21.342277',NULL);
CREATE TABLE IF NOT EXISTS "albums" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "user_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_964016e0e8"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
INSERT INTO albums VALUES(4,'Album 1',5,'2023-09-18 11:47:21.911231','2023-09-18 11:47:21.911231');
INSERT INTO albums VALUES(5,'Album 2',5,'2023-09-21 06:07:17.779249','2023-09-21 06:07:17.779249');
INSERT INTO albums VALUES(6,'Lofi',5,'2023-09-21 12:45:30.809584','2023-09-21 12:45:30.809584');
CREATE TABLE IF NOT EXISTS "songs" ("id" integer NOT NULL PRIMARY KEY, "title" varchar DEFAULT NULL, "genre" varchar DEFAULT NULL, "user_id" integer NOT NULL, "album_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "play_count" integer DEFAULT 0, CONSTRAINT "fk_rails_f4e40cd655"
FOREIGN KEY ("album_id")
  REFERENCES "albums" ("id")
, CONSTRAINT "fk_rails_d36a8dd57d"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
INSERT INTO songs VALUES(4,'Song 3','Hip pop',5,4,'2023-09-18 11:52:02.926778','2023-09-21 09:24:07.661125',4);
INSERT INTO songs VALUES(5,'Song 4','Hip pop',5,4,'2023-09-21 06:06:14.077294','2023-09-21 06:06:14.077294',4);
INSERT INTO songs VALUES(6,'Song 4','Hip pop',5,4,'2023-09-21 06:07:43.734133','2023-09-21 06:07:43.787272',2);
INSERT INTO songs VALUES(8,'Sample song','Lofi',5,5,'2023-09-21 06:16:06.287056','2023-09-21 06:16:06.311734',0);
INSERT INTO songs VALUES(9,'Sample song 2','Lofi',32,5,'2023-09-21 09:48:12.223312','2023-09-21 09:48:12.276057',0);
INSERT INTO songs VALUES(10,'Kafira','lofi',32,6,'2023-09-21 12:46:09.123531','2023-09-21 12:46:09.123531',0);
INSERT INTO songs VALUES(11,'Heer','Instrumental',32,5,'2023-09-22 06:20:03.057919','2023-09-22 06:20:03.147555',0);
CREATE TABLE IF NOT EXISTS "playlists" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "user_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_d67ef1eb45"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
INSERT INTO playlists VALUES(2,'Playlist Lofi',4,'2023-09-22 07:15:19.736416','2023-09-22 07:15:19.736416');
INSERT INTO playlists VALUES(3,'Playlist Instrumental',4,'2023-09-22 07:59:30.396828','2023-09-22 07:59:30.396828');
CREATE TABLE IF NOT EXISTS "recentyly_playeds" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "song_id" integer NOT NULL, "played_at" datetime(6), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_bafa562f3c"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_8ba80271bb"
FOREIGN KEY ("song_id")
  REFERENCES "songs" ("id")
);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('users',33);
INSERT INTO sqlite_sequence VALUES('albums',6);
INSERT INTO sqlite_sequence VALUES('active_storage_blobs',13);
INSERT INTO sqlite_sequence VALUES('active_storage_attachments',13);
INSERT INTO sqlite_sequence VALUES('playlists',3);
INSERT INTO sqlite_sequence VALUES('playlist_songs',3);
CREATE INDEX "index_playlist_songs_on_playlist_id" ON "playlist_songs" ("playlist_id");
CREATE INDEX "index_playlist_songs_on_song_id" ON "playlist_songs" ("song_id");
CREATE UNIQUE INDEX "index_active_storage_blobs_on_key" ON "active_storage_blobs" ("key");
CREATE INDEX "index_active_storage_attachments_on_blob_id" ON "active_storage_attachments" ("blob_id");
CREATE UNIQUE INDEX "index_active_storage_attachments_uniqueness" ON "active_storage_attachments" ("record_type", "record_id", "name", "blob_id");
CREATE UNIQUE INDEX "index_active_storage_variant_records_uniqueness" ON "active_storage_variant_records" ("blob_id", "variation_digest");
CREATE INDEX "index_albums_on_user_id" ON "albums" ("user_id");
CREATE INDEX "index_songs_on_user_id" ON "songs" ("user_id");
CREATE INDEX "index_songs_on_album_id" ON "songs" ("album_id");
CREATE INDEX "index_playlists_on_user_id" ON "playlists" ("user_id");
CREATE INDEX "index_recentyly_playeds_on_user_id" ON "recentyly_playeds" ("user_id");
CREATE INDEX "index_recentyly_playeds_on_song_id" ON "recentyly_playeds" ("song_id");
COMMIT;
