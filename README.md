
# Astronomy Pictures

An application to see astronomy pictures uploaded by Nasa. It has 2 options to choose from 
- Picture of the day: Supports rendering of Image and playing a youtube video.
- Astronomy random picture collection: Lists picture collection in a tableview and allows user to navigate to detail page

## API Reference

#### Get picture of the day

```http
  GET https://api.nasa.gov/planetary/apod?api_key={API_KEY}&date={DATE}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |
| `date`    | `string` | **Required**. Date (Ex: 2022-08-01) on which you want to view the Picture of the day |

#### Get set of astronomy pictures

```http
  GET https://api.nasa.gov/planetary/apod?api_key={API_KEY}&count={COUNT}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of item to fetch |
| `count`   | `Int`    | **Required**. count is number of items to fetch |


## Tech Stack

**Client:** Swift 5, iOS 14.0 onwards


## Documentation

##### Environment
Each target is bound to work according to environment based on target name
Added an enum for populating end points according to target


##### AstronomyPhotoStore
A photo store provides funtionalities to 
- fetch picture of the day
- fetch list of pictures
- loads a remote image 

##### ImageStore
It stores downloaded prictures into NSCache using its urlpath as a key to the cache

##### ApodDataStorage
Provides safe access in a multithreaded environment. Used to save retrieved AstronomyPictureInfo objects

##### AstronomyModel
Singleton class which contains active NSUrlSession and ImageStore objects

##### MediaRenderingView
A custom view which is capable of 
- rendering image view
- youtube url (uses a third party YouTubeiOSPlayerHelper library for YT playback support)
- web video url (uses WebKit to play web videos)

##### NetworkManager
Executes a given urlRequest using a NSUrlSession. Generaic method to fetch data of any type which is codable

##### ServiceRequestFactory
Provides either service request or mock request based on target settings
