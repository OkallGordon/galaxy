# Galaxy Web App

Welcome to **Galaxy Web App**, a cutting-edge modular application developed with **Phoenix** and **Elixir**. This project is designed to revolutionize the way users interact with videos by enabling real-time annotations, comments, and a seamless viewing experience. With an intuitive user interface and robust functionality, Galaxy App brings a new dimension to video consumption and engagement.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Design](#design)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

## Overview

**Galaxy Web App** is inspired by the concept of adding commentary and interactive features to video playback, reminiscent of the beloved show *Mystery Science Theater 3000*. Users can choose from a library of videos, add comments in real-time, and play them back with their annotations synced to the video timeline. This allows for a unique collaborative viewing experience that enhances the enjoyment and understanding of video content.

### How It Works

- **Video Selection:** Users can browse and select videos from a curated library.
- **Real-time Commenting:** While watching a video, users can add comments that appear at specific timestamps, allowing for dynamic interaction.
- **Playback Synchronization:** Comments are displayed in sync with the video, ensuring that viewers can easily relate their thoughts to specific moments.

## Features

- **User Authentication:** Secure user login and registration, enabling personalized experiences.
- **Interactive Video Playback:** Comment on videos while watching, with comments appearing at precise moments.
- **Rich Video Library:** A variety of videos categorized for easy navigation and discovery.
- **Responsive Design:** Optimized for various devices, ensuring a smooth experience whether on desktop or mobile.
- **Community Engagement:** Users can interact with each other’s comments, creating a lively discussion around each video.

## Technology Stack

**Galaxy Web App** is built using a robust stack of technologies that ensure performance, scalability, and ease of development:
- **Elixir:** A functional programming language known for its concurrency and fault-tolerance, perfect for building scalable applications.
- **Phoenix Framework:** A web development framework for Elixir that provides high productivity and performance, enabling real-time features via channels.
- **Ecto:** A database wrapper and query generator for Elixir, used for database interactions.
- **PostgreSQL:** An open-source relational database management system that serves as the backend for storing video and user data.
- **JavaScript:** Used for creating dynamic and interactive user interfaces without requiring complex front-end frameworks.

## Getting Started

To get started with **Galaxy Web App**, follow the instructions below to set it up on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:
- **Elixir** (version 1.17.0 or later)
- **Erlang** (version 26 or later)
- **PostgreSQL** (for database management)
- **Node.js** (for managing assets and JavaScript dependencies)

### Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/G-ordon/galaxy.git
    ```

2. **Navigate to the project directory:**
    ```bash
    cd galaxy
    ```

3. **Install Elixir dependencies:**
    ```bash
    mix deps.get
    ```

4. **Install Node.js dependencies for the front-end:**
    ```bash
    cd assets && npm install
    ```

5. **Set up the database:**
    ```bash
    mix ecto.create && mix ecto.migrate
    ```

6. **Run the Phoenix server:**
    ```bash
    mix phx.server
    ```

7. **Open the app in your browser:**
    ```
    http://localhost:4000
    ```

## Usage

- Upon opening the application, users can navigate through the video library to discover new content.
- Selecting a video will initiate playback, and users can interact with the video by adding comments.
- Comments can be added during playback, appearing at specific timestamps for contextual relevance.
- Users can view all comments in a sidebar, fostering a collaborative viewing experience.

## Design

The design of **Galaxy Web App** prioritizes user experience and engagement. The user interface is intuitive, with clear navigation paths and interactive elements that encourage users to participate. Responsive design ensures accessibility on various devices, making it easy for users to watch videos and interact with comments whether they are on a desktop, tablet, or smartphone.

### User Interface Components
- **Video Player:** An embedded video player that supports playback and controls.
- **Comment Section:** A real-time display of comments synchronized with the video timeline.
- **Navigation Bar:** Easy access to various sections of the app, including user profile, video library, and settings.

## Future Enhancements

The vision for **Galaxy Web App** includes numerous enhancements and features that could be implemented in future updates:
- **User Profiles:** Personalized profiles where users can manage their comments and video preferences.
- **Social Sharing:** Options for users to share their favorite videos and comments on social media platforms.
- **Comment Moderation:** Features for users to report inappropriate comments and manage community guidelines.
- **Search Functionality:** Advanced search options to find videos based on categories, tags, or user ratings.

## Contributing

We welcome contributions to **Galaxy Web App**! If you'd like to contribute, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch for your feature or bug fix:**
    ```bash
    git checkout -b feature/my-feature
    ```
3. **Commit your changes:**
    ```bash
    git commit -m "Add feature"
    ```
4. **Push to the branch:**
    ```bash
    git push origin feature/my-feature
    ```
5. **Open a pull request and describe your changes.**

## License

This project is licensed under the [MIT License](LICENSE). Please see the LICENSE file for details.
