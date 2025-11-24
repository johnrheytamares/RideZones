<template>
  <div class="inventory-dashboard min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Ultra-subtle luxury glow -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="icon-circle">
              <i class="fas fa-warehouse text-2xl"></i>
            </div>
            <div>
              <h1 class="text-3xl font-bold">Car Inventory</h1>
              <p class="text-gray-400 text-sm mt-1 opacity-90">
                Complete overview • {{ cars.length }} vehicles in stock
              </p>
            </div>
          </div>

          <!-- Stats Grid -->
          <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
            <div class="stat-box">
              <i class="fas fa-car text-xl text-red-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ cars.length }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Total</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-check-circle text-xl text-emerald-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ availableCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Available</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-clock text-xl text-amber-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ reservedCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Reserved</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-dollar-sign text-xl text-rose-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ soldCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Sold</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Filters + Table Panel -->
      <div class="glass-panel rounded-2xl overflow-hidden">
        <!-- Compact Filters -->
        <div class="p-6 border-b border-white/5">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-filter text-red-500"></i>
              Inventory Filters
            </h3>
            <span class="text-xs text-gray-400 bg-white/5 px-4 py-2 rounded-full">VIEW MODE</span>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-5 gap-4">
            <div>
              <label class="text-xs text-gray-400 mb-1 block">Search</label>
              <input v-model="filters.search" placeholder="Make, model, year..." 
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-1 block">Make</label>
              <select v-model="filters.make" class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition">
                <option value="">All Makes</option>
                <option v-for="make in makes" :key="make" :value="make">{{ make }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-1 block">Status</label>
              <select v-model="filters.status" class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition">
                <option value="">All Status</option>
                <option value="available">Available</option>
                <option value="reserved">Reserved</option>
                <option value="sold">Sold</option>
              </select>
            </div>
            <div class="lg:col-span-2 xl:col-span-1">
              <label class="text-xs text-gray-400 mb-1 block">Price Range</label>
              <div class="flex items-center gap-3">
                <input v-model.number="filters.minPrice" type="number" placeholder="Min" 
                       class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
                <span class="text-gray-500">→</span>
                <input v-model.number="filters.maxPrice" type="number" placeholder="Max" 
                       class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
              </div>
            </div>
            <div class="flex items-end gap-3">
              <button @click="fetchCars" class="flex-1 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg px-5 py-3 text-sm font-medium transition flex items-center justify-center gap-2">
                <i class="fas fa-sync-alt"></i> Refresh
              </button>
              <button @click="exportCSV" class="flex-1 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 rounded-lg px-5 py-3 text-sm font-bold transition shadow-lg flex items-center justify-center gap-2">
                <i class="fas fa-download"></i> Export
              </button>
            </div>
          </div>
        </div>

        <!-- Table -->
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-list text-red-500"></i>
              Vehicle List
            </h3>
            <span class="text-sm text-gray-400">{{ filteredCars.length }} vehicles found</span>
          </div>

          <!-- Loading / Empty State -->
          <div v-if="loading" class="text-center py-20">
            <div class="inline-block">
              <div class="spinner"></div>
              <p class="text-gray-400 mt-4">Loading inventory...</p>
            </div>
          </div>

          <div v-else-if="filteredCars.length === 0" class="text-center py-20 bg-white/5 rounded-2xl border border-white/10">
            <i class="fas fa-car-crash text-6xl text-gray-600 mb-4"></i>
            <h3 class="text-xl font-bold text-gray-400">No vehicles found</h3>
            <p class="text-gray-500 mt-2">Try adjusting your filters</p>
          </div>

          <!-- Table -->
          <div v-else class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-400 border-b border-white/10">
                  <th class="pb-4 font-medium">ID</th>
                  <th class="pb-4 font-medium">Make</th>
                  <th class="pb-4 font-medium">Model</th>
                  <th class="pb-4 font-medium">Year</th>
                  <th class="pb-4 font-medium">Price</th>
                  <th class="pb-4 font-medium">Status</th>
                  <th class="pb-4 font-medium">Image</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5">
                <tr v-for="car in filteredCars" :key="car.id" class="hover:bg-white/5 transition">
                  <td class="py-5 text-sm font-mono">#{{ car.id }}</td>
                  <td class="py-5">
                    <div class="font-medium">{{ car.make }}</div>
                  </td>
                  <td class="py-5">
                    <div class="font-medium">{{ car.model }} {{ car.variant || '' }}</div>
                  </td>
                  <td class="py-5">
                    <span class="px-3 py-1 bg-blue-500/10 text-blue-400 rounded-full text-xs font-medium">{{ car.year }}</span>
                  </td>
                  <td class="py-5 font-bold text-red-500">₱{{ Number(car.price).toLocaleString() }}</td>
                  <td class="py-5">
                    <span class="px-4 py-2 rounded-full text-xs font-bold"
                          :class="{
                            'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20': car.status === 'available',
                            'bg-amber-500/10 text-amber-400 border border-amber-500/20': car.status === 'reserved',
                            'bg-rose-500/10 text-rose-400 border border-rose-500/20': car.status === 'sold'
                          }">
                      {{ car.status.charAt(0).toUpperCase() + car.status.slice(1) }}
                    </span>
                  </td>
                  <td class="py-5">
                    <img v-if="car.main_image"
                         :src="car.main_image.startsWith('http') ? car.main_image : 'http://localhost:8000' + car.main_image"
                         class="w-20 h-14 object-cover rounded-lg shadow-lg border border-white/10"
                         alt="Car" />
                    <div v-else class="w-20 h-14 bg-white/5 rounded-lg border border-white/10 flex items-center justify-center">
                      <i class="fas fa-image text-gray-600"></i>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const cars = ref([])
