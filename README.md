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
