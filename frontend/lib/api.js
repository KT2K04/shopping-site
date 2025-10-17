import axios from 'axios'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3000'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor to add auth token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export const userAPI = {
  create: (userData) => api.post('/users', userData),
  getAll: () => api.get('/users'),
  getById: (id) => api.get(`/users/${id}`),
}

export const orderAPI = {
  create: (orderData) => api.post('/orders', orderData),
  getById: (id) => api.get(`/orders/${id}`),
  getAll: () => api.get('/orders'),
}

export const inventoryAPI = {
  getProduct: (productId) => api.get(`/inventory/${productId}`),
  addProduct: (productData) => api.post('/inventory', productData),
  reserveProduct: (productId, data) => api.post(`/inventory/${productId}/reserve`, data),
}

export default api
