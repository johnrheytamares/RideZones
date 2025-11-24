<template>
  <div class="cars-page bg-gray-50 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white shadow-sm p-4 flex justify-between items-center sticky top-0 z-50">
      <h1 class="text-2xl font-semibold text-red-600">RideZone</h1>
      <nav class="space-x-6 text-gray-700 font-medium flex items-center">
        <router-link to="/" class="hover:text-red-600">Home</router-link>
        <router-link to="/cars-page" class="text-red-600 border-b-2 border-red-600">Cars</router-link>
        <router-link to="/about" class="hover:text-red-600">About</router-link>
        <router-link to="/contact" class="hover:text-red-600">Contact</router-link>
        <router-link to="/google-form" class="hover:text-red-600">Feedback</router-link>
      </nav>
    </header>

    <!-- Main Content -->
    <div class="flex flex-col md:flex-row flex-1 p-6 gap-6">
      <!-- Filters Sidebar -->
      <aside class="md:w-1/3 lg:w-1/4 bg-white p-5 rounded-xl shadow-md space-y-6">
        <h2 class="text-xl font-semibold text-gray-800 border-b pb-2">Filter Cars</h2>

        <!-- Make -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Make</label>
          <select v-model="filters.make" class="w-full border rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-red-200">
            <option value="">All Makes</option>
            <option v-for="make in carMakes" :key="make" :value="make">{{ make }}</option>
          </select>
        </div>

        <!-- Year -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Year</label>
          <select v-model="filters.year" class="w-full border rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-red-200">
            <option value="">All Years</option>
            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
          </select>
        </div>

        <!-- Price Range -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Price Range (₱)</label>
          <div class="flex items-center gap-2 mb-2">
            <input v-model.number="filters.minPrice" type="number" placeholder="Min" class="w-full border rounded-lg px-3 py-2 text-sm">
            <span class="text-gray-400">—</span>
            <input v-model.number="filters.maxPrice" type="number" placeholder="Max" class="w-full border rounded-lg px-3 py-2 text-sm">
          </div>
          <input type="range" v-model.number="filters.maxPrice" :max="maxPossiblePrice" step="100000" class="w-full">
          <div class="text-xs text-gray-500 mt-1 text-right">Up to ₱{{ filters.maxPrice?.toLocaleString() || '10M' }}</div>
        </div>

        <!-- Transmission -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Transmission</label>
          <div class="flex gap-3">
            <button @click="filters.transmission = 'automatic'"
              :class="filters.transmission === 'automatic' ? 'bg-red-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="flex-1 py-2 rounded-lg border hover:bg-red-600 hover:text-white transition">
              Automatic
            </button>
            <button @click="filters.transmission = 'manual'"
              :class="filters.transmission === 'manual' ? 'bg-red-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="flex-1 py-2 rounded-lg border hover:bg-red-600 hover:text-white transition">
              Manual
            </button>
          </div>
        </div>

        <!-- Fuel Type -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Fuel Type</label>
          <div class="grid grid-cols-2 gap-3">
            <label v-for="fuel in fuelTypes" :key="fuel" class="flex items-center gap-2 cursor-pointer">
              <input type="checkbox" v-model="filters.fuelTypes" :value="fuel" class="w-4 h-4 text-red-600 rounded focus:ring-red-500">
              <span class="text-sm">{{ fuel }}</span>
            </label>
          </div>
        </div>

        <!-- Search -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
          <input v-model="search" type="text" placeholder="Make, model, year..." class="w-full border px-3 py-2 rounded-lg focus:ring-2 focus:ring-red-200 outline-none">
        </div>

        <!-- Buttons -->
        <div class="flex gap-3">
          <button @click="resetFilters" class="flex-1 bg-gray-200 text-gray-800 py-2 rounded-lg hover:bg-gray-300 transition">
            Reset
          </button>
          <button @click="fetchCars" class="flex-1 bg-red-600 text-white py-2 rounded-lg hover:bg-red-700 transition">
            Apply Filters
          </button>
        </div>
      </aside>

      <!-- Car Listings -->
      <main class="flex-1">
        <h1 class="text-3xl font-semibold text-gray-800 mb-6">Available Cars ({{ totalCars }})</h1>

        <div v-if="cars.length" class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="car in cars" :key="car.id" class="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-2xl transition-all duration-300 group relative">

            <!-- Compare Checkbox -->
            <label class="absolute top-4 right-4 z-10 bg-white/95 backdrop-blur px-4 py-2 rounded-full shadow-lg flex items-center gap-2 cursor-pointer border border-gray-200 hover:border-red-400 transition">
              <input type="checkbox" :value="car.id" v-model="compareIds"
                class="w-5 h-5 text-red-600 rounded focus:ring-red-500"
                :disabled="!compareIds.includes(car.id) && compareIds.length >= 2">
              <span class="font-bold text-sm" :class="compareIds.includes(car.id) ? 'text-red-600' : 'text-gray-600'">
                {{ compareIds.includes(car.id) ? 'Added' : 'Compare' }}
              </span>
            </label>

            <!-- Car Image -->
            <div class="relative bg-gray-200 h-52 overflow-hidden">
              <img 
                :src="getCarImage(car.main_image)"
                :alt="car.make + ' ' + car.model"
                class="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                loading="lazy"
                @error="e => e.target.src = '/default-car.jpg'"
              />
            </div>

            <div class="p-5">
              <h2 class="text-xl font-bold text-gray-800">{{ car.make }} {{ car.model }}</h2>
              <p class="text-sm text-gray-500">{{ car.variant || '' }} • {{ car.year }}</p>
              <p class="mt-2 text-gray-600 text-sm line-clamp-2">{{ car.description }}</p>

              <div class="mt-4 flex items-center justify-between">
                <p class="text-2xl font-bold text-red-600">₱{{ Number(car.price).toLocaleString() }}</p>
                <span class="px-3 py-1 text-xs rounded-full font-medium"
                      :class="car.status === 'available' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                  {{ car.status }}
                </span>
              </div>

              <!-- SEE MORE BUTTON -->
              <button @click="openDetailsModal(car)" 
                      class="mt-4 w-full bg-gradient-to-r from-gray-800 to-gray-900 text-white py-3 rounded-lg font-semibold hover:from-gray-900 hover:to-black transition-all shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                See More Details
              </button>

              <!-- Book Test Drive -->
              <button @click="openModal(car.id)"
                      class="mt-2 w-full bg-red-600 text-white py-3 font-medium hover:bg-red-700 transition text-lg rounded-lg">
                Book Drive Test
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-20 text-gray-500">
          <p class="text-xl font-medium">No cars found.</p>
          <p class="mt-2">Try adjusting your filters.</p>
        </div>

        <!-- Pagination -->
        <div v-if="pagination.total_pages > 1" class="flex justify-center items-center mt-12 gap-4">
          <button @click="changePage(pagination.page - 1)" :disabled="pagination.page === 1"
                  class="px-6 py-3 rounded-lg border disabled:opacity-50 hover:bg-gray-50 transition">
            Previous
          </button>
          <span class="text-gray-700 font-medium">Page {{ pagination.page }} of {{ pagination.total_pages }}</span>
          <button @click="changePage(pagination.page + 1)" :disabled="pagination.page === pagination.total_pages"
                  class="px-6 py-3 rounded-lg border disabled:opacity-50 hover:bg-gray-50 transition">
            Next
          </button>
        </div>
      </main>
    </div>

    <!-- LUXURY CAR DETAILS MODAL -->
     <!-- LUXURY & ELEGANT CAR DETAILS MODAL — PERFECT SIZE, SOBRANG CLASSY! -->
