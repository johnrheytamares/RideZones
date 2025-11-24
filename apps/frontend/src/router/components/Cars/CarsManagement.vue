<template>
  <div class="cars-dashboard min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Luxury Red Glow Background -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header Panel -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="icon-circle">
              <i class="fas fa-car-side text-2xl"></i>
            </div>
            <div>
              <h1 class="text-3xl font-bold">Cars Management</h1>
              <p class="text-gray-400 text-sm mt-1 opacity-90">
                Manage vehicle inventory • {{ cars.length }} total vehicles
              </p>
            </div>
          </div>

          <!-- Stats -->
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 w-full lg:w-auto">
            <div class="stat-box">
              <i class="fas fa-car text-2xl text-red-500"></i>
              <div class="mt-4 text-center">
                <div class="text-3xl font-bold">{{ cars.length }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Total Vehicles</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-check-circle text-2xl text-emerald-500"></i>
              <div class="mt-4 text-center">
                <div class="text-3xl font-bold">{{ availableCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Available</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-clock text-2xl text-amber-500"></i>
              <div class="mt-4 text-center">
                <div class="text-3xl font-bold">{{ reservedCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Reserved</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Panel -->
      <div class="glass-panel rounded-2xl overflow-hidden">
        <!-- Form Section -->
        <div class="p-8 border-b border-white/5">
          <div class="flex items-center justify-between mb-8">
            <h3 class="text-xl font-bold flex items-center gap-3">
              <i :class="isEditing ? 'fas fa-edit text-amber-500' : 'fas fa-plus text-emerald-500'"></i>
              {{ isEditing ? 'Update Vehicle' : 'Add New Vehicle' }}
            </h3>
            <span class="text-xs px-5 py-2 rounded-full font-bold border"
                  :class="isEditing 
                    ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' 
                    : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'">
              {{ isEditing ? 'EDITING MODE' : 'CREATING NEW' }}
            </span>
          </div>

          <form @submit.prevent="isEditing ? updateCar() : createCar()" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
            <!-- Basic Info -->
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Dealer ID *</label>
              <input v-model.number="form.dealer_id" type="number" required placeholder="1"
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Make *</label>
              <input v-model="form.make" required placeholder="Toyota, BMW"
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Model *</label>
              <input v-model="form.model" required placeholder="Camry, X5"
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Variant</label>
              <input v-model="form.variant" placeholder="Hybrid, M Sport"
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Year *</label>
              <input v-model.number="form.year" type="number" min="2000" max="2030" required
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Price (₱)</label>
              <input v-model.number="form.price" type="number" placeholder="2,500,000"
                     class="input-field" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Status</label>
              <select v-model="form.status" class="input-field">
                <option value="available">Available</option>
                <option value="reserved">Reserved</option>
                <option value="sold">Sold</option>
                <option value="draft">Draft</option>
              </select>
            </div>

            <!-- Warranty Section -->
            <div class="xl:col-span-4 mt-6 pt-6 border-t border-white/10">
              <h4 class="text-sm font-bold text-red-500 mb-5 flex items-center gap-3">
                <i class="fas fa-shield-alt"></i> Warranty & Service Information
              </h4>
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                  <label class="text-xs text-gray-400 mb-2 block">Warranty Period (months)</label>
                  <input v-model.number="form.warranty_period" type="number" min="0" max="120" placeholder="36"
                         class="input-field" />
                </div>
                <div>
                  <label class="text-xs text-gray-400 mb-2 block">Start Date</label>
                  <input v-model="form.warranty_start_date" type="date" @change="calculateWarrantyEnd"
                         class="input-field" />
                </div>
                <div>
                  <label class="text-xs text-gray-400 mb-2 block">End Date (Auto)</label>
                  <input :value="form.warranty_end_date" type="date" readonly class="input-field opacity-70" />
                </div>
              </div>
            </div>

            <!-- Image Upload -->
            <div class="xl:col-span-4">
              <label class="text-xs text-gray-400 mb-2 block">Main Image</label>
              <input ref="imageInput" type="file" accept="image/jpeg,image/jpg,image/png" @change="handleImageUpload" class="hidden" />
              <div @click="$refs.imageInput.click()" 
                   class="image-upload-box" :class="{ 'has-image': previewImage }">
                <div v-if="!previewImage" class="upload-placeholder">
                  <i class="fas fa-cloud-upload-alt text-6xl text-gray-500 mb-4"></i>
                  <p class="text-sm text-gray-400">Click to upload • Max 2MB • JPG/PNG</p>
                </div>
                <img v-else :src="previewImage" class="preview-img" />
              </div>
              <p class="text-xs text-gray-500 mt-2">{{ form.main_image ? 'Image uploaded successfully' : 'No image selected' }}</p>
            </div>

            <!-- Description & Service History -->
            <div class="xl:col-span-4 grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div>
                <label class="text-xs text-gray-400 mb-2 block">Description</label>
                <textarea v-model="form.description" rows="5" placeholder="Premium leather seats, panoramic sunroof, full service history..."
                          class="input-field resize-none"></textarea>
              </div>
              <div>
                <label class="text-xs text-gray-400 mb-2 block">Service History</label>
                <textarea v-model="form.service_history" rows="5" placeholder="• Oil Change - 5,000 km - Jan 15, 2024&#10;• Brake Service - 20,000 km - Jun 10, 2024"
                          class="input-field resize-none font-mono text-xs"></textarea>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="xl:col-span-4 flex gap-4 justify-end mt-6">
              <button v-if="isEditing" type="button" @click="cancelEdit"
                      class="px-8 py-4 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-sm font-bold transition">
                Cancel Edit
              </button>
              <button type="submit" :disabled="loading"
                      class="px-10 py-4 rounded-xl font-bold text-sm transition shadow-2xl flex items-center gap-3"
                      :class="isEditing 
                        ? 'bg-gradient-to-r from-amber-600 to-orange-700 hover:from-amber-700 hover:to-orange-800' 
                        : 'bg-gradient-to-r from-red-600 to-red-800 hover:from-red-700 hover:to-red-900'">
                <i :class="loading ? 'fas fa-spinner fa-spin' : (isEditing ? 'fas fa-save' : 'fas fa-plus')"></i>
                {{ loading ? 'Saving...' : (isEditing ? 'Update Vehicle' : 'Add Vehicle') }}
              </button>
            </div>
          </form>
        </div>

        <!-- Table Section -->
        <div class="p-8">
          <div class="flex justify-between items-center mb-8">
            <h3 class="text-xl font-bold flex items-center gap-3">
              <i class="fas fa-th-list text-red-500"></i>
              Vehicle Inventory
            </h3>
            <button @click="fetchCars" class="flex items-center gap-3 px-6 py-4 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-sm font-bold transition">
              <i class="fas fa-sync-alt" :class="{ 'animate-spin': loading }"></i>
              Refresh List
            </button>
          </div>

          <!-- Empty State -->
          <div v-if="!loading && cars.length === 0" class="text-center py-24 bg-white/5 rounded-2xl border border-white/10">
            <i class="fas fa-car-crash text-8xl text-gray-700 mb-6"></i>
            <h3 class="text-2xl font-bold text-gray-400 mb-3">No Vehicles Found</h3>
            <p class="text-gray-500">Start building your luxury inventory</p>
          </div>

          <!-- Cars Table -->
          <div v-else class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-400 border-b border-white/10">
                  <th class="pb-5">ID</th>
                  <th class="pb-5">Dealer</th>
                  <th class="pb-5">Vehicle</th>
                  <th class="pb-5">Year</th>
                  <th class="pb-5">Price</th>
                  <th class="pb-5">Status</th>
                  <th class="pb-5">Warranty</th>
                  <th class="pb-5">Image</th>
                  <th class="pb-5">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5">
                <tr v-for="car in cars" :key="car.id"
                    class="hover:bg-white/5 transition"
                    :class="{ 'bg-amber-500/5 border-l-4 border-amber-500': isEditing && editId === car.id }">
                  <td class="py-6 font-mono text-sm">#{{ car.id }}</td>
                  <td class="py-6">{{ car.dealer_id }}</td>
                  <td class="py-6 font-semibold">{{ car.make }} {{ car.model }} {{ car.variant || '' }}</td>
                  <td class="py-6">
                    <span class="px-4 py-2 bg-blue-500/10 text-blue-400 rounded-full text-xs font-bold">{{ car.year }}</span>
                  </td>
                  <td class="py-6 font-bold">₱{{ Number(car.price).toLocaleString() }}</td>
                  <td class="py-6">
                    <span class="px-4 py-2 rounded-full text-xs font-bold"
                          :class="{
                            'bg-emerald-500/10 text-emerald-400': car.status === 'available',
                            'bg-amber-500/10 text-amber-400': car.status === 'reserved',
                            'bg-rose-500/10 text-rose-400': car.status === 'sold',
                            'bg-gray-500/10 text-gray-400': car.status === 'draft'
                          }">
                      {{ car.status.toUpperCase() }}
                    </span>
                  </td>
                  <td class="py-6 text-sm">
                    <span v-if="car.warranty_end_date" class="text-emerald-400">
                      Until {{ formatDate(car.warranty_end_date) }}
                    </span>
                    <span v-else class="text-gray-500">—</span>
                  </td>
                  <td class="py-6">
                    <img v-if="car.main_image"
                         :src="getCarImage(car.main_image)"
                         class="w-24 h-16 object-cover rounded-xl border border-white/10 shadow-lg" />
                    <div v-else class="w-24 h-16 bg-white/5 rounded-xl border-2 border-dashed border-white/20 flex items-center justify-center">
                      <i class="fas fa-image text-gray-600"></i>
                    </div>
                  </td>
                  <td class="py-6">
                    <div class="flex gap-3">
                      <button @click="editCar(car)"
                              class="p-3 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-xl transition"
                              :disabled="isEditing">
                        <i class="fas fa-edit"></i>
                      </button>
                      <button @click="deleteCar(car.id)"
                              class="p-3 bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 rounded-xl transition"
                              :disabled="isEditing">
                        <i class="fas fa-trash"></i>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast Notification -->
    <div v-if="toast.show" class="fixed bottom-8 right-8 px-8 py-5 rounded-2xl font-bold text-sm shadow-2xl z-50 animate-slideIn"
         :class="toast.type === 'success' ? 'bg-emerald-600' : 'bg-rose-600'">
      {{ toast.message }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'

const loading = ref(false)
const cars = ref([])
const isEditing = ref(false)
const editId = ref(null)
const previewImage = ref('')
const toast = ref({ show: false, message: '', type: 'success' })

const form = ref({
  dealer_id: '', make: '', model: '', variant: '', year: '', price: '',
  main_image: '', description: '', status: 'available',
  warranty_period: 36, warranty_start_date: '', warranty_end_date: '', service_history: ''
})

const API_BASE = 'http://localhost:8000'

const availableCount = computed(() => cars.value.filter(c => c.status === 'available').length)
const reservedCount = computed(() => cars.value.filter(c => c.status === 'reserved').length)

const getCarImage = (path) => {
  if (!path) return '/default-car.jpg'
  return path.startsWith('http') || path.startsWith('data:') ? path : `${API_BASE}${path.startsWith('/') ? '' : '/'}${path}`
}

const calculateWarrantyEnd = () => {
  if (!form.value.warranty_start_date || !form.value.warranty_period) {
    form.value.warranty_end_date = ''
    return
  }
  const start = new Date(form.value.warranty_start_date)
  const end = new Date(start)
  end.setMonth(end.getMonth() + Number(form.value.warranty_period))
  form.value.warranty_end_date = end.toISOString().split('T')[0]
}

const formatDate = (d) => new Date(d).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })

const showToast = (message, type = 'success') => {
  toast.value = { show: true, message, type }
  setTimeout(() => toast.value.show = false, 4000)
}

const handleImageUpload = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  if (!['image/jpeg','image/jpg','image/png'].includes(file.type)) return showToast('JPG/PNG only!', 'error')
  if (file.size > 2*1024*1024) return showToast('Max 2MB!', 'error')

  const formData = new FormData()
  formData.append('main_image_file', file)
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/upload-car-image`, { method: 'POST', body: formData })
    const data = await res.json()
    if (data.status === 'success') {
      form.value.main_image = data.url
      previewImage.value = getCarImage(data.url)
      showToast('Image uploaded!')
    }
  } catch { showToast('Upload failed', 'error') } finally { loading.value = false }
}

const fetchCars = async () => {
  loading.value = true
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const res = await fetch(`${API_BASE}/listcars`, {
      headers: { 'X-User': JSON.stringify(user) }
    })
    const data = await res.json()
    if (data.status === 'success') cars.value = data.cars || []
  } catch { } finally { loading.value = false }
}

const createCar = async () => {
  loading.value = true
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const res = await fetch(`${API_BASE}/createcars`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-User': JSON.stringify(user) },
      body: JSON.stringify(form.value)
    })
    const data = await res.json()
    if (data.status === 'success') {
      showToast('Vehicle added successfully!')
      resetForm()
      await fetchCars()
    }
  } catch { showToast('Failed to add vehicle', 'error') } finally { loading.value = false }
}

const updateCar = async () => {
  loading.value = true
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const res = await fetch(`${API_BASE}/updatecars/${editId.value}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', 'X-User': JSON.stringify(user) },
      body: JSON.stringify(form.value)
    })
    if (res.ok) {
      showToast('Vehicle updated successfully!')
      cancelEdit()
      await fetchCars()
    }
  } catch { showToast('Update failed', 'error') } finally { loading.value = false }
}

