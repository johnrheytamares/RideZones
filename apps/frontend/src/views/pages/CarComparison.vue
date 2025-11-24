<template>
  <!-- SHOW ONLY WHEN EXACTLY 2 CARS ARE SELECTED -->
  <div v-if="compareCount === 2" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-md p-4">
    <div class="w-full max-w-6xl bg-white rounded-3xl shadow-2xl overflow-hidden max-h-[92vh] overflow-y-auto">

      <!-- Luxury Header -->
      <div class="bg-gradient-to-r from-gray-900 via-red-800 to-gray-900 text-white px-8 py-6 flex justify-between items-center">
        <div>
          <h2 class="text-2xl md:text-3xl font-black flex items-center gap-4">
            Car Comparison
          </h2>
          <p class="text-sm opacity-90 mt-1">Side-by-side specs • Warranty • Features</p>
        </div>
        <button @click="clearAndClose" class="w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center transition">
          <i class="fas fa-times text-2xl"></i>
        </button>
      </div>

      <div class="p-6 md:p-8 bg-gradient-to-b from-gray-50 to-white">

        <!-- CAR CARDS (Top) -->
        <div class="grid md:grid-cols-2 gap-8 mb-10">
          <!-- Car 1 -->
          <div class="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden transform hover:scale-[1.02] transition">
            <div class="relative h-64 bg-gray-900">
              <img :src="getImage(car1.main_image)" class="w-full h-full object-cover" alt="Car 1">
              <div class="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent"></div>
              <span class="absolute bottom-4 left-4 text-white text-3xl font-black drop-shadow-lg">
                {{ car1.make }} {{ car1.model }}
              </span>
              <span class="absolute top-4 left-4 bg-red-600 text-white px-4 py-2 rounded-full font-bold text-sm">
                CAR 1
              </span>
            </div>
            <div class="p-6 text-center bg-gradient-to-b from-white to-gray-50">
              <p class="text-3xl font-black text-red-600">₱{{ Number(car1.price).toLocaleString() }}</p>
              <p class="text-sm text-gray-600 mt-2">{{ car1.year }} • {{ car1.mileage?.toLocaleString() || '—' }} km</p>
            </div>
          </div>

          <!-- Car 2 -->
          <div class="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden transform hover:scale-[1.02] transition">
            <div class="relative h-64 bg-gray-900">
              <img :src="getImage(car2.main_image)" class="w-full h-full object-cover" alt="Car 2">
              <div class="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent"></div>
              <span class="absolute bottom-4 left-4 text-white text-3xl font-black drop-shadow-lg">
                {{ car2.make }} {{ car2.model }}
              </span>
              <span class="absolute top-4 left-4 bg-blue-600 text-white px-4 py-2 rounded-full font-bold text-sm">
                CAR 2
              </span>
            </div>
            <div class="p-6 text-center bg-gradient-to-b from-white to-gray-50">
              <p class="text-3xl font-black text-red-600">₱{{ Number(car2.price).toLocaleString() }}</p>
              <p class="text-sm text-gray-600 mt-2">{{ car2.year }} • {{ car2.mileage?.toLocaleString() || '—' }} km</p>
            </div>
          </div>
        </div>

        <!-- COMPARISON TABLE — SOBRANG GANDA! -->
        <div class="bg-white rounded-2xl shadow-lg border overflow-hidden">
          <table class="w-full text-left">
            <thead class="bg-gray-900 text-white">
              <tr>
                <th class="px-6 py-5 text-sm font-bold">Feature</th>
                <th class="px-6 py-5 text-center font-bold">CAR 1</th>
                <th class="px-6 py-5 text-center font-bold">CAR 2</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Price</td>
                <td class="px-6 py-5 text-center font-bold text-red-600">₱{{ Number(car1.price).toLocaleString() }}</td>
                <td class="px-6 py-5 text-center font-bold text-red-600">₱{{ Number(car2.price).toLocaleString() }}</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Year</td>
                <td class="px-6 py-5 text-center">{{ car1.year }}</td>
                <td class="px-6 py-5 text-center">{{ car2.year }}</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Mileage</td>
                <td class="px-6 py-5 text-center">{{ car1.mileage?.toLocaleString() || '—' }} km</td>
                <td class="px-6 py-5 text-center">{{ car2.mileage?.toLocaleString() || '—' }} km</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Transmission</td>
                <td class="px-6 py-5 text-center">{{ car1.transmission || '—' }}</td>
                <td class="px-6 py-5 text-center">{{ car2.transmission || '—' }}</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Fuel Type</td>
                <td class="px-6 py-5 text-center">{{ car1.fuel_type || '—' }}</td>
                <td class="px-6 py-5 text-center">{{ car2.fuel_type || '—' }}</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Color</td>
                <td class="px-6 py-5 text-center">{{ car1.color || '—' }}</td>
                <td class="px-6 py-5 text-center">{{ car2.color || '—' }}</td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Warranty</td>
                <td class="px-6 py-5 text-center text-sm">
                  <span v-if="car1.warranty_end_date" class="text-green-600 font-bold">
                    Until {{ formatDate(car1.warranty_end_date) }}
                  </span>
                  <span v-else class="text-gray-400">No warranty</span>
                </td>
                <td class="px-6 py-5 text-center text-sm">
                  <span v-if="car2.warranty_end_date" class="text-green-600 font-bold">
                    Until {{ formatDate(car2.warranty_end_date) }}
                  </span>
                  <span v-else class="text-gray-400">No warranty</span>
                </td>
              </tr>
              <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-5 font-medium text-gray-700">Status</td>
                <td class="px-6 py-5 text-center">
                  <span :class="car1.status === 'available' ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ car1.status.toUpperCase() }}
                  </span>
                </td>
                <td class="px-6 py-5 text-center">
                  <span :class="car2.status === 'available' ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ car2.status.toUpperCase() }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Action Buttons -->
        <div class="flex justify-center gap-6 mt-10">
          <button @click="clearAndClose" 
                  class="px-10 py-4 bg-gray-200 text-gray-800 font-bold rounded-xl hover:bg-gray-300 transition shadow">
            Clear Comparison
          </button>
          <button @click="continueBrowsing" 
                  class="px-10 py-4 bg-red-600 text-white font-bold rounded-xl hover:bg-red-700 transition shadow-lg">
            Continue Browsing
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const car1 = ref(null)
const car2 = ref(null)
const compareCount = ref(0)