<teleport to="body">
  <div v-if="showDetailsModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm">
    <div @click="showDetailsModal = false" class="absolute inset-0"></div>

    <!-- MODAL CARD — KATAMTAMAN LANG, PERO SOBRANG GANDA -->
    <div class="relative bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[88vh] overflow-y-auto">
      
      <!-- Close Button — Maliit pero visible -->
      <button @click="showDetailsModal = false" 
              class="absolute top-4 right-4 z-20 w-10 h-10 bg-white/90 hover:bg-white rounded-full shadow-lg flex items-center justify-center text-gray-600 hover:text-red-600 transition">
        <i class="fas fa-times text-xl"></i>
      </button>

      <div v-if="selectedCarDetail" class="grid md:grid-cols-2 gap-0">

        <!-- LEFT: IMAGE — Mas maliit pero impactful pa rin -->
        <div class="relative h-64 md:h-full min-h-64 overflow-hidden bg-gray-900">
          <img :src="getCarImage(selectedCarDetail.main_image)" 
               :alt="selectedCarDetail.make + ' ' + selectedCarDetail.model"
               class="w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent"></div>
          <div class="absolute bottom-5 left-5 text-white">
            <h1 class="text-3xl md:text-4xl font-bold drop-shadow-lg">{{ selectedCarDetail.make }} {{ selectedCarDetail.model }}</h1>
            <p class="text-lg md:text-xl opacity-90 mt-1">{{ selectedCarDetail.variant || '' }} • {{ selectedCarDetail.year }}</p>
          </div>
        </div>

        <!-- RIGHT: DETAILS — Clean, balanced, elegant -->
        <div class="p-6 md:p-8 space-y-6">

          <!-- Price & Status -->
          <div class="flex items-start justify-between gap-4">
            <div>
              <p class="text-3xl md:text-4xl font-bold text-red-600">₱{{ Number(selectedCarDetail.price).toLocaleString() }}</p>
              <p class="text-sm text-gray-500 mt-1">All fees included</p>
            </div>
            <span class="px-4 py-2 rounded-full text-sm font-bold shadow"
                  :class="selectedCarDetail.status === 'available' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
              {{ selectedCarDetail.status.toUpperCase() }}
            </span>
          </div>

          <!-- Key Specs — Compact grid -->
          <div class="grid grid-cols-2 gap-4 text-sm">
            <div class="bg-gray-50 p-4 rounded-xl">
              <p class="text-gray-500">Mileage</p>
              <p class="font-bold text-gray-800">{{ selectedCarDetail.mileage?.toLocaleString() || '—' }} km</p>
            </div>
            <div class="bg-gray-50 p-4 rounded-xl">
              <p class="text-gray-500">Transmission</p>
              <p class="font-bold text-gray-800">{{ selectedCarDetail.transmission || '—' }}</p>
            </div>
            <div class="bg-gray-50 p-4 rounded-xl">
              <p class="text-gray-500">Fuel Type</p>
              <p class="font-bold text-gray-800">{{ selectedCarDetail.fuel_type || '—' }}</p>
            </div>
            <div class="bg-gray-50 p-4 rounded-xl">
              <p class="text-gray-500">Color</p>
              <p class="font-bold text-gray-800">{{ selectedCarDetail.color || '—' }}</p>
            </div>
          </div>

          <!-- Warranty Badge — Elegant & Compact -->
          <div v-if="selectedCarDetail.warranty_end_date" 
               class="bg-gradient-to-r from-emerald-500 to-teal-600 text-white p-5 rounded-2xl text-center shadow-lg">
            <p class="text-sm opacity-90 font-medium">Warranty Coverage</p>
            <p class="text-2xl font-bold mt-1">{{ formatDate(selectedCarDetail.warranty_end_date) }}</p>
            <p class="text-xs mt-1 opacity-80">{{ selectedCarDetail.warranty_period }} months remaining</p>
          </div>

          <!-- Description -->
          <div>
            <h3 class="font-bold text-lg text-gray-800 mb-3 flex items-center gap-2">
              <i class="fas fa-info-circle text-red-600"></i> Description
            </h3>
            <p class="text-gray-700 leading-relaxed text-sm">
              {{ selectedCarDetail.description || 'No description available.' }}
            </p>
          </div>

          <!-- Service History — Clean list -->
          <div v-if="selectedCarDetail.service_history">
            <h3 class="font-bold text-lg text-gray-800 mb-3 flex items-center gap-2">
              <i class="fas fa-tools text-red-600"></i> Service History
            </h3>
            <div class="space-y-2 text-sm">
              <div v-for="(line, i) in selectedCarDetail.service_history.split('\n').filter(l => l.trim())" 
                   :key="i" class="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                <span class="text-red-600 font-bold text-xs mt-0.5">{{ i + 1 }}</span>
                <span class="text-gray-700">{{ line.trim() }}</span>
              </div>
            </div>
          </div>

          <!-- Action Buttons — Perfect size -->
          <div class="flex gap-3 pt-4">
            <button @click="openModal(selectedCarDetail.id); showDetailsModal = false"
                    class="flex-1 bg-red-600 text-white py-3.5 rounded-xl font-bold text-base hover:bg-red-700 transition shadow-lg">
              <i class="fas fa-car mr-2"></i> Book Test Drive
            </button>
            <button @click="showDetailsModal = false" 
                    class="flex-1 bg-gray-200 text-gray-800 py-3.5 rounded-xl font-bold text-base hover:bg-gray-300 transition">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</teleport>
    

    <!-- Existing Modals -->
    <AppointmentModal :show="showModal" :carId="selectedCar" @close="showModal = false" @saved="onAppointmentSaved" />
    <FooterSection />
    <CarComparison />
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { debounce } from 'lodash-es'
import { useRouter } from 'vue-router'
import AppointmentModal from '../../components/Appointments/AppointmentModal.vue'
import CarComparison from './CarComparison.vue'
import FooterSection from './FooterSection.vue'