const deleteCar = async (id) => {
  if (!confirm('Delete this vehicle permanently?')) return
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    await fetch(`${API_BASE}/deletecars/${id}`, {
      method: 'DELETE',
      headers: { 'X-User': JSON.stringify(user) }
    })
    showToast('Vehicle deleted')
    await fetchCars()
  } catch { showToast('Delete failed', 'error') }
}

const editCar = (car) => {
  isEditing.value = true
  editId.value = car.id
  form.value = { ...car }
  previewImage.value = getCarImage(car.main_image)
  document.querySelector('form')?.scrollIntoView({ behavior: 'smooth' })
}

const cancelEdit = () => {
  isEditing.value = false
  editId.value = null
  resetForm()
}

const resetForm = () => {
  form.value = {
    dealer_id: '', make: '', model: '', variant: '', year: '', price: '',
    main_image: '', description: '', status: 'available',
    warranty_period: 36, warranty_start_date: '', warranty_end_date: '', service_history: ''
  }
  previewImage.value = ''
}

onMounted(() => {
  fetchCars()
  // Auto-login admin for testing (remove in production)
  if (!localStorage.getItem('user')) {
    localStorage.setItem('user', JSON.stringify({ id: 1, role: 'admin', dealer_id: 1 }))
  }
})
</script>

