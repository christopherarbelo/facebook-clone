# Used to initialize an empty user base

User.destroy_all

# Users
fry = User.create(name: 'Phillip J. Fry', email: 'fry@planetexpress.com', password: '123456')
leela = User.create(name: 'Turanga Leela', email: 'leela@planetexpress.com', password: '123456')
bender = User.create(name: 'Bender Bending Rodríguez', email: 'bender@planetexpress.com', password: '123456')
professor_farnsworth = User.create(name: 'Professor Farnsworth', email: 'professorfarnsworth@planetexpress.com',
                                   password: '123456')

amy = User.create(name: 'Amy Wong', email: 'amy@planetexpress.com', password: '123456')
hermes = User.create(name: 'Hermes Conrad', email: 'hermes@planetexpress.com', password: '123456')

# Profiles
fry.profile.biography = 'People said I was dumb, but I proved them.'
fry.profile.save
leela.profile.biography = 'Look, I don\'t know about your previous captains, but I intend to do as little dying as possible.'
leela.profile.save
bender.profile.biography = 'Bite me'
bender.profile.save
professor_farnsworth.profile.biography = 'Good news!'
professor_farnsworth.profile.save
amy.profile.biography = 'Intern at Planet Express and Ph.D in Applied Physics from Mars University'
amy.profile.save
hermes.profile.biography = 'Workaholic bureaucrat and the accountant at the Planet Express from Jamaica with a heavy accent!'
hermes.profile.save

# Profile Photos
fry.profile.profile_photo.attach(
  io: File.open(File.join(Rails.root, 'app/assets/images/profile/default_users/fry.jpeg')), filename: 'fry.jpeg'
)
leela.profile.profile_photo.attach(
  io: File.open(File.join(Rails.root, 'app/assets/images/profile/default_users/leela.jpeg')), filename: 'leela.jpeg'
)
bender.profile.profile_photo.attach(
  io: File.open(File.join(Rails.root, 'app/assets/images/profile/default_users/bender.jpeg')), filename: 'bender.jpeg'
)
professor_farnsworth.profile.profile_photo.attach(
  io: File.open(File.join(Rails.root,
                          'app/assets/images/profile/default_users/professor_farnsworth.jpeg')), filename: 'professor_farnsworth.jpeg'
)
amy.profile.profile_photo.attach(
  io: File.open(File.join(Rails.root, 'app/assets/images/profile/default_users/amy.jpeg')), filename: 'amy.jpeg'
)

hermes.profile.profile_photo.attach(io: File.open(File.join(Rails.root, 'app/assets/images/profile/default_users/hermes.jpeg')), filename: 'hermes.jpeg')

# Relationships
fry.change_relationship(leela, 2)
fry.change_relationship(bender, 2)
fry.change_relationship(amy, 2)
fry.change_relationship(professor_farnsworth, 2)
leela.change_relationship(amy, 2)
leela.change_relationship(professor_farnsworth, 2)
leela.change_relationship(bender, 2)
professor_farnsworth.change_relationship(bender, 2)
amy.change_relationship(professor_farnsworth, 0)

# Posts
fry_post = fry.posts.create(body: 'My only other dreams are to be invisible in a chocolate factory and to date a celebrity.')
professor_farnsworth_post = professor_farnsworth.posts.create(body: "Good news everyone! Several years ago I tried to log on to AOL, and it just went through! Wheee! We're online!")
leela_post = leela.posts.create(body: 'Well, we lost to all our opponents. Even that team that turned out to be us in the mirror.')

# Comments
bender_comment = fry_post.comments.create(user_id: bender.id,
                                          message: "I can hit you over the head until you think that's what happened.")
bender_comment_two = leela_post.comments.create(user_id: bender.id, message: 'Welp. at least we tried!')
fry_comment = professor_farnsworth_post.comments.create(user_id: fry.id,
                                                        message: "What's AOL? Is that like Yahoo Messenger?")

# Likes
amy_like = bender_comment.likes.create(user_id: amy.id)
leela_like = bender_comment.likes.create(user_id: leela.id)
bender_like = professor_farnsworth_post.likes.create(user_id: bender.id)
fry_like = bender_comment_two.likes.create(user_id: fry.id)
fry_like_two = leela_post.likes.create(user_id: fry.id)

# Notifications
professor_farnsworth.notifications.create(action_user_id: amy.id, kind: 0)
