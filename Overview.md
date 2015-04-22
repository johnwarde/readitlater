# Introduction #

This iPhone app will allow you save your favourite news articles from the web on-to your phone for quick off-line reading.  Set up your reading materials before you get on the train.


# Details #

The first version of this is a prototype for the purposes of assessment on the iPhone Programming course in Dublin Institute of Technology.

Add your content here.  Format your content with:
  * The first screen of this app will have an "Add Articles" button at the top of the screen and then a table list all the articles the user has marked as their favourites.
  * The **very** first run of this app will obviously not have any articles listed below the "Add Articles" button.
  * When the user clicks the "Add Articles" button the app will read the items in the configured RSS feed URL (currently http://readitlater.googlecode.com/files/rss.xml, multiple configurable will be available in the next version of the app) and list the title of all the items in  table.
    * The user can then tap an individual article title to then see the full article along with date, summary, etc., The WebView class will be used to display the associated HTML document.
    * Also at the top of this article page will be a button to add the article to the user's favourites that appear of the first screen of the app.
  * When this happens, the article details will be stored in an SQLite database on the iPhone and will reflect the `<`item`>` fields in the RSS standard plus some administration fields such as "read", "deleted" etc., see below for more details.
  * Article titles that are in red are unread, black for viewed.
  * When the user clicks one of the article titles on the first page of the app:
    * That item will be marked "read" in the database.
    * The current table will be pushed onto the navigation stack and a new view will be presented with a "Delete" button at the top of the screen.  Followed by The title and description of the document and the content.
  * When the "Delete" button is pressed the corresponding row is deleted from the database.
  * When there is any change to the on-device databased the Saved Articles table is refreshed using the SavedArticle delegate.

| **Field Name** | **Type(size)** | **Required** | **RSS Field** | **Description** |
|:---------------|:---------------|:-------------|:--------------|:----------------|
| id | INTEGER| Yes | Yes | Internal ID of article|
| title | TEXT(255) | Yes | Yes | Defines the title of the item |
| description | TEXT(4096) | Yes | Yes | Describes the item |
| link | TEXT(512) | Yes | Yes | Defines the hyperlink to the item |
| pubDate | TEXT(50) | No | Yes | Defines the last-publication date for the item |
| author | TEXT(128) | No | Yes | Specifies the e-mail address to the author of the item |
| category | TEXT(255) | No | Yes | Defines one or more categories the item belongs to |
| comments | TEXT(255) | No | Yes | Allows an item to link to comments about that item |
| guid | TEXT(255) | No | Yes | Defines a unique identifier for the item |
| source | TEXT(255)| No | Yes | Specifies a third-party source for the item |
| read | INTEGER |Yes | No | Indicates that the item has been read by the iPhone user |
| deleted | INTEGER | Yes | No | Indicates that the item has been deleted by the iPhone user, these will be deleted from the DB on app exit |
| enclosure | TEXT(???)|No|Yes|Allows a media file to be included with the item, not used in initial version|


# Useful References #

RSS Sytax http://www.w3schools.com/rss/rss_reference.asp

SQLite http://www.sqlite.org/

iPhone Course Moodle http://147.252.224.88/moodle

iOS Dev Center http://developer.apple.com/devcenter/ios

iPhone Course Google Groups https://groups.google.com/forum/#!forum/iphone-programming-dit-2011

Learning iPhone Programming http://my.safaribooksonline.com/book/programming/iphone/9781449380052