const router = useRouter()

// State
const cars = ref([])
const totalCars = ref(0)
const search = ref('')
const filters = ref({
  make: '', year: '', minPrice: null, maxPrice: null,
  transmission: '', fuelTypes: []
})
const pagination = ref({ page: 1, limit: 9, total_pages: 1 })
const carMakes = ['Toyota', 'Honda', 'Ford', 'BMW', 'Nissan', 'Mitsubishi', 'Hyundai', 'Suzuki']
const years = Array.from({ length: 20 }, (_, i) => new Date().getFullYear() - i)
const fuelTypes = ['Gasoline', 'Diesel', 'Electric', 'Hybrid']
const maxPossiblePrice = 10000000

// Modal States
const showModal = ref(false)
const selectedCar = ref(null)
const showDetailsModal = ref(false)
const selectedCarDetail = ref(null)
const compareIds = ref([])

// Image Helper
const getCarImage = (path) => {
  if (!path) return '/default-car.jpg'
  if (path.startsWith('http') || path.startsWith('data:')) return path
  return path.startsWith('/') ? path : `/${path.trim()}`
}

// Format Date
const formatDate = (dateStr) => {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })
}

// Open Details Modal
const openDetailsModal = (car) => {
  selectedCarDetail.value = car
  showDetailsModal.value = true
}

