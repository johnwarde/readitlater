# Database Structure Only #

```

DROP TABLE IF EXISTS "articles";

CREATE TABLE "articles" (
    "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 
    "title" TEXT NOT NULL , 
    "description" TEXT NOT NULL , 
    "link" TEXT NOT NULL , 
    "pubdate" TEXT, 
    "author" TEXT, 
    "category" TEXT, 
    "comments" TEXT, 
    "guid" TEXT, 
    "source" TEXT, 
    "read" BOOL, 
    "deleted" BOOL, 
    "enclosure" TEXT);

```


# Database Structure and Sample Data #

```

DROP TABLE IF EXISTS "articles";

CREATE TABLE "articles" (
    "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 
    "title" TEXT NOT NULL , 
    "description" TEXT NOT NULL , 
    "link" TEXT NOT NULL , 
    "pubdate" TEXT, 
    "author" TEXT, 
    "category" TEXT, 
    "comments" TEXT, 
    "guid" TEXT, 
    "source" TEXT, 
    "read" BOOL, 
    "deleted" BOOL, 
    "enclosure" TEXT);

INSERT INTO "articles" VALUES(1,'Overview','Overview of the ReadItLater Project','http://code.google.com/p/readitlater/wiki/Overview','2011-04-12 13:45','john.warde@gmail.com','design',NULL,NULL,NULL,0,0,NULL);
INSERT INTO "articles" VALUES(2,'Sample RSS feed','Sample RSS feed from w3schools.com','http://readitlater.googlecode.com/files/rss.xml','2011-04-11 13:00','john.warde@gmail.com','design',NULL,NULL,NULL,0,0,NULL);
INSERT INTO "articles" VALUES(3,'Source Link','Link to source code for ReadItLater iPhone app','http://code.google.com/p/readitlater/source/checkout','2011-04-11 11:00','john.warde@gmail.com','design',NULL,NULL,NULL,0,0,NULL);
```