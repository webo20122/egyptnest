import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_BACKEND_URL || 'http://localhost:8001';

// Create axios instance
const api = axios.create({
  baseURL: API_BASE_URL,
});

// Add request interceptor to include auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Add response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API calls
export const authAPI = {
  login: (email, password) => api.post('/api/auth/login', { email, password }),
  register: (userData) => api.post('/api/auth/register', userData),
  getMe: () => api.get('/api/auth/me'),
};

// User API calls
export const userAPI = {
  getProfile: () => api.get('/api/users/profile'),
  updateProfile: (userData) => api.put('/api/users/profile', userData),
  getUserById: (userId) => api.get(`/api/users/${userId}`),
};

// Property API calls
export const propertyAPI = {
  getProperties: (params) => api.get('/api/properties/', { params }),
  getProperty: (propertyId) => api.get(`/api/properties/${propertyId}`),
  createProperty: (propertyData) => api.post('/api/properties/', propertyData),
  getHostProperties: () => api.get('/api/properties/host/my-properties'),
};

// Booking API calls
export const bookingAPI = {
  createBooking: (bookingData) => api.post('/api/bookings/', bookingData),
  getUserBookings: () => api.get('/api/bookings/my-bookings'),
  getHostBookings: () => api.get('/api/bookings/host/bookings'),
  updateBookingStatus: (bookingId, status) => 
    api.put(`/api/bookings/${bookingId}/status`, { status }),
};

// Message API calls
export const messageAPI = {
  getConversations: () => api.get('/api/messages/conversations'),
  createConversation: (participantId, propertyId) => 
    api.post('/api/messages/conversations', { participant_id: participantId, property_id: propertyId }),
  getMessages: (conversationId) => api.get(`/api/messages/${conversationId}`),
  sendMessage: (messageData) => api.post('/api/messages/', messageData),
  markMessageAsRead: (messageId) => api.put(`/api/messages/${messageId}/read`),
};

export default api;