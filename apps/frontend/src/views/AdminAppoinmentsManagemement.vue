<template>
  <div class="appointments-dashboard min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Luxury subtle glow -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="icon-circle">
              <i class="fas fa-calendar-check text-2xl"></i>
            </div>
            <div>
              <h1 class="text-3xl font-bold">Appointment Management</h1>
              <p class="text-gray-400 text-sm mt-1 opacity-90">
                Manage client test drives • {{ appointments.length }} total bookings
              </p>
            </div>
          </div>

          <!-- Stats Grid -->
          <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
            <div class="stat-box">
              <i class="fas fa-clock text-xl text-amber-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ appointments.length }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Total</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-hourglass-half text-xl text-yellow-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ pendingCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Pending</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-check-circle text-xl text-emerald-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ approvedCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Approved</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-times-circle text-xl text-rose-500"></i>
              <div class="mt-3">
                <div class="text-2xl font-bold">{{ cancelledCount }}</div>
                <div class="text-xs text-gray-400 uppercase tracking-wider">Cancelled</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Panel -->
      <div class="glass-panel rounded-2xl overflow-hidden">
        <!-- Edit Form -->
        <div class="p-6 border-b border-white/5">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-edit text-amber-500"></i>
              Edit Appointment
            </h3>
            <span class="text-xs px-4 py-2 rounded-full font-bold"
                  :class="selectedAppointment.id 
                    ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' 
                    : 'bg-gray-500/10 text-gray-400 border border-gray-500/20'">
              {{ selectedAppointment.id ? `EDITING #${selectedAppointment.id}` : 'SELECT A ROW TO EDIT' }}
            </span>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Client Name</label>
              <input v-model="clientName" :disabled="!selectedAppointment.id"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Email</label>
              <input v-model="selectedAppointment.email" :disabled="!selectedAppointment.id"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Phone</label>
              <input v-model="selectedAppointment.phone" :disabled="!selectedAppointment.id"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Vehicle</label>
              <input :value="carDisplay" disabled
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm opacity-70" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Date & Time</label>
              <input v-model="appointmentDateTime" type="datetime-local" :disabled="!selectedAppointment.id"
                     class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition" />
            </div>
            <div>
              <label class="text-xs text-gray-400 mb-2 block">Status</label>
              <select v-model="selectedAppointment.status" :disabled="!selectedAppointment.id"
                      class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition">
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="completed">Completed</option>
                <option value="cancelled">Cancelled</option>
                <option value="rejected">Rejected</option>
              </select>
            </div>
            <div class="lg:col-span-3">
              <label class="text-xs text-gray-400 mb-2 block">Notes</label>
              <textarea v-model="selectedAppointment.notes" :disabled="!selectedAppointment.id" rows="3"
                        class="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-sm focus:border-red-500 focus:outline-none transition resize-none"></textarea>
            </div>
            <div class="lg:col-span-3 flex gap-4 justify-end">
              <button @click="cancelEdit"
                      class="px-6 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg text-sm font-medium transition">
                Clear Form
              </button>
              <button @click="updateAppointment" :disabled="!selectedAppointment.id || saving"
                      class="px-8 py-3 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 rounded-lg font-bold text-sm transition shadow-lg flex items-center gap-2">
                <i class="fas fa-save"></i>
                {{ saving ? 'Saving...' : 'Save Changes' }}
              </button>
            </div>
          </div>
        </div>

        <!-- Table -->
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold flex items-center gap-3">
              <i class="fas fa-list-alt text-red-500"></i>
              All Appointments
            </h3>
            <button @click="fetchAppointments" class="flex items-center gap-2 px-5 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-lg text-sm font-medium transition">
              <i class="fas fa-sync-alt" :class="{ 'animate-spin': loading }"></i> Refresh
            </button>
          </div>

          <!-- Loading / Empty -->
          <div v-if="loading" class="text-center py-20">
            <div class="spinner"></div>
            <p class="text-gray-400 mt-4">Loading appointments...</p>
          </div>
          <div v-else-if="appointments.length === 0" class="text-center py-20 bg-white/5 rounded-2xl border border-white/10">
            <i class="fas fa-calendar-times text-6xl text-gray-600 mb-4"></i>
            <h3 class="text-xl font-bold text-gray-400">No Appointments Found</h3>
            <p class="text-gray-500 mt-2">All test drive bookings will appear here</p>
          </div>

          <!-- Table -->
          <div v-else class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-400 border-b border-white/10">
                  <th class="pb-4 font-medium">Client</th>
                  <th class="pb-4 font-medium">Email</th>
                  <th class="pb-4 font-medium">Phone</th>
                  <th class="pb-4 font-medium">Vehicle</th>
                  <th class="pb-4 font-medium">Date & Time</th>
                  <th class="pb-4 font-medium text-center">Status</th>
                  <th class="pb-4 font-medium">Notes</th>
                  <th class="pb-4 font-medium">Action</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5">
                <tr v-for="apt in appointments" :key="apt.id"
                    class="hover:bg-white/5 transition"
                    :class="{ 'bg-amber-500/5 border-l-4 border-amber-500': selectedAppointment.id === apt.id }">
                  <td class="py-5 font-medium">{{ apt.user_name || apt.full_name || 'Guest' }}</td>
                  <td class="py-5 text-sm">
                    <a :href="`mailto:${apt.email}`" class="text-blue-400 hover:underline">{{ apt.email }}</a>
                  </td>
                  <td class="py-5 text-sm">{{ apt.phone || '—' }}</td>
                  <td class="py-5 font-medium">{{ apt.make }} {{ apt.model }} {{ apt.variant || '' }}</td>
                  <td class="py-5 text-sm">{{ formatDate(apt.appointment_at) }}</td>
                  <td class="py-5 text-center">
                    <span class="px-4 py-2 rounded-full text-xs font-bold"
                          :class="{
                            'bg-yellow-500/10 text-yellow-400 border border-yellow-500/20': apt.status === 'pending',
                            'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20': ['approved','completed'].includes(apt.status),
                            'bg-rose-500/10 text-rose-400 border border-rose-500/20': ['cancelled','rejected'].includes(apt.status)
                          }">
                      {{ statusText(apt.status) }}
                    </span>
                  </td>
                  <td class="py-5 text-sm max-w-xs truncate">{{ apt.notes || '—' }}</td>
                  <td class="py-5">
                    <button @click="editAppointment(apt)"
                            class="p-2 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg transition">
                      <i class="fas fa-edit"></i>
                    </button>
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

