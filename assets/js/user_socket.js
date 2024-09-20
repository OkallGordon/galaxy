import { Socket } from "phoenix";

// Replace with your actual user token
const userToken = "your_user_token"; 

const socket = new Socket("/socket", { params: { userToken: userToken } });

socket.connect();

// Join the video channel
const videoId = 5; // This could be dynamic based on the video being viewed
const videoChannel = socket.channel(`videos:${videoId}`);

videoChannel.join()
    .receive("ok", resp => { 
        console.log("Joined successfully", resp);
    })
    .receive("error", resp => { 
        console.error("Unable to join", resp); 
    });

// Function to send annotations
function sendAnnotation(annotation, comment = "") {
    

    videoChannel.push('new_annotation', payload)
        .receive('ok', response => { 
            console.log('Annotation sent:', response); 
            // Optionally update the UI here
        })
        .receive('error', response => { 
            console.error('Failed to send annotation:', response); 
        });
}

// Function to render annotation in the UI
function renderAnnotation({ user, body, comment }) {
    const msgContainer = document.getElementById("msg-container");
    const template = document.createElement("div");

    template.innerHTML = `
      <b>${user ? user.email : "Anonymous"}</b>: ${body}
      <p>${comment}</p>
    `;

    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight; // Scroll to the bottom
}

// Listen for incoming annotations
videoChannel.on("new_annotation", (annotation) => {
    console.log("Received new annotation:", annotation);
    renderAnnotation(annotation);
});

// Example usage: Call this function on a button click or form submission
document.getElementById("msg-submit").addEventListener("click", () => {
    const msgInput = document.getElementById("msg-input");
    const commentInput = document.getElementById("comment-input");
    
    const annotation = msgInput.value;
    const comment = commentInput.value;

    sendAnnotation(annotation, comment);

    // Clear input fields
    msgInput.value = "";
    commentInput.value = "";
});

// Export the socket instance for use in other modules
export default socket;
