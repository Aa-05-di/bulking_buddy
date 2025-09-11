# BULKING BUDDY

Bulking Buddy 💪🥪
Bulking Buddy is a full-stack, hyper-local marketplace mobile application designed to connect home-based sellers of high-protein meals with fitness enthusiasts. The app features a complete e-commerce experience and an integrated, AI-powered daily workout planner to create a holistic fitness and nutrition tool.

✨ Features
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

🚀 Tech Stack
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

⚙️ Setup & Installation
To run this project locally, you will need to set up both the backend server and the frontend application.

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