const loading = ref(true)

const filters = ref({
  search: '',
  make: '',
  status: '',
  minPrice: null,
  maxPrice: null
})

const makes = computed(() => [...new Set(cars.value.map(c => c.make))].sort())

const filteredCars = computed(() => {
  return cars.value.filter(car => {
    const search = filters.value.search.toLowerCase()
    const matchesSearch = !search || `${car.make} ${car.model} ${car.year}`.toLowerCase().includes(search)
    const matchesMake = !filters.value.make || car.make === filters.value.make
    const matchesStatus = !filters.value.status || car.status === filters.value.status
    const matchesMin = !filters.value.minPrice || car.price >= filters.value.minPrice
    const matchesMax = !filters.value.maxPrice || car.price <= filters.value.maxPrice
    return matchesSearch && matchesMake && matchesStatus && matchesMin && matchesMax
  })
})

const availableCount = computed(() => cars.value.filter(c => c.status === 'available').length)
const reservedCount = computed(() => cars.value.filter(c => c.status === 'reserved').length)
const soldCount = computed(() => cars.value.filter(c => c.status === 'sold').length)

const fetchCars = async () => {
  loading.value = true
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    if (!['admin', 'dealer'].includes(user.role)) {
      alert('Access denied')
      return
    }

    const res = await fetch('http://localhost:8000/listcars', {
      headers: { 'X-User': JSON.stringify(user) }
    })
    const data = await res.json()
    if (data.status === 'success') cars.value = data.cars || []
  } catch (err) {
    console.error(err)
  } finally {
    loading.value = false
  }
}

const exportCSV = () => {
  const headers = 'ID,Make,Model,Year,Price,Status\n'
  const rows = filteredCars.value.map(c => `${c.id},${c.make},${c.model},${c.year},${c.price},${c.status}`).join('\n')
  const csv = headers + rows
  const blob = new Blob([csv], { type: 'text/csv' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `ridezone_inventory_${new Date().toISOString().slice(0,10)}.csv`
  a.click()
}

onMounted(fetchCars)
</script>

<style scoped>
.glow-bg {
  position: absolute;
  inset: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(239,68,68,0.06) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(239,68,68,0.04) 0%, transparent 50%);
  pointer-events: none;
  z-index: 0;
}

.glass-panel {
  background: rgba(255,255,255,0.025);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255,255,255,0.06);
  box-shadow: 0 8px 32px rgba(0,0,0,0.37);
}

.icon-circle {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #ef4444, #b91c1c);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 25px rgba(239,68,68,0.35);
}

.stat-box {
  background: rgba(255,255,255,0.025);
  padding: 20px;
  border-radius: 14px;
  border: 1px solid rgba(255,255,255,0.06);
  text-align: center;
  transition: all 0.2s;
}

.stat-box:hover {
  background: rgba(255,255,255,0.04);
  transform: translateY(-4px);
}

.spinner {
  width: 60px;
  height: 60px;
  border: 5px solid rgba(239,68,68,0.2);
  border-top-color: #ef4444;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>