<template>
  <div class="dealers-dashboard min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Luxury subtle glow -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="icon-circle">
              <i class="fas fa-store text-2xl"></i>
            </div>
            <div>
              <h1 class="text-3xl font-bold">Dealers Management</h1>
              <p class="text-gray-400 text-sm mt-1 opacity-90">
                Manage dealership partners • {{ dealers.length }} active dealers
              </p>
            </div>
          </div>

          <!-- Stats -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 gap-5">
            <div class="stat-box">
              <i class="fas fa-store-alt text-xl text-red-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ dealers.length }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Total Dealers</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Panel: Form + Table -->
      <div class="glass-panel rounded-2xl overflow-hidden">
        <!-- Add/Edit Form -->
        <div class="p-6 border-b border-white/5">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i :class="isEditing ? 'fas fa-edit text-amber-500' : 'fas fa-plus text-emerald-500'"></i>
              {{ isEditing ? 'Update Dealer' : 'Add New Dealer' }}
            </h3>
            <span class="text-xs px-4 py-2 rounded-full font-bold"
                  :class="isEditing ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' : 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'">
              {{ isEditing ? 'EDITING' : 'CREATING' }}
            </span>
          </div>

          <form @submit.prevent="isEditing ? updateDealer() : createDealer()" class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Dealer Name *</label>
              <input v-model="form.name" required placeholder="e.g., AutoLux Manila"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Email</label>
              <input v-model="form.email" type="email" placeholder="dealer@example.com"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Phone</label>
              <input v-model="form.phone" placeholder="+63 9XX XXX XXXX"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Address</label>
              <input v-model="form.address" placeholder="123 Main St, Quezon City"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div class="md:col-span-2">
              <label class="text-xs text-gray-400 mb-2 block">Description</label>
              <textarea v-model="form.description" rows="3" placeholder="About this dealership..."
                        class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition resize-none"></textarea>
            </div>

            <!-- Logo Upload -->
            <div class="md:col-span-2">
              <label class="text-xs text-gray-400 mb-2 block">Dealer Logo</label>
              <input ref="logoInput" type="file" accept="image/*" @change="handleLogoUpload" class="hidden" />
              <div @click="$refs.logoInput.click()" 
                   class="border-2 border-dashed border-white/20 rounded-xl h-40 flex items-center justify-center cursor-pointer hover:border-red-500/50 transition
                          bg-white/5 hover:bg-white/10"
                   :class="{ 'border-red-500/50': previewLogo }">
                <div v-if="!previewLogo" class="text-center">
                  <i class="fas fa-cloud-upload-alt text-4xl text-gray-500 mb-3"></i>
                  <p class="text-sm text-gray-400">Click to upload logo (Max 3MB)</p>
                </div>
                <img v-else :src="previewLogo" class="max-h-full rounded-lg" />
              </div>
              <p class="text-xs text-gray-500 mt-2">{{ form.logo ? 'Logo ready' : 'No logo selected' }}</p>
            </div>

            <!-- Actions -->
            <div class="md:col-span-2 flex gap-4 justify-end">
              <button v-if="isEditing" type="button" @click="cancelEdit"
                      class="px-6 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg text-sm font-medium transition">
                Cancel
              </button>
              <button type="submit"
                      class="px-8 py-3 rounded-lg font-bold text-sm transition shadow-lg flex items-center gap-2"
                      :class="isEditing 
                        ? 'bg-gradient-to-r from-amber-600 to-orange-700 hover:from-amber-700 hover:to-orange-800' 
                        : 'bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800'">
                <i :class="isEditing ? 'fas fa-save' : 'fas fa-plus'"></i>
                {{ isEditing ? 'Update Dealer' : 'Add Dealer' }}
              </button>
            </div>
          </form>
        </div>

        <!-- Dealers Table -->
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-list text-red-500"></i>
              Dealer Directory
            </h3>
            <button @click="fetchDealers" class="flex items-center gap-2 px-5 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg text-sm font-medium transition">
              <i class="fas fa-sync-alt"></i> Refresh
            </button>
          </div>

          <!-- Empty State -->
          <div v-if="dealers.length === 0" class="text-center py-20 bg-white/5 rounded-2xl border border-white/10">
            <i class="fas fa-store-slash text-6xl text-gray-600 mb-4"></i>
            <h3 class="text-xl font-bold text-gray-400">No Dealers Found</h3>
            <p class="text-gray-500 mt-2">Add your first dealership partner to get started</p>
          </div>

          <!-- Table -->
          <div v-else class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-400 border-b border-white/10">
                  <th class="pb-4 font-medium">ID</th>
                  <th class="pb-4 font-medium">Logo</th>
                  <th class="pb-4 font-medium">Name</th>
                  <th class="pb-4 font-medium">Email</th>
                  <th class="pb-4 font-medium">Phone</th>
                  <th class="pb-4 font-medium">Address</th>
                  <th class="pb-4 font-medium">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5">
                <tr v-for="dealer in dealers" :key="dealer.id" 
                    class="hover:bg-white/5 transition"
                    :class="{ 'bg-amber-500/5 border-l-4 border-amber-500': isEditing && editId === dealer.id }">
                  <td class="py-5 text-sm font-mono">#{{ dealer.id }}</td>
                  <td class="py-5">
                    <img v-if="dealer.logo"
                         :src="dealer.logo.startsWith('http') ? dealer.logo : 'http://localhost:8000' + dealer.logo"
                         class="w-12 h-12 rounded-full object-cover border-2 border-white/10" />
                    <div v-else class="w-12 h-12 bg-white/5 rounded-full border-2 border-dashed border-white/20"></div>
                  </td>
                  <td class="py-5 font-medium">{{ dealer.name }}</td>
                  <td class="py-5 text-sm">{{ dealer.email || '—' }}</td>
                  <td class="py-5 text-sm">{{ dealer.phone || '—' }}</td>
                  <td class="py-5 text-sm max-w-xs truncate">{{ dealer.address || '—' }}</td>
                  <td class="py-5">
                    <div class="flex gap-2">
                      <button @click="editDealer(dealer)"
                              class="p-2 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg transition"
                              :disabled="isEditing && editId !== dealer.id">
                        <i class="fas fa-edit"></i>
                      </button>
                      <button @click="deleteDealer(dealer.id)"
                              class="p-2 bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 rounded-lg transition"
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const loading = ref(false)
const dealers = ref([])
const isEditing = ref(false)
const editId = ref(null)
const previewLogo = ref('')

