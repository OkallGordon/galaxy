// app.js

// Set window.userToken from the meta tag
window.userToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

console.log("User Token set in app.js:", window.userToken); // Debugging line

import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Player from "./player";
import Video from "./video";
import socket from "./user_socket"; // Import the socket instance

// Initialize the video player if the video element is present
const video = document.getElementById("video");

if (video) {
  console.log("Video element found, initializing player and video.");
  const playerId = video.getAttribute("data-player-id");
  const player = new Player();

  player.init(video.id, playerId, () => {
    console.log("Player ready!");
  });

  // Initialize the Video object with the socket and video element
  Video.init(socket, video);
} else {
  console.log("No video element found.");
}

// Configure and initialize LiveSocket
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken }
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", _info => topbar.show(300));
window.addEventListener("phx:page-loading-stop", _info => topbar.hide());

// Connect LiveSocket if there are any LiveViews on the page
liveSocket.connect();

// Expose liveSocket on window for web console debug logs and latency simulation
window.liveSocket = liveSocket;
