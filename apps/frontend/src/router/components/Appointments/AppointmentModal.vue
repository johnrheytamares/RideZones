<template>
  <div v-if="show" class="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4 overflow-y-auto" @click.self="$emit('close')">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-4xl my-8 animate-in fade-in zoom-in duration-300">
      
      <!-- Header -->
      <div class="bg-gradient-to-r from-red-600 to-red-700 text-white p-5 text-center relative">
        <h2 class="text-2xl font-bold">Book Your Drive Test</h2>
        <p class="text-sm opacity-90 mt-1">Choose your preferred date & time</p>
        <button @click="$emit('close')" class="absolute top-4 right-4 text-white/80 hover:text-white text-3xl leading-none">×</button>
      </div>

      <div class="p-4 md:p-8">
        <!-- TWO COLUMNS (desktop) / ONE COLUMN (mobile) -->
        <div class="grid md:grid-cols-2 gap-6 lg:gap-10">

          <!-- LEFT: Personal Info -->
          <div class="space-y-5">
            <h3 class="text-lg font-bold text-gray-800 mb-4 hidden md:block">Your Information</h3>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Full Name <span class="text-red-500">*</span></label>
              <input v-model="fullName" type="text" required placeholder="Juan Dela Cruz"
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 focus:border-red-500 transition">
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Email Address <span class="text-red-500">*</span></label>
              <input v-model="email" type="email" required placeholder="juan@gmail.com"
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 focus:border-red-500 transition">
              <p class="text-xs text-gray-500 mt-1">Confirmation will be sent here</p>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Phone <span class="text-gray-400 text-xs">(optional)</span></label>
              <input v-model="phone" type="tel" placeholder="0917 123 4567"
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 focus:border-red-500 transition">
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Notes <span class="text-gray-400 text-xs">(optional)</span></label>
              <textarea v-model="notes" rows="3" placeholder="Ex: Call me 30 mins before"
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 resize-none"></textarea>
            </div>
          </div>

          <!-- RIGHT: Schedule -->
          <div class="space-y-5">
            <h3 class="text-lg font-bold text-gray-800 mb-4 hidden md:block">Schedule</h3>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Date <span class="text-red-500">*</span></label>
              <input v-model="appointmentDate" type="date" :min="today" @change="onDateChange" required
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 focus:border-red-500 transition">
              
              <p v-if="dateError" class="text-red-600 text-sm mt-2 flex items-center gap-1">
                Warning: {{ dateError }}
              </p>
              <p v-if="isDateFullyBooked && !dateError" class="text-orange-600 text-sm mt-2">
                Fully Booked: This date is no longer available.
              </p>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">Time <span class="text-red-500">*</span></label>
              <input v-model="appointmentTime" type="time" required
                :disabled="!appointmentDate || isDateFullyBooked || !!dateError"
                class="w-full border border-gray-300 rounded-xl px-4 py-3 focus:ring-2 focus:ring-red-500 disabled:bg-gray-100 disabled:cursor-not-allowed transition">
            </div>

            <!-- Success Message -->
            <div v-if="success" class="mt-8 p-5 bg-green-50 border-2 border-green-300 rounded-xl text-center">
              <p class="text-green-800 font-bold text-lg">Success: Booked Successfully!</p>
              <p class="text-green-700 text-sm mt-2">Check your email for confirmation</p>
            </div>

            <!-- Buttons -->
            <div class="md:mt-12 flex flex-col sm:flex-row gap-3 pt-4">
              <button @click="createAppointment" :disabled="isBookButtonDisabled"
                class="order-1 sm:order-2 flex-1 py-3.5 rounded-xl bg-red-600 text-white font-bold hover:bg-red-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition shadow-lg flex items-center justify-center gap-2">
                <span v-if="loading" class="animate-spin">Loading</span>
                {{ loading ? 'Booking...' : 'Confirm Booking' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue'

const props = defineProps({
  show: Boolean,
  carId: Number,
})

const emit = defineEmits(['close', 'saved'])

const fullName = ref('')
const email = ref('')
const phone = ref('')
const notes = ref('')
const appointmentDate = ref('')
const appointmentTime = ref('')
const loading = ref(false)
const success = ref(false)
const bookedDates = ref([])
const dateError = ref('')

const today = new Date().toISOString().split('T')[0]

// Computed
const isDateFullyBooked = computed(() => 
  appointmentDate.value && bookedDates.value.includes(appointmentDate.value)
)

const isBookButtonDisabled = computed(() => {
  return loading.value ||
    !fullName.value.trim() ||
    !email.value.trim() ||
    !appointmentDate.value ||
    !appointmentTime.value ||
    isDateFullyBooked.value ||
    !!dateError.value
})

// Fetch booked dates (fully booked dates only)
async function fetchBookedDates() {
  try {
    const res = await fetch(`http://localhost:8000/get-booked-dates/${props.carId}?t=${Date.now()}`)
    const data = await res.json()
    if (data.status === 'success') {
      bookedDates.value = data.booked_dates || []
    }
  } catch (err) {
    console.error('Failed to fetch booked dates:', err)
  }
}

// Reset form when modal opens
watch(() => props.show, async (val) => {
  if (val) {
    success.value = false
    await fetchBookedDates()
    fullName.value = email.value = phone.value = notes.value = appointmentDate.value = appointmentTime.value = ''
    dateError.value = ''
  }
})

function onDateChange() {
  dateError.value = ''
  appointmentTime.value = '' // reset time when date changes

  if (!appointmentDate.value) return

  const selected = new Date(appointmentDate.value)
  const now = new Date()
  now.setHours(0, 0, 0, 0)

  if (selected < now) {
    dateError.value = 'Past dates are not allowed.'
  } else if (isDateFullyBooked.value) {
    dateError.value = 'This date is fully booked.'
  }
}

// MAIN: CREATE APPOINTMENT — PERFECTLY MATCHES YOUR PHP BACKEND
async function createAppointment() {
  if (isBookButtonDisabled.value) return

  loading.value = true
  success.value = false

  // EXACT FORMAT REQUIRED BY YOUR BACKEND
  const appointmentAt = `${appointmentDate.value} ${appointmentTime.value}:00` 
  // → "2025-11-22 15:00:00"

  const payload = {
    car_id: props.carId,
    appointment_at: appointmentAt,           // Required & exact format
    user_id: window.authUser?.id ?? 0,       // 0 = guest (allowed sa backend mo)
    dealer_id: 1,                            // Default sa backend
    notes: notes.value.trim() || null,

    // These are ONLY for email (not inserted into DB)
    full_name: fullName.value.trim(),
    email: email.value.trim().toLowerCase(),
    phone: phone.value.trim() || null,
  }

  try {
    const res = await fetch('http://localhost:8000/createappointment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })

    const data = await res.json()

    if (res.ok && (data.message || data.appointment_id)) {
      success.value = true
      await fetchBookedDates()
      emit('saved')
      setTimeout(() => $emit('close'), 3000) // Auto-close
    } else {
      alert('Booking failed: ' + (data.error || data.message || 'Please try again.'))
    }
  } catch (err) {
    console.error(err)
    alert('Connection error. Please check your internet.')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.animate-in { animation: modalPop 0.3s ease-out; }
@keyframes modalPop {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}
input, textarea { outline: none; }
</style>