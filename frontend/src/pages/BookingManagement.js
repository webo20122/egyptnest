import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Box,
  Card,
  CardContent,
  Grid,
  Chip,
  Button,
  Avatar,
  Divider,
  Tab,
  Tabs,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
} from '@mui/material';
import {
  CalendarToday as CalendarIcon,
  LocationOn as LocationIcon,
  People as PeopleIcon,
  AttachMoney as MoneyIcon,
} from '@mui/icons-material';
import { bookingAPI } from '../utils/api';
import { useAuth } from '../contexts/AuthContext';
import LoadingSpinner from '../components/LoadingSpinner';

const BookingManagement = () => {
  const { user, isHost } = useAuth();
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [statusDialog, setStatusDialog] = useState({ open: false, booking: null });

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      setLoading(true);
      let response;
      if (isHost) {
        response = await bookingAPI.getHostBookings();
      } else {
        response = await bookingAPI.getUserBookings();
      }
      setBookings(response.data.bookings);
    } catch (error) {
      console.error('Error fetching bookings:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleStatusUpdate = async (bookingId, newStatus) => {
    try {
      await bookingAPI.updateBookingStatus(bookingId, newStatus);
      fetchBookings(); // Refresh the list
      setStatusDialog({ open: false, booking: null });
    } catch (error) {
      console.error('Error updating booking status:', error);
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'confirmed': return 'success';
      case 'pending': return 'warning';
      case 'cancelled': return 'error';
      case 'completed': return 'info';
      default: return 'default';
    }
  };

  const filterBookingsByStatus = (status) => {
    if (status === 'all') return bookings;
    return bookings.filter(booking => booking.status === status);
  };

  const getTabLabel = (status) => {
    const count = status === 'all' ? bookings.length : filterBookingsByStatus(status).length;
    return `${status === 'all' ? 'All' : status.charAt(0).toUpperCase() + status.slice(1)} (${count})`;
  };

  const currentBookings = (() => {
    switch (tabValue) {
      case 0: return filterBookingsByStatus('all');
      case 1: return filterBookingsByStatus('pending');
      case 2: return filterBookingsByStatus('confirmed');
      case 3: return filterBookingsByStatus('completed');
      case 4: return filterBookingsByStatus('cancelled');
      default: return bookings;
    }
  })();

  if (loading) {
    return <LoadingSpinner />;
  }

  const BookingCard = ({ booking }) => (
    <Card sx={{ mb: 2 }}>
      <CardContent>
        <Grid container spacing={2} alignItems="center">
          <Grid item xs={12} sm={3}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Avatar
                variant="rounded"
                src={booking.property?.images?.[0]}
                sx={{ width: 60, height: 60, mr: 2 }}
              />
              <Box>
                <Typography variant="h6" noWrap>
                  {booking.property?.title || 'Property'}
                </Typography>
                <Box sx={{ display: 'flex', alignItems: 'center', mt: 0.5 }}>
                  <LocationIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
                  <Typography variant="body2" color="text.secondary">
                    {booking.property?.location?.city}
                  </Typography>
                </Box>
              </Box>
            </Box>
          </Grid>

          <Grid item xs={12} sm={2}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <CalendarIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
              <Box>
                <Typography variant="body2">
                  {new Date(booking.check_in).toLocaleDateString()}
                </Typography>
                <Typography variant="body2">
                  {new Date(booking.check_out).toLocaleDateString()}
                </Typography>
              </Box>
            </Box>
          </Grid>

          <Grid item xs={12} sm={2}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <PeopleIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
              <Typography variant="body2">
                {booking.guests} guests
              </Typography>
            </Box>
          </Grid>

          <Grid item xs={12} sm={2}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <MoneyIcon sx={{ fontSize: 16, mr: 0.5, color: 'text.secondary' }} />
              <Typography variant="body2" fontWeight="bold">
                ${booking.total_price}
              </Typography>
            </Box>
          </Grid>

          <Grid item xs={12} sm={2}>
            <Chip
              label={booking.status}
              color={getStatusColor(booking.status)}
              sx={{ textTransform: 'capitalize', mb: 1 }}
            />
          </Grid>

          <Grid item xs={12} sm={1}>
            {isHost && booking.status === 'pending' && (
              <Button
                variant="outlined"
                size="small"
                onClick={() => setStatusDialog({ open: true, booking })}
              >
                Update
              </Button>
            )}
          </Grid>
        </Grid>

        {/* Guest/Host Info */}
        {isHost && booking.guest && (
          <Box sx={{ mt: 2, pt: 2, borderTop: 1, borderColor: 'divider' }}>
            <Typography variant="body2" color="text.secondary">
              Guest: {booking.guest.first_name} {booking.guest.last_name}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Email: {booking.guest.email}
            </Typography>
          </Box>
        )}
      </CardContent>
    </Card>
  );

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Typography variant="h4" gutterBottom>
        {isHost ? 'Booking Management' : 'My Bookings'}
      </Typography>

      <Tabs
        value={tabValue}
        onChange={(e, newValue) => setTabValue(newValue)}
        sx={{ mb: 3 }}
      >
        <Tab label={getTabLabel('all')} />
        <Tab label={getTabLabel('pending')} />
        <Tab label={getTabLabel('confirmed')} />
        <Tab label={getTabLabel('completed')} />
        <Tab label={getTabLabel('cancelled')} />
      </Tabs>

      {currentBookings.length === 0 ? (
        <Box sx={{ textAlign: 'center', py: 8 }}>
          <Typography variant="h6" color="text.secondary" gutterBottom>
            No bookings found
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {isHost ? 'Bookings from guests will appear here' : 'Your booking history will appear here'}
          </Typography>
        </Box>
      ) : (
        <Box>
          {currentBookings.map((booking) => (
            <BookingCard key={booking.id} booking={booking} />
          ))}
        </Box>
      )}

      {/* Status Update Dialog */}
      <Dialog
        open={statusDialog.open}
        onClose={() => setStatusDialog({ open: false, booking: null })}
      >
        <DialogTitle>Update Booking Status</DialogTitle>
        <DialogContent>
          <Typography variant="body2" sx={{ mb: 2 }}>
            Update the status for booking from {statusDialog.booking?.guest?.first_name}
          </Typography>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Button
              variant="contained"
              color="success"
              onClick={() => handleStatusUpdate(statusDialog.booking?.id, 'confirmed')}
            >
              Confirm
            </Button>
            <Button
              variant="contained"
              color="error"
              onClick={() => handleStatusUpdate(statusDialog.booking?.id, 'cancelled')}
            >
              Cancel
            </Button>
            {statusDialog.booking?.status === 'confirmed' && (
              <Button
                variant="contained"
                color="info"
                onClick={() => handleStatusUpdate(statusDialog.booking?.id, 'completed')}
              >
                Mark Complete
              </Button>
            )}
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setStatusDialog({ open: false, booking: null })}>
            Close
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default BookingManagement;