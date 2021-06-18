import consumer from "./consumer"

consumer.subscriptions.create("PostFeedChannel", {
  connected() {
    console.log('Connected User')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    this.notifyUser(data)
  },

  notifyUser(data) {
    if(data != 'New Post') return;
    const newPostSection = document.querySelector("#new-post")
    if(newPostSection.style.display == 'none') {
      newPostSection.style.display = 'initial'
    }
  }
});