const loading = ref(false)
const saving = ref(false)
const appointments = ref([])

const selectedAppointment = ref({
  id: null, user_name: '', full_name: '', email: '', phone: '',
  make: '', model: '', variant: '', appointment_at: '', status: 'pending', notes: ''
})

const pendingCount = computed(() => appointments.value.filter(a => a.status === 'pending').length)
const approvedCount = computed(() => appointments.value.filter(a => ['approved','completed'].includes(a.status)).length)
const cancelledCount = computed(() => appointments.value.filter(a => ['cancelled','rejected'].includes(a.status)).length)

const carDisplay = computed(() => {
  const a = selectedAppointment.value
  return a.make && a.model ? `${a.make} ${a.model} ${a.variant || ''}`.trim() : '—'
})

const clientName = computed({
  get: () => selectedAppointment.value.user_name || selectedAppointment.value.full_name || '',
  set: (v) => { selectedAppointment.value.full_name = v; selectedAppointment.value.user_name = v }
})

const appointmentDateTime = computed({
  get: () => selectedAppointment.value.appointment_at?.slice(0,16) || '',
  set: (v) => { selectedAppointment.value.appointment_at = v ? v + ':00' : '' }
})

const fetchAppointments = async () => {
  loading.value = true
  try {
    const res = await fetch('http://localhost:8000/listappointment')
    const data = await res.json()
    if (data.status === 'success') appointments.value = data.appointments || []
  } catch (e) { console.error(e) }
  finally { loading.value = false }
}

const editAppointment = (apt) => {
  selectedAppointment.value = { ...apt }
  document.querySelector('.form-section')?.scrollIntoView({ behavior: 'smooth' })
}

const cancelEdit = () => {
  selectedAppointment.value = { id: null, user_name: '', full_name: '', email: '', phone: '',
    make: '', model: '', variant: '', appointment_at: '', status: 'pending', notes: '' }
}

const updateAppointment = async () => {
  if (!selectedAppointment.value.id || saving.value) return
  saving.value = true
  try {
    const payload = {
      status: selectedAppointment.value.status,
      notes: selectedAppointment.value.notes || null,
      appointment_at: selectedAppointment.value.appointment_at
    }
    const res = await fetch(`http://localhost:8000/updateappointment/${selectedAppointment.value.id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    if (res.ok) {
      alert('Appointment updated!')
      await fetchAppointments()
      cancelEdit()
    } else {
      alert('Update failed')
    }
  } catch (e) { alert('Network error') }
  finally { saving.value = false }
}

const formatDate = (d) => new Date(d).toLocaleString('en-PH', {
  month: 'short', day: 'numeric', year: 'numeric',
  hour: 'numeric', minute: '2-digit'
})

const statusText = (s) => s.charAt(0).toUpperCase() + s.slice(1)

onMounted(fetchAppointments)
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
  margin: 0 auto;
}

@keyframes spin { to { transform: rotate(360deg); } }
</style>