const notificationLink = document.querySelector('#notifications-link')
const notificationPanel = document.querySelector('#notification-panel')

notificationLink.addEventListener('click', e => {
  notificationPanel.classList.toggle("invisible");
})
