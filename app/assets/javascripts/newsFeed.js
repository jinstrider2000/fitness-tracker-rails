class NewsFeedItem {
  constructor(init) {
    this.name = init;
  }
}


function seconds_since_epoch() {
  return Math.floor(Date.now()/1000)
}