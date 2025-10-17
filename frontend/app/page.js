'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { ShoppingCartIcon, UserIcon, CubeIcon, BellIcon } from '@heroicons/react/24/outline'
import toast from 'react-hot-toast'
import axios from 'axios'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3000'

export default function Home() {
  const [user, setUser] = useState(null)
  const [products, setProducts] = useState([])
  const [cart, setCart] = useState([])
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(false)
  const [activeTab, setActiveTab] = useState('products')

  // Sample products data
  const sampleProducts = [
    { id: 'product-1', name: 'Wireless Headphones', price: 99.99, stock: 10 },
    { id: 'product-2', name: 'Smart Watch', price: 199.99, stock: 5 },
  ]

  useEffect(() => {
    setProducts(sampleProducts)
    loadUser()
    loadOrders()
  }, [])

  const loadUser = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/users`)
      if (response.data && response.data.length > 0) {
        setUser(response.data[0]) // Use first user for demo
      }
    } catch (error) {
      console.error('Failed to load user:', error)
    }
  }

  const loadOrders = async () => {
    if (!user) return
    try {
      const response = await axios.get(`${API_BASE_URL}/orders`)
      setOrders(response.data)
    } catch (error) {
      console.error('Failed to load orders:', error)
    }
  }

  const createUser = async (name, email) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/users`, { name, email })
      setUser(response.data)
      toast.success('User created successfully!')
    } catch (error) {
      console.error('Failed to create user:', error)
      toast.error(`Failed to create user: ${error.response?.data?.error || error.message}`)
    }
  }

  const addToCart = (product) => {
    const existingItem = cart.find(item => item.productId === product.id)
    if (existingItem) {
      setCart(cart.map(item => 
        item.productId === product.id 
          ? { ...item, quantity: item.quantity + 1 }
          : item
      ))
    } else {
      setCart([...cart, { productId: product.id, quantity: 1, name: product.name, price: product.price }])
    }
    toast.success('Added to cart!')
  }

  const removeFromCart = (productId) => {
    setCart(cart.filter(item => item.productId !== productId))
    toast.success('Removed from cart!')
  }

  const updateQuantity = (productId, quantity) => {
    if (quantity <= 0) {
      removeFromCart(productId)
      return
    }
    setCart(cart.map(item => 
      item.productId === productId 
        ? { ...item, quantity }
        : item
    ))
  }

  const placeOrder = async () => {
    if (!user || cart.length === 0) return
    
    setLoading(true)
    try {
      const orderData = {
        userId: user.id,
        items: cart.map(item => ({
          productId: item.productId,
          quantity: item.quantity
        }))
      }
      
      const response = await axios.post(`${API_BASE_URL}/orders`, orderData)
      
      setOrders([...orders, response.data])
      setCart([])
      toast.success('Order placed successfully!')
    } catch (error) {
      console.error('Failed to place order:', error)
      toast.error(`Failed to place order: ${error.response?.data?.error || error.message}`)
    } finally {
      setLoading(false)
    }
  }

  const getTotalPrice = () => {
    return cart.reduce((total, item) => total + (item.price * item.quantity), 0)
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <ShoppingCartIcon className="h-8 w-8 text-primary-600" />
              <h1 className="ml-2 text-xl font-bold text-gray-900">Shopping Store</h1>
            </div>
            <div className="flex items-center space-x-4">
              {user ? (
                <div className="flex items-center space-x-2">
                  <UserIcon className="h-5 w-5 text-gray-500" />
                  <span className="text-sm text-gray-700">{user.name}</span>
                </div>
              ) : (
                <button 
                  onClick={() => createUser('Demo User', 'demo@example.com')}
                  className="btn-primary"
                >
                  Create User
                </button>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Navigation Tabs */}
      <div className="bg-white border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <nav className="flex space-x-8">
            {[
              { id: 'products', name: 'Products', icon: CubeIcon },
              { id: 'cart', name: 'Cart', icon: ShoppingCartIcon },
              { id: 'orders', name: 'Orders', icon: BellIcon },
            ].map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center space-x-2 py-4 px-1 border-b-2 font-medium text-sm ${
                  activeTab === tab.id
                    ? 'border-primary-500 text-primary-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
              >
                <tab.icon className="h-5 w-5" />
                <span>{tab.name}</span>
                {tab.id === 'cart' && cart.length > 0 && (
                  <span className="bg-primary-600 text-white text-xs rounded-full px-2 py-1">
                    {cart.length}
                  </span>
                )}
              </button>
            ))}
          </nav>
        </div>
      </div>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {activeTab === 'products' && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
          >
            {products.map((product) => (
              <motion.div
                key={product.id}
                whileHover={{ scale: 1.02 }}
                className="card"
              >
                <div className="aspect-w-16 aspect-h-9 bg-gray-200 rounded-lg mb-4">
                  <div className="w-full h-48 bg-gradient-to-br from-primary-100 to-primary-200 rounded-lg flex items-center justify-center">
                    <CubeIcon className="h-16 w-16 text-primary-600" />
                  </div>
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">{product.name}</h3>
                <p className="text-2xl font-bold text-primary-600 mb-4">${product.price}</p>
                <p className="text-sm text-gray-500 mb-4">Stock: {product.stock}</p>
                <button
                  onClick={() => addToCart(product)}
                  className="btn-primary w-full"
                >
                  Add to Cart
                </button>
              </motion.div>
            ))}
          </motion.div>
        )}

        {activeTab === 'cart' && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="max-w-2xl mx-auto"
          >
            <div className="card">
              <h2 className="text-xl font-semibold mb-6">Shopping Cart</h2>
              {cart.length === 0 ? (
                <p className="text-gray-500 text-center py-8">Your cart is empty</p>
              ) : (
                <div className="space-y-4">
                  {cart.map((item) => (
                    <div key={item.productId} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                      <div className="flex-1">
                        <h3 className="font-medium">{item.name}</h3>
                        <p className="text-sm text-gray-500">${item.price}</p>
                      </div>
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => updateQuantity(item.productId, item.quantity - 1)}
                          className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center hover:bg-gray-300"
                        >
                          -
                        </button>
                        <span className="w-8 text-center">{item.quantity}</span>
                        <button
                          onClick={() => updateQuantity(item.productId, item.quantity + 1)}
                          className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center hover:bg-gray-300"
                        >
                          +
                        </button>
                        <button
                          onClick={() => removeFromCart(item.productId)}
                          className="ml-4 text-red-600 hover:text-red-800"
                        >
                          Remove
                        </button>
                      </div>
                    </div>
                  ))}
                  <div className="border-t pt-4">
                    <div className="flex justify-between items-center mb-4">
                      <span className="text-lg font-semibold">Total: ${getTotalPrice().toFixed(2)}</span>
                    </div>
                    <button
                      onClick={placeOrder}
                      disabled={loading || !user}
                      className="btn-primary w-full disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {loading ? 'Placing Order...' : 'Place Order'}
                    </button>
                  </div>
                </div>
              )}
            </div>
          </motion.div>
        )}

        {activeTab === 'orders' && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="max-w-4xl mx-auto"
          >
            <div className="card">
              <h2 className="text-xl font-semibold mb-6">Order History</h2>
              {orders.length === 0 ? (
                <p className="text-gray-500 text-center py-8">No orders yet</p>
              ) : (
                <div className="space-y-4">
                  {orders.map((order) => (
                    <div key={order.id} className="border border-gray-200 rounded-lg p-4">
                      <div className="flex justify-between items-start mb-2">
                        <span className="font-medium">Order #{order.id}</span>
                        <span className={`px-2 py-1 rounded-full text-xs ${
                          order.status === 'created' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                        }`}>
                          {order.status}
                        </span>
                      </div>
                      <p className="text-sm text-gray-500">
                        Items: {order.items?.length || 0} | 
                        User: {order.userId}
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </motion.div>
        )}
      </main>
    </div>
  )
}
