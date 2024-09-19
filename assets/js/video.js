import Player from "./player";

class Video {
  static init(socket, element) {
    if (!element) {
      console.error("No video element found");
      return;
    }

    const playerId = element.getAttribute("data-player-id");
    const videoId = element.getAttribute("data-id");

    console.log("Initializing video with playerId:", playerId, "and videoId:", videoId);
    
    // Ensure socket is connected
    socket.connect();

    // Create an instance of Player and initialize it
    const player = new Player(); // Instantiate Player
    player.init(element.id, playerId, () => this.onReady(videoId, socket, player)); // Pass the player instance
  }

  static onReady(videoId, socket, player) {
    // Check and get DOM elements
    const msgContainer = document.getElementById("msg-container");
    const msgInput = document.getElementById("msg-input");
    const postButton = document.getElementById("msg-submit");
     // New comment input field

    if (!msgContainer) {
      console.error("msg-container element not found");
      return;
    }
    if (!msgInput) {
      console.error("msg-input element not found");
      return;
    }
    if (!postButton) {
      console.error("msg-submit element not found");
      return;
    }
    

    const vidChannel = socket.channel(`videos:${videoId}`);

    console.log("Joining video channel:", vidChannel);

    postButton.addEventListener("click", () => {
      const payload = {
        body: msgInput.value,
        comment: commentInput.value, // Include comment in the payload
        at: player.getCurrentTime() // Use the instance of Player
      };
      
      console.log("Posting annotation:", payload);
      
      vidChannel.push("new_annotation", payload)
        .receive("ok", resp => console.log("Annotation sent successfully", resp))
        .receive("error", e => console.log("Error sending annotation", e));
      
      msgInput.value = ""; // Clear the input field
      commentInput.value = ""; // Clear the comment input field
    });

    vidChannel.on("new_annotation", (resp) => {
      console.log("Received new annotation:", resp);
      this.renderAnnotation(msgContainer, resp);
    });

    vidChannel.join()
      .receive("ok", resp => console.log("Joined the video channel", resp))
      .receive("error", reason => console.log("Join failed", reason));
  }

  // Function to escape user input to prevent XSS attacks
  static esc(str) {
    const div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  // Function to render an annotation
  static renderAnnotation(msgContainer, { user, body, comment, at }) {
    const template = document.createElement("div");
    
    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        <b>${this.esc(user.email)}</b>: ${this.esc(body)}
        <p>${this.esc(comment)}</p> <!-- Display comment -->
      </a>
    `;
    
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight; // Scroll to the bottom
  }
}

export default Video;