// Open Appointment Modal
const openModal = (carId) => {
  selectedCar.value = carId
  showModal.value = true
}

// Fetch Cars
const fetchCars = async () => {
  try {
    const url = new URL('http://localhost:8000/searchcars')
    url.searchParams.append('page', pagination.value.page)
    url.searchParams.append('limit', pagination.value.limit)
    if (search.value) url.searchParams.append('search', search.value.trim())
    Object.entries(filters.value).forEach(([key, val]) => {
      if (val === null || val === '' || (Array.isArray(val) && val.length === 0)) return
      url.searchParams.append(key, Array.isArray(val) ? val.join(',') : val)
    })

    const res = await fetch(url)
    const data = await res.json()

    if (data.status === 'success') {
      cars.value = data.cars || []
      totalCars.value = data.pagination?.total || 0
      pagination.value.total_pages = data.pagination?.total_pages || 1
    } else {
      cars.value = []
      totalCars.value = 0
    }
  } catch (err) {
    console.error('Error fetching cars:', err)
    cars.value = []
  }
}

// Watchers
watch(search, debounce(() => { pagination.value.page = 1; fetchCars() }, 500))
watch(filters, () => { pagination.value.page = 1; fetchCars() }, { deep: true })
watch(compareIds, (newVal) => {
  const limited = newVal.slice(0, 2)
  if (limited.length !== newVal.length) {
    compareIds.value = limited
    alert('Maximum 2 cars for comparison!')
  }
  localStorage.setItem('ridezone_compare', JSON.stringify(limited))
  if (limited.length === 2) setTimeout(() => router.push('/car-comparison'), 300)
}, { deep: true })

// Pagination
const changePage = (page) => {
  if (page < 1 || page > pagination.value.total_pages) return
  pagination.value.page = page
  fetchCars()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const resetFilters = () => {
  filters.value = { make: '', year: '', minPrice: null, maxPrice: null, transmission: '', fuelTypes: [] }
  search.value = ''
  pagination.value.page = 1
  fetchCars()
}

const onAppointmentSaved = () => fetchCars()

onMounted(() => {
  const saved = localStorage.getItem('ridezone_compare')
  if (saved) compareIds.value = JSON.parse(saved).slice(0, 2)
  fetchCars()
})
</script>

<style scoped>
.line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
</style>