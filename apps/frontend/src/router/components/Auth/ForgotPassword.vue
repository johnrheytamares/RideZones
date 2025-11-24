<!-- ForgotPasswordModal.vue -->
<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/70 backdrop-blur-sm" @click="close"></div>

    <!-- Modal -->
    <div class="relative w-full max-w-md">
      <div class="glass-panel rounded-2xl p-8 shadow-2xl border border-white/10">
        <!-- Close Button -->
        <button @click="close" class="absolute top-4 right-4 text-gray-400 hover:text-white transition">
          <i class="fas fa-times text-xl"></i>
        </button>

        <!-- Logo / Icon -->
        <div class="text-center mb-8">
          <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gradient-to-br from-red-600 to-red-800 shadow-lg mb-4">
            <i class="fas fa-key text-3xl text-white"></i>
          </div>
          <h2 class="text-2xl font-bold">Forgot Password?</h2>
          <p class="text-gray-400 mt-2">No worries! We'll send you a reset link.</p>
        </div>

        <!-- Success Message -->
        <div v-if="status === 'success'" class="text-center py-8">
          <i class="fas fa-check-circle text-6xl text-emerald-500 mb-4"></i>
          <h3 class="text-xl font-bold text-emerald-400">Check Your Email!</h3>
          <p class="text-gray-300 mt-3">A password reset link has been sent to:</p>
          <p class="font-bold text-red-400 mt-2">{{ email }}</p>
          <button @click="close" class="mt-8 px-8 py-4 bg-gradient-to-r from-red-600 to-red-700 rounded-xl font-bold hover:from-red-700 hover:to-red-800 transition shadow-lg">
            Back to Login
          </button>
        </div>

        <!-- Form -->
        <form v-else @submit.prevent="sendResetLink" class="space-y-6">
          <div v-if="error" class="bg-rose-500/10 border border-rose-500/30 text-rose-400 px-5 py-4 rounded-xl text-sm">
            {{ error }}
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2">Email Address</label>
            <input
              v-model="email"
              type="email"
              required
              placeholder="you@example.com"
              class="w-full px-5 py-4 bg-white/5 border border-white/10 rounded-xl focus:border-red-500 focus:outline-none transition text-white placeholder-gray-500"
            />
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full py-5 rounded-xl font-bold text-lg transition shadow-xl flex items-center justify-center gap-3"
            :class="loading 
              ? 'bg-gray-700 cursor-not-allowed' 
              : 'bg-gradient-to-r from-red-600 to-red-800 hover:from-red-700 hover:to-red-900'"
          >
            <i v-if="loading" class="fas fa-spinner fa-spin"></i>
            {{ loading ? 'Sending Link...' : 'Send Reset Link' }}
          </button>
        </form>

        <div class="text-center mt-6">
          <button @click="close" class="text-gray-400 hover:text-white transition text-sm">
            ← Back to Login
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  isOpen: Boolean
})

const emit = defineEmits(['update:isOpen'])

const email = ref('')
const loading = ref(false)
const error = ref('')
const status = ref('') // 'success' or empty

const close = () => {
  emit('update:isOpen', false)
  resetForm()
}

const resetForm = () => {
  email.value = ''
  error.value = ''
  status.value = ''
  loading.value = false
}

const sendResetLink = async () => {
  if (!email.value) return

  loading.value = true
  error.value = ''

  try {
    const res = await fetch('http://localhost:8000/forgot-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: email.value })
    })

    const data = await res.json()

    if (res.ok) {
      status.value = 'success'
    } else {
      error.value = data.message || 'Something went wrong. Try again.'
    }
  } catch (err) {
    error.value = 'Network error. Please check your connection.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.glass-panel {
  background: rgba(255, 255, 255, 0.025);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}
</style>