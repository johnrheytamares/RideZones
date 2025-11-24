<template>
  <div class="contact-page bg-gray-50 min-h-screen flex flex-col">

    <!-- Header (Exact same as Cars page) -->
    <header class="bg-white shadow-sm p-4 flex justify-between items-center sticky top-0 z-50">
      <h1 class="text-2xl font-semibold text-red-600">RideZone</h1>
      <nav class="space-x-6 text-gray-700 font-medium flex items-center">
        <router-link to="/" class="hover:text-red-600">Home</router-link>
        <router-link to="/cars-page" class="hover:text-red-600">Cars</router-link>
        <router-link to="/about" class="hover:text-red-600">About</router-link>
        <router-link to="/contact" class="text-red-600 border-b-2 border-red-600">Contact</router-link>
        <router-link to="/google-form" class="hover:text-red-600">Feedback</router-link>
        <!-- <button @click="$router.push({ name: 'login' })"
          class="px-5 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition font-medium">
          Login
        </button> -->
      </nav>
    </header>

    <!-- Main Content -->
    <div class="flex-1 p-6">
      <div class="max-w-6xl mx-auto">

        <!-- Page Title -->
        <div class="text-center mb-12">
          <h1 class="text-4xl md:text-5xl font-bold text-gray-800 mb-4">
            Get In Touch With Us
          </h1>
          <p class="text-lg text-gray-600 max-w-2xl mx-auto">
            Have questions? Want to book a test drive? Our team is ready to help you find your perfect ride.
          </p>
        </div>

        <div class="grid lg:grid-cols-2 gap-10">

          <!-- Contact Info Card (Same style as filters sidebar) -->
          <aside class="bg-white p-8 rounded-2xl shadow-lg space-y-8 border border-gray-100">
            <h2 class="text-2xl font-bold text-gray-800 flex items-center gap-3">
              <div class="w-12 h-12 bg-red-600 rounded-xl flex items-center justify-center text-white">
                <i class="fas fa-headset text-xl"></i>
              </div>
              Contact Information
            </h2>

            <div class="space-y-6">
              <div class="flex items-start gap-5">
                <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-phone-alt text-red-600 text-xl"></i>
                </div>
                <div>
                  <p class="text-gray-600 font-medium">Phone</p>
                  <p class="text-xl font-bold text-gray-800">+63 912 345 6789</p>
                  <p class="text-sm text-gray-500">Mon–Sat: 8AM–7PM • Sun: 10AM–5PM</p>
                </div>
              </div>

              <div class="flex items-start gap-5">
                <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-envelope text-red-600 text-xl"></i>
                </div>
                <div>
                  <p class="text-gray-600 font-medium">Email</p>
                  <p class="text-xl font-bold text-gray-800">sales@ridezone.ph</p>
                  <p class="text-sm text-gray-500">We reply within 24 hours</p>
                </div>
              </div>

              <div class="flex items-start gap-5">
                <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-map-marker-alt text-red-600 text-xl"></i>
                </div>
                <div>
                  <p class="text-gray-600 font-medium">Showroom Address</p>
                  <p class="text-xl font-bold text-gray-800">123 Auto Drive, Manila, Philippines</p>
                  <p class="text-sm text-gray-500">Near SM Mall of Asia</p>
                </div>
              </div>
            </div>

            <!-- Social Links -->
            <div class="pt-6 border-t border-gray-200">
              <p class="text-gray-600 font-medium mb-4">Follow Us</p>
              <div class="flex gap-4">
                <a href="#" class="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center hover:bg-red-600 hover:text-white transition">
                  <i class="fab fa-facebook-f"></i>
                </a>
                <a href="#" class="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center hover:bg-red-600 hover:text-white transition">
                  <i class="fab fa-instagram"></i>
                </a>
                <a href="#" class="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center hover:bg-red-600 hover:text-white transition">
                  <i class="fab fa-tiktok"></i>
                </a>
                <a href="#" class="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center hover:bg-red-600 hover:text-white transition">
                  <i class="fab fa-youtube"></i>
                </a>
              </div>
            </div>
          </aside>

          <!-- Google Maps (Same card style) -->
          <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
            <div class="p-6 border-b border-gray-100">
              <h2 class="text-2xl font-bold text-gray-800 flex items-center gap-3">
                <div class="w-12 h-12 bg-red-600 rounded-xl flex items-center justify-center text-white">
                  <i class="fas fa-map text-xl"></i>
                </div>
                Visit Our Showroom
              </h2>
            </div>
            <div class="aspect-w-16 aspect-h-9">
              <iframe 
                src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d3264.449272164198!2d121.16797922293794!3d13.343663153786602!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x33bced0059cfbc8f%3A0xfeeddde9d147a69!2sBYD%20Calapan!5e0!3m2!1sen!2sph!4v1763618195824!5m2!1sen!2sph"
                width="100%"
                height="500"
                style="border:0;"
                allowfullscreen=""
                loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"
                class="w-full">
              </iframe>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Footer (Same as Cars page) -->
    <FooterSection />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import FooterSection from './pages/FooterSection.vue';
</script>

<style scoped>
/* Same clean, professional look as your Cars page */
.contact-page {
  font-family: 'Poppins', sans-serif;
}

.aspect-w-16 {
  position: relative;
  padding-bottom: 56.25%; /* 16:9 */
}

.aspect-w-16 iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

/* Hover effects */
button:hover, a:hover {
  transform: translateY(-1px);
}
</style>