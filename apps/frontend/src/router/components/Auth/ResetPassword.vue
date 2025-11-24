<!-- src/views/ResetPassword.vue -->
<template>
  <div class="min-h-screen bg-[#0a0a0a] flex items-center justify-center p-5 relative overflow-hidden">
    <!-- Subtle Red Glow Background -->
    <div class="glow"></div>

    <div class="relative z-10 w-full max-w-md">
      <div class="rounded-3xl bg-zinc-900/90 backdrop-blur-2xl border border-white/10 shadow-2xl p-10">

        <!-- Success State -->
        <div v-if="status === 'success'" class="text-center py-16">
          <div class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-emerald-500/20">
            <i class="fas fa-check text-5xl text-emerald-400"></i>
          </div>
          <h2 class="text-2xl font-light text-white mb-2">Password Updated</h2>
          <p class="text-gray-400 text-sm mb-10">You can now sign in with your new password.</p>
          <router-link to="/login"
            class="inline-flex items-center gap-3 rounded-xl bg-red-600/90 px-9 py-4 font-medium text-white hover:bg-red-600 transition">
            <i class="fas fa-arrow-left"></i>
            Back to Login
          </router-link>
        </div>

        <!-- Invalid Token State -->
        <div v-else-if="status === 'invalid'" class="text-center py-16">
          <div class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-rose-500/20">
            <i class="fas fa-crown text-5xl text-rose-400"></i>
          </div>
          <h2 class="text-2xl font-light text-white mb-2">Link Expired or Invalid</h2>
          <p class="text-gray-400 text-sm mb-10">Please request a new reset link.</p>
          <router-link to="/login"
            class="inline-flex items-center gap-3 rounded-xl bg-red-600/90 px-9 py-4 font-medium text-white hover:bg-red-600 transition">
            Request New Link
          </router-link>
        </div>

        <!-- Reset Form -->
        <div v-else>
          <div class="text-center mb-10">
            <div class="mx-auto mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-gradient-to-br from-red-500 to-red-700 shadow-xl">
              <i class="fas fa-shield-keyhole text-2xl text-white"></i>
            </div>
            <h1 class="text-2xl font-light text-white">Set New Password</h1>
            <p class="mt-2 text-sm text-gray-400">Must be different from previous passwords</p>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="mb-6 rounded-xl bg-rose-500/10 border border-rose-500/30 px-5 py-3 text-sm text-rose-400 text-center">
            {{ error }}
          </div>

          <form @submit.prevent="resetPassword" class="space-y-6">
            <!-- New Password -->
            <div>
              <div class="relative">
                <input
                  v-model="password"
                  :type="showPassword ? 'text' : 'password'"
                  required
                  minlength="8"
                  placeholder="New password"
                  class="w-full rounded-xl border border-white/10 bg-white/5 px-5 py-4 text-white placeholder-gray-500 focus:border-red-500 focus:outline-none transition"
                />
                <button type="button" @click="showPassword = !showPassword"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white">
                  <i :class="showPassword ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
                </button>
              </div>
            </div>

            <!-- Confirm Password -->
            <div>
              <div class="relative">
                <input
                  v-model="password_confirmation"
                  :type="showConfirm ? 'text' : 'password'"
                  required
                  placeholder="Confirm password"
                  class="w-full rounded-xl border border-white/10 bg-white/5 px-5 py-4 text-white placeholder-gray-500 focus:border-red-500 focus:outline-none transition"
                />
                <button type="button" @click="showConfirm = !showConfirm"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white">
                  <i :class="showConfirm ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
                </button>
              </div>
            </div>

            <!-- Compact Strength Indicator -->
            <div class="mt-4 space-y-1.5 text-xs text-gray-400">
              <div class="flex items-center gap-2">
                <i :class="password.length >= 8 ? 'fas fa-check text-emerald-500' : 'fas fa-times text-gray-600'"></i>
                <span>At least 8 characters</span>
              </div>
              <div class="flex items-center gap-2">
                <i :class="hasUppercase ? 'fas fa-check text-emerald-500' : 'fas fa-times text-gray-600'"></i>
                <span>One uppercase letter</span>
              </div>
              <div class="flex items-center gap-2">
                <i :class="hasNumber ? 'fas fa-check text-emerald-500' : 'fas fa-times text-gray-600'"></i>
                <span>One number</span>
              </div>
            </div>

            <!-- Strength Bar -->
            <div class="mt-5 h-1.5 rounded-full bg-white/10 overflow-hidden">
              <div class="h-full transition-all duration-300"
                :class="{
                  'w-1/3 bg-rose-500': passwordStrength === 1,
                  'w-2/3 bg-yellow-500': passwordStrength === 2,
                  'w-full bg-emerald-500': passwordStrength >= 3
                }"></div>
            </div>

            <button
              type="submit"
              :disabled="loading || !isValid"
              class="mt-8 w-full rounded-xl py-4 font-medium text-white transition flex items-center justify-center gap-3
                     disabled:opacity-60 disabled:cursor-not-allowed"
              :class="isValid && !loading
                ? 'bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800'
                : 'bg-gray-700'"
            >
              <i v-if="loading" class="fas fa-spinner fa-spin"></i>
              {{ loading ? 'Updating...' : 'Reset Password' }}
            </button>
          </form>

          <div class="mt-8 text-center">
            <router-link to="/login" class="text-sm text-gray-500 hover:text-white transition">
              ← Back to Login
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const token = ref('')
const email = ref('')
const password = ref('')
const password_confirmation = ref('')
const showPassword = ref(false)
const showConfirm = ref(false)
const loading = ref(false)
const error = ref('')
const status = ref('') // '', 'success', 'invalid'

onMounted(() => {
  const t = route.query.token
  const e = route.query.email
  if (!t || !e) return status.value = 'invalid'
  token.value = t
  email.value = decodeURIComponent(e)
})

const passwordStrength = computed(() => {
  let s = 0
  if (password.value.length >= 8) s++
  if (/[A-Z]/.test(password.value)) s++
  if (/[0-9]/.test(password.value)) s++
  return s
})

const hasUppercase = computed(() => /[A-Z]/.test(password.value))
const hasNumber = computed(() => /[0-9]/.test(password.value))

const isValid = computed(() => 
  password.value &&
  password.value === password_confirmation.value &&
  password.value.length >= 8 &&
  passwordStrength.value >= 2
)

const resetPassword = async () => {
  if (!isValid.value) return
  loading.value = true
  error.value = ''

  try {
    const res = await fetch('http://localhost:8000/reset-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: email.value,
        token: token.value,
        password: password.value,
        password_confirmation: password_confirmation.value
      })
    })

    const data = await res.json()
    if (res.ok) {
      status.value = 'success'
    } else {
      error.value = data.message || 'Something went wrong.'
      if (data.message?.toLowerCase().includes('expired') || data.message?.toLowerCase().includes('invalid'))
        status.value = 'invalid'
    }
  } catch {
    error.value = 'Network error. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.glow {
  position: absolute;
  inset: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(239, 68, 68, 0.12) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(239, 68, 68, 0.08) 0%, transparent 50%);
  pointer-events: none;
}
</style>