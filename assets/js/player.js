class Player {
  player = null;

  init = (domId, playerId, onReady) => {
    window.onYouTubeIframeAPIReady = () => this.onIframeReady(domId, playerId, onReady);

    const youtubeScriptTag = document.createElement("script");
    youtubeScriptTag.src = "https://www.youtube.com/iframe_api";
    document.head.appendChild(youtubeScriptTag);
  };

  onIframeReady = (domId, playerId, onReady) => {
    console.log('YouTube Player is being initialized...');  // Add log
    this.player = new YT.Player(domId, {
      height: "360",
      width: "420",
      videoId: playerId,
      events: {
        "onReady": event => {
          console.log('Player is ready');  // Add log
          onReady(event);
        },
        "onStateChange": event => this.onPlayerStateChange(event),
        "onError": error => console.error('YouTube Player Error: ', error)  // Add error handling
      }
    });
  };

  onPlayerStateChange = (event) => {
    // Implement state change handling here
  };

  getCurrentTime = () => Math.floor(this.player.getCurrentTime() * 1000);

  seekTo = (millsec) => this.player.seekTo(millsec / 1000);
}

export default Player;
