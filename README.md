# Facebook - Rails Final Project

A facebook like clone using Rails framework. Project from [the Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-on-rails/lessons/final-project)

## Data Model
### Relationship
The relationship model keeps track of relationships (i.e. friendships) between users. Status denotes what kind of relationship users may have.

#### Status codes
|Code | Description
--- | --- |
|0|pending friend request|
|1|declined friend request|
|2|users are friends|
|3|users are blocked from being friends|

### Notification
The notification model keeps track of every users set of notifications. The type column denotes whether the notification is for a friend request, liked post or liked comment.

|Type code | Description
--- | --- |
|0|User sent friend request|
|1|User accepted friend request|