const form = ref({
  name: '', email: '', phone: '', address: '', description: '', logo: ''
})

const API_BASE = 'http://localhost:8000'

const showNotification = (msg, type = 'info') => alert(`[${type.toUpperCase()}] ${msg}`)

const handleLogoUpload = async (e) => {
  const file = e.target.files[0]
  if (!file) return
  if (!['image/jpeg','image/jpg','image/png','image/webp'].includes(file.type)) return showNotification('Invalid format', 'error')
  if (file.size > 3*1024*1024) return showNotification('Logo too large', 'error')

  const formData = new FormData()
  formData.append('logo_file', file)
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/dealers/upload-logo`, { method: 'POST', body: formData })
    const data = await res.json()
    if (data.status === 'success') {
      form.value.logo = data.url
      previewLogo.value = `${API_BASE}${data.url}`
      showNotification('Logo uploaded!', 'success')
    }
  } catch { showNotification('Upload failed', 'error') }
  finally { loading.value = false }
}

const fetchDealers = async () => {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/dealers`)
    const data = await res.json()
    if (data.status === 'success') dealers.value = data.dealers
  } catch { } finally { loading.value = false }
}

const createDealer = async () => {
  if (!form.value.name.trim()) return showNotification('Name required', 'error')
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/dealers`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form.value)
    })
    const data = await res.json()
    if (data.status === 'success') {
      await fetchDealers()
      resetForm()
      showNotification('Dealer created!', 'success')
    }
  } catch { } finally { loading.value = false }
}

const updateDealer = async () => {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/dealers/${editId.value}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form.value)
    })
    const data = await res.json()
    if (data.status === 'success') {
      await fetchDealers()
      cancelEdit()
      showNotification('Dealer updated!', 'success')
    }
  } catch { } finally { loading.value = false }
}

const deleteDealer = async (id) => {
  if (!confirm('Delete this dealer permanently?')) return
  loading.value = true
  try {
    await fetch(`${API_BASE}/dealers/${id}`, { method: 'DELETE' })
    await fetchDealers()
    showNotification('Dealer deleted', 'success')
  } catch { } finally { loading.value = false }
}

const editDealer = (dealer) => {
  isEditing.value = true
  editId.value = dealer.id
  form.value = { ...dealer }
  previewLogo.value = dealer.logo ? `${API_BASE}${dealer.logo}` : ''
  document.querySelector('form')?.scrollIntoView({ behavior: 'smooth' })
}

const cancelEdit = () => {
  isEditing.value = false
  editId.value = null
  resetForm()
}

const resetForm = () => {
  form.value = { name: '', email: '', phone: '', address: '', description: '', logo: '' }
  previewLogo.value = ''
}

onMounted(fetchDealers)
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
</style>