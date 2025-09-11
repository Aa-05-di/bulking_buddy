# BULKING BUDDY

<div align="center">

<img width="216" height="216" alt="ChatGPT Image Sep 10, 2025 at 09_16_41 PM" src="https://github.com/user-attachments/assets/c25e332d-d7de-4ac1-a1a1-1169073c6103" />



Bulking Buddy 💪🥪
A hyper-local, full-stack marketplace for fitness enthusiasts to buy and sell high-protein, home-cooked meals, complete with an AI-powered workout planner.

</div>

# Table of Contents

[About The Project](https://github.com/Aa-05-di/bulking_buddy/edit/main/README.md#about-the-project)

[Key Features](https://github.com/Aa-05-di/bulking_buddy/edit/main/README.md#-key-features)

For Buyers

For Sellers

[Gallery](https://github.com/Aa-05-di/bulking_buddy/edit/main/README.md#%EF%B8%8F-gallery)

[Tech Stack](https://github.com/Aa-05-di/bulking_buddy/edit/main/README.md#-tech-stack)

Getting Started

Prerequisites

Backend Setup

Frontend Setup

# About The Project
Bulking Buddy is a mobile application designed to bridge the gap between home chefs who produce healthy, high-protein meals and fitness-focused individuals who need convenient, nutritious food options. It creates a complete, end-to-end e-commerce experience within a local community and integrates a unique AI feature to provide daily, personalized workout advice based on the user's nutritional intake.

# ✨ Key Features
For Buyers (Fitness Enthusiasts)

Hyper-Local Discovery: Finds and displays high-protein meals from sellers in the user's immediate locality.

Seamless Shopping: A smooth and intuitive interface for browsing items, adding to the cart, and managing quantities.

Flexible Ordering: Users can choose between local Delivery (with a nominal fee) or free Pickup.

Order Tracking: A dedicated "My Orders" page to track the status of current and past orders.

AI Workout Planner: A unique, integrated feature that:

Calculates daily protein intake based on purchases.

Allows users to add other meals they've eaten.

Uses the Google Gemini API to generate a personalized workout plan for the day, tailored to the user's specific muscle group split and total protein consumption.

Customizable Workout Split: Users can edit their weekly workout schedule (e.g., Chest Day, Leg Day, Rest Day) to match their personal routine.

For Sellers (Home Chefs)

Easy Product Listing: A simple form for sellers to add new products, including details like price, protein content, and initial stock quantity.

Image Uploads: Sellers can take a picture with their phone's camera, which is automatically uploaded to Cloudinary to get a live image URL.

Order Management: A "Received Orders" dashboard to view and manage incoming orders, with options to "Accept" or mark as "Delivered".

Stock Management: A dedicated page for sellers to view and update the stock quantity of their items in real-time.

## 🖼️ Gallery  

<div align="center">

<!-- Row 1 -->
<img src="https://github.com/user-attachments/assets/e2c7bbcc-d615-4e13-8fa6-b14fde540169" width="180" />
<img src="https://github.com/user-attachments/assets/7ac42af6-76d9-4548-8ca7-ae8467f2124b" width="180" />
<img src="https://github.com/user-attachments/assets/67316a93-9752-4c2a-aac6-d42ada082c27" width="180" />
<img src="https://github.com/user-attachments/assets/b15c33ad-443f-42fd-a443-9fbfe123356e" width="180" />

<!-- Row 2 -->
<img src="https://github.com/user-attachments/assets/c0f99e53-5671-44f2-a0c9-bba0f5d634de" width="180" />
<img src="https://github.com/user-attachments/assets/195b32a3-299d-41fb-ac99-f73e01383e13" width="180" />
<img src="https://github.com/user-attachments/assets/113a49ca-9b50-4269-9d38-168916ecdb54" width="180" />
<img src="https://github.com/user-attachments/assets/17e624f7-3ec0-4ce2-8b13-832f63ce261d" width="180" />

<!-- Row 3 -->
<img src="https://github.com/user-attachments/assets/be5e38f8-fe45-422b-bd22-71883e315b83" width="180" />
<img src="https://github.com/user-attachments/assets/b9c64c7f-558e-4122-8946-eb38d0adf64c" width="180" />
<img src="https://github.com/user-attachments/assets/56bae99f-5590-4b84-a882-a763b8372aaf" width="180" />
<img src="https://github.com/user-attachments/assets/7cf48abd-e4e5-40a7-a762-aa4e7cdb3ad4" width="180" />

<!-- Row 4 -->
<img src="https://github.com/user-attachments/assets/3161022c-2a1c-42f4-8370-89a0924db037" width="180" />

</div>




# 🚀 Tech Stack
Frontend (Mobile):

Framework: Flutter

State Management: setState

Animation: Lottie, animated_text_kit, flutter_staggered_animations

Services: image_picker, shared_preferences

Backend:

Framework: Node.js with Express.js

Database: MongoDB with Mongoose

Deployment: Render

Third-Party Services:

Google Gemini API: For generative AI workout plans.

Cloudinary: For cloud-based image hosting and management.

⚙️ Getting Started
To get a local copy up and running, follow these simple steps.

Prerequisites

Node.js and npm installed on your machine.

Flutter SDK installed and configured.

A code editor like VS Code.

Access to a MongoDB Atlas cluster.

A Google Gemini API key.

A Cloudinary account.

Backend Setup (bulkbuddyroute)

Clone the repository:

git clone [https://github.com/Aa-05-di/bulkingbuddybackend.git](https://github.com/Aa-05-di/bulkingbuddybackend.git)
cd bulkingbuddybackend

Install dependencies:

npm install

Create a .env file in the root of the backend folder and add your secret keys:

MONGO="YOUR_MONGODB_PASSWORD_HERE"
GEMINI_API_KEY="YOUR_GEMINI_API_KEY_HERE"

Start the server:

npm start

The server will be running on http://localhost:8000.

Frontend Setup (FIRST_PRO)

Clone the repository:

git clone [https://github.com/Aa-05-di/bulking_buddy.git](https://github.com/Aa-05-di/bulking_buddy.git)
cd bulking_buddy

Install dependencies:

flutter pub get

Configure the API URL:
Open the lib/api/api.dart file. The baseurl is already configured to automatically point to your local backend when you run the app in debug mode.

Run the app:
Connect a device or start an emulator and run the app from your IDE, or use the command:

flutter run

