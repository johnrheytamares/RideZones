<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm p-4 flex justify-between items-center sticky top-0 z-50">
      <h1 class="text-2xl font-semibold text-red-600">RideZone</h1>
      <nav class="space-x-6 text-gray-700 font-medium flex items-center">
        <router-link to="/" class="hover:text-red-600">Home</router-link>
        <router-link to="/cars-page" class="hover:text-red-600">Cars</router-link>
        <router-link to="/about" class="text-red-600 border-b-2 border-red-600">About</router-link>
        <router-link to="/contact" class="hover:text-red-600">Contact</router-link>
        <router-link to="/google-form" class="hover:text-red-600">Feedback</router-link>
        <!-- <button @click="$router.push({ name: 'login' })" class="px-5 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition font-medium">
          Login
        </button> -->
      </nav>
    </header>
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-red-700 via-red-600 to-gray-700 text-white py-32 overflow-hidden">
      <div class="absolute inset-0 bg-black/50"></div>
      <div class="absolute inset-0 bg-[url('/hero-about.jpg')] bg-cover bg-center opacity-20"></div>
      
      <div class="relative max-w-6xl mx-auto px-6 text-center">
        <h1 class="text-5xl md:text-7xl font-bold tracking-tight mb-6">
          Welcome to <span class="text-red-400">RideZone</span>
        </h1>
        <p class="text-xl md:text-2xl font-light max-w-4xl mx-auto leading-relaxed">
          Your trusted partner in finding the perfect luxury and premium vehicle in the Philippines.
        </p>
        <div class="mt-10 flex justify-center gap-6">
          <div class="text-center">
            <p class="text-5xl font-bold">10+</p>
            <p class="text-lg opacity-90">Years of Excellence</p>
          </div>
          <div class="text-center">
            <p class="text-5xl font-bold">500+</p>
            <p class="text-lg opacity-90">Happy Clients</p>
          </div>
          <div class="text-center">
            <p class="text-5xl font-bold">50+</p>
            <p class="text-lg opacity-90">Premium Brands</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Our Story -->
    <section class="py-20 px-6 bg-white">
      <div class="max-w-6xl mx-auto grid md:grid-cols-2 gap-12 items-center">
        <div>
          <h2 class="text-4xl font-bold text-gray-800 mb-6">Our Story</h2>
          <p class="text-lg text-gray-700 leading-relaxed mb-6">
            Founded in 2015, <strong>RideZone</strong> was born from a simple idea: 
            to make finding and owning your dream car a seamless, trustworthy, and enjoyable experience.
          </p>
          <p class="text-lg text-gray-700 leading-relaxed mb-6">
            We saw too many people frustrated with traditional dealerships — hidden fees, pressure sales, and lack of transparency. 
            So we built RideZone differently.
          </p>
          <p class="text-lg text-gray-700 leading-relaxed">
            Today, we are proud to be one of the most trusted names in premium and luxury car sales in the Philippines — 
            known for honesty, quality, and exceptional customer care.
          </p>
        </div>
        <div class="rounded-2xl overflow-hidden shadow-2xl">
          <img src="" alt="RideZone Team" class="w-full h-full object-cover">
        </div>
      </div>
    </section>

    <!-- Mission & Vision -->
    <section class="py-20 bg-gray-100">
      <div class="max-w-6xl mx-auto px-6">
        <div class="grid md:grid-cols-2 gap-12">
          <div class="bg-white p-10 rounded-3xl shadow-xl border border-gray-200">
            <div class="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center mb-6">
              <i class="fas fa-bullseye text-3xl text-white"></i>
            </div>
            <h3 class="text-3xl font-bold text-gray-800 mb-4">Our Mission</h3>
            <p class="text-lg text-gray-700 leading-relaxed">
              To deliver an unmatched car-buying experience through transparency, quality vehicles, 
              and personalized service that puts our customers first — always.
            </p>
          </div>

          <div class="bg-white p-10 rounded-3xl shadow-xl border border-gray-200">
            <div class="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center mb-6">
              <i class="fas fa-eye text-3xl text-white"></i>
            </div>
            <h3 class="text-3xl font-bold text-gray-800 mb-4">Our Vision</h3>
            <p class="text-lg text-gray-700 leading-relaxed">
              To be the most trusted and preferred destination for premium vehicles in the Philippines, 
              where every journey begins with confidence and excitement.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Why Choose Us -->
    <section class="py-20 bg-white">
      <div class="max-w-6xl mx-auto px-6 text-center">
        <h2 class="text-4xl font-bold text-gray-800 mb-4">Why Choose RideZone?</h2>
        <p class="text-xl text-gray-600 mb-16 max-w-3xl mx-auto">
          We don’t just sell cars. We deliver peace of mind.
        </p>

        <div class="grid md:grid-cols-3 gap-10">
          <div class="bg-gradient-to-br from-red-50 to-red-100 p-8 rounded-2xl border-2 border-red-200">
            <i class="fas fa-shield-alt text-5xl text-red-600 mb-6"></i>
            <h4 class="text-2xl font-bold text-gray-800 mb-4">100% Verified Cars</h4>
            <p class="text-gray-700">Every vehicle is thoroughly inspected and comes with complete documentation.</p>
          </div>

          <div class="bg-gradient-to-br from-emerald-50 to-green-100 p-8 rounded-2xl border-2 border-emerald-200">
            <i class="fas fa-handshake text-5xl text-emerald-600 mb-6"></i>
            <h4 class="text-2xl font-bold text-gray-800 mb-4">No Hidden Fees</h4>
            <p class="text-gray-700">Transparent pricing. What you see is what you pay — no surprises.</p>
          </div>

          <div class="bg-gradient-to-br from-blue-50 to-indigo-100 p-8 rounded-2xl border-2 border-blue-200">
            <i class="fas fa-headset text-5xl text-blue-600 mb-6"></i>
            <h4 class="text-2xl font-bold text-gray-800 mb-4">Lifetime Support</h4>
            <p class="text-gray-700">We’re with you before, during, and long after your purchase.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-20 bg-gradient-to-r from-red-600 to-red-800 text-white text-center">
      <div class="max-w-4xl mx-auto px-6">
        <h2 class="text-4xl md:text-5xl font-bold mb-6">Ready to Find Your Dream Car?</h2>
        <p class="text-xl mb-10 opacity-90">Explore our premium collection today.</p>
        <router-link to="/cars-page" class="inline-block px-12 py-5 bg-white text-red-600 font-bold text-xl rounded-full hover:bg-gray-100 transition shadow-xl">
          Browse Cars Now
        </router-link>
      </div>
    </section>
    <FooterSection />
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import FooterSection from './FooterSection.vue'


// Optional: Add scroll animation
onMounted(() => {
  document.title = "About Us - RideZone Premium Cars"
})
</script>

<style scoped>
/* Optional: Add subtle parallax effect */
section {
  background-attachment: fixed;
  background-position: center;
  background-size: cover;
}
</style>