<style scoped>
.glow-bg {
  position: absolute;
  inset: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(239,68,68,0.08) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(239,68,68,0.06) 0%, transparent 50%);
  pointer-events: none;
}

.glass-panel {
  background: rgba(255,255,255,0.025);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255,255,255,0.06);
  box-shadow: 0 8px 32px rgba(0,0,0,0.37);
}

.icon-circle {
  width: 70px;
  height: 70px;
  background: linear-gradient(135deg, #ef4444, #b91c1c);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 10px 30px rgba(239,68,68,0.4);
}

.stat-box {
  background: rgba(255,255,255,0.025);
  padding: 24px;
  border-radius: 18px;
  border: 1px solid rgba(255,255,255,0.06);
  transition: all 0.3s ease;
}

.stat-box:hover {
  background: rgba(255,255,255,0.05);
  transform: translateY(-6px);
}

.input-field {
  @apply w-full bg-white/5 border border-white/10 rounded-xl px-5 py-4 text-sm focus:border-red-500 focus:outline-none transition;
}

.image-upload-box {
  @apply border-2 border-dashed border-white/20 rounded-2xl h-56 flex items-center justify-center cursor-pointer transition bg-white/5 hover:bg-white/10;
}

.image-upload-box.has-image {
  @apply border-red-500/50;
}

.preview-img {
  @apply w-full h-full object-cover rounded-2xl;
}

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
</style>