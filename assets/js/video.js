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
    const player = new Player();
    player.init(element.id, playerId, () => this.onReady(videoId, socket, player));
  }

  static onReady(videoId, socket, player) {
    const msgContainer = document.getElementById("msg-container");
    const msgInput = document.getElementById("msg-input");
    const commentInput = document.getElementById("comment-input");
    const postButton = document.getElementById("msg-submit");

    if (!msgContainer || !msgInput || !commentInput || !postButton) {
      console.error("One or more required elements not found");
      return;
    }

    const vidChannel = socket.channel(`videos:${videoId}`);

    console.log("Joining video channel:", vidChannel);

    postButton.addEventListener("click", () => {
      const message = msgInput.value.trim(); // Get trimmed value
      const comment = commentInput.value.trim(); // Get trimmed value

      // Validation check
      if (message === "" && comment === "") {
        alert("Please enter a message or comment before posting.");
        return; // Exit the function if both are empty
      }

      const payload = {
        body: message,
        comment: comment,
        at: player.getCurrentTime()
      };

      console.log("Posting annotation:", payload);
      
      vidChannel.push("new_annotation", payload)
        .receive("ok", resp => {
          console.log("Annotation sent successfully", resp);
          msgInput.value = ""; // Clear the input fields
          commentInput.value = ""; // Clear the input fields
          alert("Annotation posted!");
        })
        .receive("error", e => console.log("Error sending annotation", e));
    });

    vidChannel.on("new_annotation", (resp) => {
      console.log("Received new annotation:", resp);
      this.renderAnnotation(msgContainer, resp);
    });

    vidChannel.join()
      .receive("ok", resp => console.log("Joined the video channel", resp))
      .receive("error", reason => console.log("Join failed", reason));
  }

  static esc(str) {
    const div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  static renderAnnotation(msgContainer, { user, body, comment, at }) {
    const template = document.createElement("div");
    
    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        <b>${this.esc(user.email)}</b>: ${this.esc(body)}
        <p>${this.esc(comment)}</p>
      </a>
    `;
    
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  }
}

export default Video;
