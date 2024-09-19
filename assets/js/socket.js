// socket.js
import { Socket } from "phoenix";

// Create and export a socket instance
const socket = new Socket("/socket", {
  params: { token: window.userToken }, // Ensure window.userToken is set correctly
  logger: (kind, msg, data) => console.log(`${kind}: ${msg}`, data),
});

socket.connect();

export default socket;
