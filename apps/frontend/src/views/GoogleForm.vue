<!-- src/views/FeedbackPage.vue -->
<template>
      <header class="bg-white shadow-sm p-4 flex justify-between items-center sticky top-0 z-50">
      <h1 class="text-2xl font-semibold text-red-600">RideZone</h1>
      <nav class="space-x-6 text-gray-700 font-medium flex items-center">
        <router-link to="/" class="hover:text-red-600">Home</router-link>
        <router-link to="/cars-page" class="hover:text-red-600">Cars</router-link>
        <router-link to="/about" class="hover:text-red-600">About</router-link>
        <router-link to="/contact" class="hover:text-red-600">Contact</router-link>
        <router-link to="/google-form" class="text-red-600 border-b-2 border-red-600">Feedback</router-link>
        <!-- <button @click="$router.push({ name: 'login' })" class="px-5 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition font-medium">
          Login
        </button> -->
      </nav>
    </header>
  <div class="feedback-wrapper">
    <div class="header">
      <h1>We Value Your Feedback 🚘</h1>
      <p>Your insights help us improve and build a better experience.</p>
    </div>

    <div class="form-container">
      <iframe
        :src="formUrl"
        frameborder="0"
        marginheight="0"
        marginwidth="0"
        class="google-form"
        allowfullscreen
        loading="lazy"
      >
        Loading…
      </iframe>
    </div>

    <!-- Optional: Back button or small footer -->
    <div class="footer-note">
      <router-link to="/" class="back-link">← Back to Home</router-link>
      <p>Thank you for your feedback!</p>
    </div>
  </div>
  <FooterSection />
</template>

<script setup>
import FooterSection from './pages/FooterSection.vue';

const formUrl = "https://docs.google.com/forms/d/e/1FAIpQLSf3qlrFTZdg5Ec53aJscTlBPbqXirqJyx648YVSUy-iYeNtIw/viewform?usp=header"
</script>

<style scoped>
.feedback-wrapper {
  min-height: 100vh;
  background: linear-gradient(135deg, #ffe0e0 0%, #fff0f0 100%);
  padding: 60px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  animation: fadeIn 1s ease-in-out;
}

.header {
  text-align: center;
  margin-bottom: 40px;
  animation: floatUp 1s ease-out;
}

.header h1 {
  font-size: 3rem;
  font-weight: 800;
  color: #cc0000;
  margin-bottom: 12px;
  text-shadow: 0 2px 10px rgba(204, 0, 0, 0.1);
}

.header p {
  font-size: 1.25rem;
  color: #666;
  max-width: 700px;
  margin: 0 auto;
}

.form-container {
  width: 100%;
  max-width: 900px;
  height: 80vh;
  min-height: 600px;
  background: rgba(255, 255, 255, 0.92);
  border-radius: 24px;
  padding: 24px;
  box-shadow: 0 25px 50px rgba(204, 0, 0, 0.18);
  border: 1px solid rgba(204, 0, 0, 0.15);
  backdrop-filter: blur(12px);
  animation: floatUp 1.2s ease-out;
}

.google-form {
  width: 100%;
  height: 100%;
  border-radius: 16px;
  border: none;
}

/* Footer */
.footer-note {
  margin-top: 40px;
  text-align: center;
  font-size: 1rem;
  color: #888;
}

.back-link {
  display: inline-block;
  margin-bottom: 10px;
  color: #cc0000;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
}

.back-link:hover {
  color: #990000;
  text-decoration: underline;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}

@keyframes floatUp {
  from { 
    opacity: 0; 
    transform: translateY(40px); 
  }
  to { 
    opacity: 1; 
    transform: translateY(0); 
  }
}

/* Responsive */
@media (max-width: 768px) {
  .header h1 {
    font-size: 2.4rem;
  }
  .form-container {
    height: 75vh;
    padding: 16px;
  }
}
</style>