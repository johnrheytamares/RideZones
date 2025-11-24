<template>
  <div class="user-management min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Luxury red glow -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="icon-circle">
              <i class="fas fa-shield-alt text-2xl"></i>
            </div>
            <div>
              <h1 class="text-3xl font-bold">User Management</h1>
              <p class="text-gray-400 text-sm mt-1 opacity-90">
                Create, edit, and manage all system users • {{ users.length }} total
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <div class="stat-box">
              <i class="fas fa-users text-xl text-red-500"></i>
              <div class="mt-3 text-center">
                <div class="text-2xl font-bold">{{ users.length }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Total Users</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-user-shield text-xl text-amber-500"></i>
              <div class="mt-3 text-center">
                <div class="text-2xl font-bold">{{ adminCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Admins</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-store text-xl text-emerald-500"></i>
              <div class="mt-3 text-center">
                <div class="text-2xl font-bold">{{ dealerCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Dealers</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Grid: Form Left + Table Right -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- LEFT: Form -->
        <div class="glass-panel rounded-2xl p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i :class="isEditing ? 'fas fa-user-edit text-amber-500' : 'fas fa-user-plus text-emerald-500'"></i>
              {{ isEditing ? 'Update User' : 'Create New User' }}
            </h3>
            <span class="text-xs px-4 py-2 rounded-full font-bold"
                  :class="isEditing 
                    ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' 
                    : 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'">
              {{ isEditing ? 'EDITING' : 'CREATING' }}
            </span>
          </div>

          <form @submit.prevent="submitForm" class="space-y-5">
            <div v-if="errorMessage" class="bg-rose-500/10 border border-rose-500/30 text-rose-400 px-4 py-3 rounded-lg text-sm">
              {{ errorMessage }}
            </div>

            <div>
              <label class="text-xs text-gray-400 mb-2 block">Full Name *</label>
              <input v-model="form.name" required placeholder="John Doe"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>

            <div>
              <label class="text-xs text-gray-400 mb-2 block">Email *</label>
              <input v-model="form.email" type="email" required :disabled="isEditing" placeholder="user@example.com"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>

            <div>
              <label class="text-xs text-gray-400 mb-2 block">
                Password {{ isEditing ? '(leave blank to keep current)' : '*' }}
              </label>
              <input v-model="form.password" type="password" :required="!isEditing"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>

            <div>
              <label class="text-xs text-gray-400 mb-2 block">Phone (Optional)</label>
              <input v-model="form.phone" placeholder="+639171234567"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>

            <div>
              <label class="text-xs text-gray-400 mb-2 block">Role *</label>
              <select v-model="form.role" required
                      class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition">
                <option value="buyer">Customer</option>
                <option value="dealer">Dealer</option>
                <option value="admin">Administrator</option>
              </select>
            </div>

            <div class="flex gap-4 pt-4">
              <button v-if="isEditing" type="button" @click="cancelEdit"
                      class="flex-1 px-6 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg text-sm font-medium transition">
                Cancel
              </button>
              <button type="submit" :disabled="loading"
                      class="flex-1 px-8 py-3 rounded-lg font-bold text-sm transition shadow-lg flex items-center justify-center gap-2"
                      :class="isEditing 
                        ? 'bg-gradient-to-r from-amber-600 to-orange-700 hover:from-amber-700 hover:to-orange-800' 
                        : 'bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800'">
                <i :class="loading ? 'fas fa-spinner fa-spin' : isEditing ? 'fas fa-save' : 'fas fa-plus'"></i>
                {{ loading ? 'Saving...' : (isEditing ? 'Update User' : 'Create User') }}
              </button>
            </div>
          </form>
        </div>

        <!-- RIGHT: Users Table -->
        <div class="lg:col-span-2 glass-panel rounded-2xl p-6">
          <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-users text-red-500"></i>
              Users List
            </h3>
            <div class="flex flex-wrap items-center gap-3">
              <div class="relative">
                <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-500"></i>
                <input v-model="searchQuery" @input="debouncedSearch" placeholder="Search name or email..."
                       class="pl-11 pr-4 py-3 bg-white/5 border border-white/10 rounded-lg text-sm w-64 focus:border-red-500 focus:outline-none transition" />
              </div>
              <select v-model="filterRole" @change="applyFilters"
                      class="px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-sm">
                <option value="">All Roles</option>
                <option value="admin">Admin</option>
                <option value="dealer">Dealer</option>
                <option value="buyer">Customer</option>
              </select>
              <button @click="fetchUsers" class="p-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg transition">
                <i class="fas fa-sync-alt" :class="{ 'animate-spin': loading }"></i>
              </button>
            </div>
          </div>

          <!-- Empty State -->
          <div v-if="!loading && filteredUsers.length === 0" class="text-center py-20">
            <i class="fas fa-users-slash text-6xl text-gray-600 mb-4"></i>
            <p class="text-gray-400">No users found</p>
          </div>

          <!-- Table -->
          <div v-else class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-400 border-b border-white/10">
                  <th class="pb-4">ID</th>
                  <th class="pb-4">Name</th>
                  <th class="pb-4">Email</th>
                  <th class="pb-4">Role</th>
                  <th class="pb-4">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5">
                <tr v-for="u in pagedUsers" :key="u.id"
                    class="hover:bg-white/5 transition"
                    :class="{ 'bg-amber-500/5 border-l-4 border-amber-500': isEditing && editId === u.id }">
                  <td class="py-5 font-mono text-sm">#{{ u.id }}</td>
                  <td class="py-5 font-medium">{{ u.name }}</td>
                  <td class="py-5 text-sm">{{ u.email }}</td>
                  <td class="py-5">
                    <span class="px-4 py-2 rounded-full text-xs font-bold"
                          :class="{
                            'bg-rose-500/10 text-rose-400 border border-rose-500/20': u.role === 'admin',
                            'bg-amber-500/10 text-amber-400 border border-amber-500/20': u.role === 'dealer',
                            'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20': u.role === 'buyer'
                          }">
                      {{ u.role === 'buyer' ? 'Customer' : u.role.toUpperCase() }}
                    </span>
                  </td>
                  <td class="py-5">
                    <div class="flex gap-2">
                      <button @click="editUser(u)"
                              class="p-2 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg transition">
                        <i class="fas fa-edit"></i>
                      </button>
                      <button @click="deleteUser(u.id)"
                              :disabled="u.id === currentUser.id || (u.role === 'admin' && adminCount <= 1)"
                              class="p-2 bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 rounded-lg transition disabled:opacity-50">
                        <i class="fas fa-trash"></i>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>

            <!-- Pagination -->
            <div v-if="totalPages > 1" class="flex justify-between items-center mt-6 text-sm">
              <div class="text-gray-400">
                Showing {{ startIndex }}–{{ endIndex }} of {{ filteredUsers.length }}
              </div>
              <div class="flex gap-2">
                <button @click="currentPage--" :disabled="currentPage <= 1"
                        class="px-4 py-2 bg-white/5 hover:bg-white/10 rounded-lg disabled:opacity-50">Prev</button>
                <button v-for="p in pageNumbers" :key="p"
                        @click="currentPage = p"
                        class="px-4 py-2 rounded-lg"
                        :class="p === currentPage ? 'bg-red-600 text-white' : 'bg-white/5 hover:bg-white/10'">
                  {{ p }}
                </button>
                <button @click="currentPage++" :disabled="currentPage >= totalPages"
                        class="px-4 py-2 bg-white/5 hover:bg-white/10 rounded-lg disabled:opacity-50">Next</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <div v-if="toastMessage" class="fixed bottom-8 right-8 px-6 py-4 rounded-xl font-bold text-sm shadow-2xl z-50 animate-slideIn"
         :class="toastType === 'success' ? 'bg-emerald-600' : 'bg-rose-600'">
      {{ toastMessage }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'

const API_BASE = 'http://localhost:8000/api/user'
const loading = ref(false)
const users = ref([])
const isEditing = ref(false)
const editId = ref(null)
const errorMessage = ref('')
const toastMessage = ref('')
const toastType = ref('success')
const currentUser = ref({ id: null })

const form = ref({
  name: '', email: '', password: '', phone: '', role: 'buyer'
})

const searchQuery = ref('')
const filterRole = ref('')
const filteredUsers = ref([])
const currentPage = ref(1)
const perPage = 8

// Stats
const adminCount = computed(() => users.value.filter(u => u.role === 'admin').length)
const dealerCount = computed(() => users.value.filter(u => u.role === 'dealer').length)

// Pagination
const totalPages = computed(() => Math.ceil(filteredUsers.value.length / perPage))
const startIndex = computed(() => (currentPage.value - 1) * perPage + 1)
const endIndex = computed(() => Math.min(currentPage.value * perPage, filteredUsers.value.length))
const pageNumbers = computed(() => {
  const pages = []
  for (let i = Math.max(1, currentPage.value - 2); i <= Math.min(totalPages.value, currentPage.value + 2); i++) {
    pages.push(i)
  }
  return pages
})

const pagedUsers = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filteredUsers.value.slice(start, start + perPage)
})

watch(filteredUsers, () => currentPage.value = 1)

let searchTimeout
const debouncedSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(applyFilters, 300)
}

const getToken = () => localStorage.getItem('access_token')
const getHeaders = () => ({
  'Content-Type': 'application/json',
  Authorization: `Bearer ${getToken()}`
})

const submitForm = async () => {
  errorMessage.value = ''
  loading.value = true

  const url = isEditing.value ? `${API_BASE}/update/${editId.value}` : `${API_BASE}/create`
  const method = isEditing.value ? 'PUT' : 'POST'
  const body = { ...form.value }
  if (isEditing.value && !body.password) delete body.password

  try {
    const res = await fetch(url, { method, headers: getHeaders(), body: JSON.stringify(body) })
    const data = await res.json()
    if (res.ok) {
      toast(isEditing.value ? 'User updated!' : 'User created!')
      cancelEdit()
      fetchUsers()
    } else {
      errorMessage.value = data.message || 'Operation failed'
    }
  } catch {
    errorMessage.value = 'Network error'
  } finally {
    loading.value = false
  }
}

const deleteUser = async (id) => {
  if (!confirm('Delete this user permanently?')) return
  loading.value = true
  try {
    await fetch(`${API_BASE}/delete/${id}`, { method: 'DELETE', headers: getHeaders() })
    toast('User deleted')
    fetchUsers()
  } catch {
    toast('Delete failed', 'error')
  } finally {
    loading.value = false
  }
}

const editUser = (user) => {
  isEditing.value = true
  editId.value = user.id
  form.value = { ...user, password: '' }
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const cancelEdit = () => {
  isEditing.value = false
  editId.value = null
  form.value = { name: '', email: '', password: '', phone: '', role: 'buyer' }
  errorMessage.value = ''
}

const fetchUsers = async () => {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/list`, { headers: getHeaders() })
    const data = await res.json()
    users.value = Array.isArray(data) ? data : data.users || []
    applyFilters()
  } catch (e) { console.error(e) }
  finally { loading.value = false }
}

const applyFilters = () => {
  let result = users.value

  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    result = result.filter(u => 
      u.name.toLowerCase().includes(q) || u.email.toLowerCase().includes(q)
    )
  }
  if (filterRole.value) {
    result = result.filter(u => u.role === filterRole.value)
  }

  filteredUsers.value = result
}

const toast = (msg, type = 'success') => {
  toastMessage.value = msg
  toastType.value = type
  setTimeout(() => toastMessage.value = '', 4000)
}

onMounted(() => {
  const token = getToken()
  if (token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]))
      currentUser.value.id = payload.sub
    } catch {}
  }
  fetchUsers()
})
</script>

<style scoped>
.glow-bg {
  position: absolute;
  inset: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(239,68,68,0.06) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(239,68,68,0.04) 0%, transparent 50%);
  pointer-events: none;
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
  transition: all 0.2s;
}

.stat-box:hover {
  background: rgba(255,255,255,0.04);
  transform: translateY(-4px);
}

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
</style>