# Shopping Website - Microservices Architecture

A modern, interactive shopping website built with microservices architecture using Node.js, React, and Docker.

## 🏗️ Architecture Overview

This project implements a microservices-based shopping platform with the following components:

- **Frontend**: Modern React application with Next.js
- **API Gateway**: Centralized entry point with authentication
- **User Service**: User management and authentication
- **Inventory Service**: Product catalog and stock management
- **Order Service**: Order processing with circuit breaker pattern
- **Notification Service**: Event-driven notifications via RabbitMQ
- **Message Queue**: RabbitMQ for asynchronous communication

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git (for cloning the repository)

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shopping-website-microservices
   ```

2. **Start all services with Docker Compose**
   ```bash
   docker-compose up --build
   ```

3. **Access the application**
   - **Frontend**: http://localhost:3005
   - **API Gateway**: http://localhost:3000
   - **RabbitMQ Management**: http://localhost:15672 (guest/guest)

## 🛠️ Development Setup

### Individual Service Development

If you want to run services individually for development:

#### Frontend Development
```bash
cd frontend
npm install
npm run dev
```

#### Backend Services
```bash
# User Service
cd user-service
npm install
npm start

# Inventory Service
cd inventory-service
npm install
npm start

# Order Service
cd order-service
npm install
npm start

# Notification Service
cd notification-service
npm install
npm start

# API Gateway
cd api-gateway
npm install
npm start
```

## 📱 Application Features

### Frontend Features
- **Modern UI**: Built with React 18, Next.js 14, and Tailwind CSS
- **Interactive Shopping**: Add to cart, view products, place orders
- **Real-time Updates**: Live inventory and order status
- **Responsive Design**: Works on desktop and mobile devices
- **Smooth Animations**: Framer Motion for enhanced UX

### Backend Features
- **Microservices Architecture**: Independent, scalable services
- **JWT Authentication**: Secure user authentication
- **Event-Driven Processing**: Asynchronous order processing
- **Circuit Breaker Pattern**: Resilient service communication
- **Message Queuing**: RabbitMQ for reliable messaging

## 🔧 API Endpoints

### User Service (Port 3004)
- `GET /users` - Get all users
- `POST /users` - Create new user
- `GET /users/:id` - Get user by ID

### Inventory Service (Port 3001)
- `GET /inventory/:productId` - Get product stock
- `POST /inventory` - Add/update product stock
- `POST /inventory/:productId/reserve` - Reserve stock for order

### Order Service (Port 3003)
- `POST /orders` - Create new order
- `GET /orders/:id` - Get order by ID

### API Gateway (Port 3000)
- All routes are proxied through the gateway
- Authentication required for orders and inventory management

## 🐳 Docker Services

| Service | Port | Description |
|---------|------|-------------|
| Frontend | 3005 | React application |
| API Gateway | 3000 | Main entry point |
| User Service | 3004 | User management |
| Inventory Service | 3001 | Product inventory |
| Order Service | 3003 | Order processing |
| Notification Service | 3002 | Event handling |
| RabbitMQ | 5672 | Message broker |
| RabbitMQ Management | 15672 | Management UI |

## 🧪 Testing the Application

### 1. Access the Frontend
Navigate to http://localhost:3005 to see the shopping interface.

### 2. Create a User
Click "Create User" to create a demo user account.

### 3. Browse Products
View available products in the Products tab.

### 4. Add to Cart
Click "Add to Cart" on any product to add it to your shopping cart.

### 5. Place an Order
Go to the Cart tab and click "Place Order" to process your order.

### 6. View Order History
Check the Orders tab to see your order history.

## 🔍 Monitoring & Debugging

### RabbitMQ Management
- URL: http://localhost:15672
- Username: guest
- Password: guest
- Monitor message queues and processing

### Service Health Checks
- API Gateway: http://localhost:3000/health
- User Service: http://localhost:3004/health
- Inventory Service: http://localhost:3001/health
- Order Service: http://localhost:3003/health
- Notification Service: http://localhost:3002/health

## 🏗️ Architecture Benefits

1. **Scalability**: Each service can be scaled independently
2. **Resilience**: Circuit breaker patterns prevent cascade failures
3. **Maintainability**: Clear separation of concerns
4. **Technology Flexibility**: Each service can use different technologies
5. **Event-Driven**: Asynchronous processing improves performance

## 🚨 Troubleshooting

### Common Issues

1. **Port Conflicts**
   - Ensure no other services are using the required ports
   - Check `docker-compose ps` to see running services

2. **RabbitMQ Connection Issues**
   - Wait for RabbitMQ to fully start before other services
   - Check RabbitMQ logs: `docker-compose logs rabbitmq`

3. **Frontend Not Loading**
   - Ensure all backend services are running
   - Check browser console for API connection errors

4. **Order Processing Failures**
   - Check inventory service is running
   - Verify RabbitMQ connection in order service logs

### Logs and Debugging

```bash
# View all service logs
docker-compose logs

# View specific service logs
docker-compose logs frontend
docker-compose logs api-gateway
docker-compose logs order-service

# Restart specific service
docker-compose restart frontend
```

## 📚 Technology Stack

### Frontend
- React 18
- Next.js 14
- Tailwind CSS
- Framer Motion
- Axios
- React Hot Toast

### Backend
- Node.js
- Express.js
- JWT Authentication
- RabbitMQ
- Circuit Breaker (Opossum)

### Infrastructure
- Docker
- Docker Compose
- Microservices Architecture

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section above
2. Review service logs for error messages
3. Ensure all services are running properly
4. Verify network connectivity between services

---

**Happy Shopping! 🛒**