const formatDate = (dateStr) => {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-PH', { month: 'short', year: 'numeric' })
}

const getImage = (path) => {
  if (!path) return '/default-car.jpg'
  return path.startsWith('http') ? path : `http://localhost:8000${path.startsWith('/') ? '' : '/'}${path}`
}

const updateCompare = () => {
  const saved = localStorage.getItem('ridezone_compare')
  const ids = saved ? JSON.parse(saved) : []
  compareCount.value = ids.length

  if (ids.length === 2) {
    fetchCars(ids)
  } else {
    car1.value = car2.value = null
  }
}

const fetchCars = async (ids) => {
  try {
    const res = await fetch('http://localhost:8000/api/compare/cars', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ids })
    })
    const data = await res.json()
    if (data.status === 'success' && data.cars.length === 2) {
      car1.value = data.cars[0]
      car2.value = data.cars[1]
    }
  } catch (err) {
    console.error('Failed to load comparison:', err)
  }
}

const clearAndClose = () => {
  localStorage.removeItem('ridezone_compare')
  updateCompare()
  router.push('/cars-page')
}

const continueBrowsing = () => clearAndClose()

window.addEventListener('storage', updateCompare)
onMounted(() => {
  updateCompare()
  document.addEventListener('visibilitychange', updateCompare)
})
onUnmounted(() => {
  window.removeEventListener('storage', updateCompare)
  document.removeEventListener('visibilitychange', updateCompare)
})
</script>