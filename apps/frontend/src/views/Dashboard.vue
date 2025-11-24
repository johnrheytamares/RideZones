<template>
  <div class="dashboard min-h-screen bg-[#0a0a0a] text-white relative overflow-hidden">
    <!-- Ultra-subtle glow — sobrang classy! -->
    <div class="glow-bg" aria-hidden="true"></div>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">

      <!-- Header Panel -->
      <div class="glass-panel rounded-2xl p-8 mb-8">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
          <div class="flex items-center gap-5">
            <div class="icon-circle">
              <i class="fas fa-tachometer-alt text-2xl"></i>
            </div>
            <div>
              <h1 class="text-2xl md:text-3xl font-bold text-white">Performance Analytics</h1>
              <p class="text-gray-500 text-sm mt-1 opacity-80">
                Real-time insights • {{ new Date().toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }) }}
              </p>
            </div>
          </div>

          <!-- Key Stats -->
          <div class="grid grid-cols-3 gap-5">
            <div class="stat-box">
              <i class="fas fa-car text-xl text-red-500"></i>
              <div class="mt-2">
                <div class="text-2xl font-bold">{{ totalStock }}</div>
                <div class="text-xs text-gray-500 uppercase tracking-wider opacity-80">Total Stock</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-calendar-check text-xl text-emerald-500"></i>
              <div class="mt-2">
                <div class="text-2xl font-bold">{{ totalAppointments }}</div>
                <div class="text-xs text-gray-500 uppercase tracking-wider opacity-80">Appointments</div>
              </div>
            </div>
            <div class="stat-box">
              <i class="fas fa-arrow-trend-up text-xl text-amber-500"></i>
              <div class="mt-2">
                <div class="text-2xl font-bold">+27%</div>
                <div class="text-xs text-gray-500 uppercase tracking-wider opacity-80">Growth</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts Grid -->
      <div class="grid lg:grid-cols-2 gap-8">
        <!-- Bar Chart -->
        <div class="glass-panel rounded-2xl p-6">
          <div class="mb-4">
            <h3 class="text-lg font-bold text-white">Appointment Frequency by Model</h3>
            <p class="text-sm text-gray-500 opacity-80">Most booked vehicles this month</p>
          </div>
          <div class="chart-container">
            <canvas ref="barChartRef"></canvas>
          </div>
        </div>

        <!-- Doughnut Chart — MAY IBA-IBANG PREMIUM KULAY NA! -->
        <div class="glass-panel rounded-2xl p-6">
          <div class="mb-4">
            <h3 class="text-lg font-bold text-white">Stock Distribution</h3>
            <p class="text-sm text-gray-500 opacity-80">{{ totalStock }} units in inventory</p>
          </div>
          <div class="chart-container doughnut">
            <canvas ref="doughnutChartRef"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="fixed inset-0 bg-black/95 backdrop-blur-sm flex items-center justify-center z-50">
      <div class="text-center">
        <div class="spinner"></div>
        <p class="text-gray-400 mt-6 text-lg font-medium opacity-80">Loading analytics...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import Chart from 'chart.js/auto'

const loading = ref(true)
const stockData = ref([])
const appointmentData = ref([])
const barChartRef = ref(null)
const doughnutChartRef = ref(null)
let barChartInstance = null
let doughnutChartInstance = null

const totalStock = computed(() => 
  stockData.value.reduce((sum, car) => sum + (car.stock_count || 0), 0)
)
const totalAppointments = computed(() => 
  appointmentData.value.reduce((sum, car) => sum + (car.total_appointments || 0), 0)
)

// Premium & Vibrant Colors — pero hindi masyadong makulay
const premiumColors = [
  '#ef4444', '#dc2626', '#b91c1c', '#991b1b', '#7f1d1d',
  '#1e40af', '#1e3a8a', '#312e81', '#4c1d95',
  '#0891b2', '#0e7490', '#166534', '#16a34a',
  '#f97316', '#ca8a04', '#facc15'
]

const fetchData = async () => {
  loading.value = true
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const headers = { 'Content-Type': 'application/json', 'X-User': JSON.stringify(user) }

    const [stockRes, appRes] = await Promise.all([
      fetch('http://localhost:8000/cardistribution', { headers }),
      fetch('http://localhost:8000/dataappointments', { headers })
    ])

    const stockJson = await stockRes.json()
    const appJson = await appRes.json()

    if (stockJson.status === 'success') stockData.value = stockJson.stocks || []
    if (appJson.status === 'success') appointmentData.value = appJson.data || []

  } catch (err) {
    console.error('Failed to load dashboard:', err)
  } finally {
    loading.value = false
    await nextTick()
    renderCharts()
  }
}

const renderCharts = () => {
  if (barChartInstance) barChartInstance.destroy()
  if (doughnutChartInstance) doughnutChartInstance.destroy()

  // Bar Chart — Clean Red
  barChartInstance = new Chart(barChartRef.value, {
    type: 'bar',
    data: {
      labels: appointmentData.value.map(c => `${c.make} ${c.model}`.trim()),
      datasets: [{
        label: 'Appointments',
        data: appointmentData.value.map(c => c.total_appointments || 0),
        backgroundColor: '#ef4444',
        borderRadius: 8,
        barThickness: 28,
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.025)' }, ticks: { color: '#9ca3af' } },
        x: { grid: { display: false }, ticks: { color: '#9ca3af' } }
      }
    }
  })

  // Doughnut Chart — Iba-ibang kulay + EXACT rgba(255,255,255,0.025) borders!
  const colors = stockData.value.map((_, i) => premiumColors[i % premiumColors.length])

  doughnutChartInstance = new Chart(doughnutChartRef.value, {
    type: 'doughnut',
    data: {
      labels: stockData.value.map(c => `${c.make} ${c.model}`.trim()),
      datasets: [{
        data: stockData.value.map(c => c.stock_count || 0),
        backgroundColor: colors,
        borderColor: 'rgba(255,255,255,0.025)',
        borderWidth: 3,
        hoverOffset: 16,
        cutout: '68%'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            color: '#e5e7eb',
            padding: 20,
            font: { size: 13, weight: '600' },
            usePointStyle: true,
            pointStyle: 'circle'
          }
        }
      }
    }
  })
}

onMounted(fetchData)
</script>

<style scoped>
/* EXACT YUNG KULAY NA GUSTO MO: rgba(255,255,255,0.025) */
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
  padding: 16px;
  border-radius: 14px;
  border: 1px solid rgba(255,255,255,0.06);
  text-align: center;
  transition: all 0.2s ease;
}

.stat-box:hover {
  background: rgba(255,255,255,0.04);
  transform: translateY(-4px);
}

.chart-container {
  height: 320px;
  position: relative;
}

.chart-container.doughnut {
  height: 340px;
}

.spinner {
  width: 60px;
  height: 60px;
  border: 5px solid rgba(239,68,68,0.15);
  border-top-color: #ef4444;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>