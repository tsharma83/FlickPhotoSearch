# FlickPhotoSearch

FlickPhotoSearch is an open source app for searching photos using Flickr API.It is developed as part of the assignment for mobile engineering position at Uber.

#### Time taken for assignment
  10-12 hrs spanning two days.
  
## Environment
* XCode9.2
* iOS 10.0 onwards
* iPhone only
  
## Functionality
* User can load photos using a text query.
* Photos are loaded in a collection view in a three column layout.
* Appropriate initial/empty/error state messages.
* Loading indicator when loading photos.
* Pagination: Automatic next page loading when scrolled to bottom.
* Asynchronous image loading in collection view cells.

## Architecture and Design
* Architecture - **MVVM-C**
* ApplicationController - Application factory that creates and provides application level instances.
* Coordinator - Drives the navigation hierarchy of the application. It knows about all the viewcontrollers and their view models.
* **API**
  * FlickrAPI - Provides Flickr specific APIs
  * FlickrAPIResponse - Parsed top level object from Flickr APIs
  * FlickrSearchResult - Flickr search results that carry either the search data or error.
* **Networking** - Generic URLSession based networking component
* **PhotoDownloader** - Downloader component that checks in-memory cache for already downloaded images. Downloads the images and save to cache.
