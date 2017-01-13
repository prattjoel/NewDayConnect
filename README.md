# NewDayConnect

The app is a video player for a church.  Essentially, it allows users to access the church's youtube channel to play videos.  
It also allows users to create a list of favorite videos to come back and watch later.

How to use the app:

There are two tableViews named "FavoritesController" and "AllVideosController" embedded in a tabBarController.  

The "FavoritesController"  allows users to select a video from the list of videos the user has added to their favorites.
These videos are persisted in CoreData.
If the "FavoritesController" is empty, the user will be prompted to add videos to the "FavoritesController".
Otherwise, videos will display automatically.  Since the "FavoritesController" is the intial ViewController,
you will be prompted to add videos to the "FavoritesController" upon first launch of the app.

The "AllVideosController" allows users to browse the videos and select one to watch or save.
These videos are automatically loaded when returned from a request to the YouTube API

Once a video is selected, the user is directed to the "VideoPlayerController".
The "VideoPlayerController" allows users to watch videos and/or add videos to their list of favorites.  
Users can also delete videos from their favorites in the "VideoPlayerController".
Videos added to the favorites list are added to CoreData and displayed in the "FavoritesController".
Deleted videos are removed from CoreData and no longer displayed in the "FavoritesController".

That's pretty much it in a nutshell.

Thanks!
