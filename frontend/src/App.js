import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { useAuth } from './contexts/AuthContext';
import Navbar from './components/Navbar';
import LoadingSpinner from './components/LoadingSpinner';

// Pages
import Login from './pages/Login';
import Register from './pages/Register';
import Home from './pages/Home';
import UserProfile from './pages/UserProfile';
import HostDashboard from './pages/HostDashboard';
import PropertyDetails from './pages/PropertyDetails';  
import BookingManagement from './pages/BookingManagement';
import Messages from './pages/Messages';

// Protected Route Component
function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();
  
  if (loading) {
    return <LoadingSpinner />;
  }
  
  if (!user) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
}

// Main App Component
function AppContent() {
  const { loading } = useAuth();

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <div className="App">
      <Navbar />
      <Routes>
        {/* Public Routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        
        {/* Protected Routes */}
        <Route path="/" element={
          <ProtectedRoute>
            <Home />
          </ProtectedRoute>
        } />
        
        <Route path="/profile" element={
          <ProtectedRoute>
            <UserProfile />
          </ProtectedRoute>
        } />
        
        <Route path="/host-dashboard" element={
          <ProtectedRoute>
            <HostDashboard />
          </ProtectedRoute>
        } />
        
        <Route path="/property/:id" element={
          <ProtectedRoute>
            <PropertyDetails />
          </ProtectedRoute>
        } />
        
        <Route path="/bookings" element={
          <ProtectedRoute>
            <BookingManagement />
          </ProtectedRoute>
        } />
        
        <Route path="/messages" element={
          <ProtectedRoute>
            <Messages />
          </ProtectedRoute>
        } />
        
        <Route path="/messages/:conversationId" element={
          <ProtectedRoute>
            <Messages />
          </ProtectedRoute>
        } />
      </Routes>
    </div>
  );
}

function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  );
}

export default App;