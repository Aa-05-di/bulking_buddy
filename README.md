# BULKING BUDDY

<div align="center">

<img width="216" height="216" alt="Bulking Buddy Logo" src="https://github.com/user-attachments/assets/c25e332d-d7de-4ac1-a1a1-1169073c6103" />

### Bulking Buddy 💪🥪  
A hyper-local, full-stack marketplace for fitness enthusiasts to buy and sell high-protein, home-cooked meals, complete with an AI-powered workout planner.

</div>

---

# 📑 Table of Contents
- [About The Project](#about-the-project)
- [Key Features](#-key-features)
- [Gallery](#️-gallery)
- [Tech Stack](#-tech-stack)

---

# About The Project
Bulking Buddy is a mobile application designed to bridge the gap between home chefs who produce healthy, high-protein meals and fitness-focused individuals who need convenient, nutritious food options. It creates a complete, end-to-end e-commerce experience within a local community and integrates a unique AI feature to provide daily, personalized workout advice based on the user's nutritional intake.

[Download Bulking Buddy APK now!](https://github.com/Aa-05-di/bulking_buddy/releases/download/v1.0.0/app-release.apk)

---

# ✨ Key Features

## 🏋️ For Buyers
- **🔎 Hyper-Local Discovery**  
  Finds and displays **high-protein meals** from sellers in the user’s immediate locality.  

- **🛒 Seamless Shopping**  
  Smooth and intuitive interface for **browsing items, adding to cart, and managing quantities**.  

- **📦 Flexible Ordering**  
  Choose between **local Delivery** (nominal fee) or **free Pickup**.  

- **📍 Order Tracking**  
  A dedicated **"My Orders" page** to track current and past orders.  

- **🤖 AI Workout Planner** (Powered by **Google Gemini API**)  
  - Calculates **daily protein intake** based on purchases.  
  - Allows users to **add other meals** they've eaten.  
  - Generates a **personalized workout plan** tailored to the user’s muscle group split & protein consumption.  

- **📆 Customizable Workout Split**  
  Users can edit their **weekly workout schedule** (e.g., Chest Day, Leg Day, Rest Day).  

---

## 👨‍🍳 For Sellers
- **📝 Easy Product Listing**  
  Add new products with **price, protein content, and stock quantity** via a simple form.  

- **📸 Image Uploads**  
  Capture product images with phone camera → **auto-uploaded to Cloudinary** for live URLs.  

- **📊 Order Management**  
  A **"Received Orders" dashboard** to view and manage incoming orders with options to **Accept** or **Mark as Delivered**.  

- **📦 Stock Management**  
  A dedicated page to **view and update stock quantity** in real time.  

---

# 🖼️ Gallery  

<table align="center">
<tr>
<td><img src="https://github.com/user-attachments/assets/e2c7bbcc-d615-4e13-8fa6-b14fde540169" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/7ac42af6-76d9-4548-8ca7-ae8467f2124b" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/67316a93-9752-4c2a-aac6-d42ada082c27" width="200"/></td>
</tr>
<tr>
<td><img src="https://github.com/user-attachments/assets/b15c33ad-443f-42fd-a443-9fbfe123356e" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/195b32a3-299d-41fb-ac99-f73e01383e13" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/113a49ca-9b50-4269-9d38-168916ecdb54" width="200"/></td>
</tr>
<tr>
<td><img src="https://github.com/user-attachments/assets/17e624f7-3ec0-4ce2-8b13-832f63ce261d" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/be5e38f8-fe45-422b-bd22-71883e315b83" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/b9c64c7f-558e-4122-8946-eb38d0adf64c" width="200"/></td>
</tr>
<tr>
<td><img src="https://github.com/user-attachments/assets/56bae99f-5590-4b84-a882-a763b8372aaf" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/7cf48abd-e4e5-40a7-a762-aa4e7cdb3ad4" width="200"/></td>
<td><img src="https://github.com/user-attachments/assets/3161022c-2a1c-42f4-8370-89a0924db037" width="200"/></td>
</tr>
</table>


# 📱 Tech Stack

### 🔹 Frontend (Mobile)
- **Framework**: Flutter  
- **State Management**: setState  
- **Animation**: 
  - Lottie  
  - animated_text_kit  
  - flutter_staggered_animations  
- **Services**:  
  - image_picker  
  - shared_preferences  

### 🔹 Backend
- **Framework**: Node.js with Express.js  
- **Database**: MongoDB with Mongoose  
- **Deployment**: Render  

### 🔹 Third-Party Services
- **Google Gemini API** → Generative AI workout plans  
- **Cloudinary** → Cloud-based image hosting & management  
