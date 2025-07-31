import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Box,
  Grid,
  Card,
  CardContent,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  Avatar,
} from '@mui/material';
import {
  Add as AddIcon,
  Home as HomeIcon,
  AttachMoney as MoneyIcon,
  EventNote as BookingIcon,
  Star as StarIcon,
} from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import { propertyAPI, bookingAPI } from '../utils/api';
import LoadingSpinner from '../components/LoadingSpinner';

const HostDashboard = () => {
  const { user, isHost } = useAuth();
  const [properties, setProperties] = useState([]);
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalProperties: 0,
    totalEarnings: 0,
    totalBookings: 0,
    averageRating: 0,
  });

  useEffect(() => {
    if (isHost) {
      fetchDashboardData();
    }
  }, [isHost]);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      const [propertiesResponse, bookingsResponse] = await Promise.all([
        propertyAPI.getHostProperties(),
        bookingAPI.getHostBookings(),
      ]);

      const propertiesData = propertiesResponse.data.properties;
      const bookingsData = bookingsResponse.data.bookings;

      setProperties(propertiesData);
      setBookings(bookingsData);

      // Calculate stats
      const totalEarnings = bookingsData
        .filter(b => b.status === 'completed')
        .reduce((sum, b) => sum + b.total_price, 0);

      const avgRating = propertiesData.length > 0
        ? propertiesData.reduce((sum, p) => sum + (p.rating || 0), 0) / propertiesData.length
        : 0;

      setStats({
        totalProperties: propertiesData.length,
        totalEarnings,
        totalBookings: bookingsData.length,
        averageRating: avgRating,
      });
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
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

  if (!isHost) {
    return (
      <Container maxWidth="md" sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="h5">
          You need to be a host to access this dashboard
        </Typography>
      </Container>
    );
  }

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4">Host Dashboard</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => {/* TODO: Navigate to add property */}}
        >
          Add New Property
        </Button>
      </Box>

      {/* Stats Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Avatar sx={{ bgcolor: 'primary.main', mr: 2 }}>
                  <HomeIcon />
                </Avatar>
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Properties
                  </Typography>
                  <Typography variant="h5">
                    {stats.totalProperties}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Avatar sx={{ bgcolor: 'success.main', mr: 2 }}>
                  <MoneyIcon />
                </Avatar>
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Total Earnings
                  </Typography>
                  <Typography variant="h5">
                    ${stats.totalEarnings.toFixed(2)}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Avatar sx={{ bgcolor: 'info.main', mr: 2 }}>
                  <BookingIcon />
                </Avatar>
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Total Bookings
                  </Typography>
                  <Typography variant="h5">
                    {stats.totalBookings}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Avatar sx={{ bgcolor: 'warning.main', mr: 2 }}>
                  <StarIcon />
                </Avatar>
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Average Rating
                  </Typography>
                  <Typography variant="h5">
                    {stats.averageRating.toFixed(1)}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Recent Bookings */}
      <Card sx={{ mb: 4 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Recent Bookings
          </Typography>
          {bookings.length === 0 ? (
            <Typography color="text.secondary">
              No bookings yet
            </Typography>
          ) : (
            <TableContainer>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>Guest</TableCell>
                    <TableCell>Property</TableCell>
                    <TableCell>Check-in</TableCell>
                    <TableCell>Check-out</TableCell>
                    <TableCell>Amount</TableCell>
                    <TableCell>Status</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {bookings.slice(0, 5).map((booking) => (
                    <TableRow key={booking.id}>
                      <TableCell>
                        {booking.guest?.first_name} {booking.guest?.last_name}
                      </TableCell>
                      <TableCell>
                        {booking.property?.title}
                      </TableCell>
                      <TableCell>
                        {new Date(booking.check_in).toLocaleDateString()}
                      </TableCell>
                      <TableCell>
                        {new Date(booking.check_out).toLocaleDateString()}
                      </TableCell>
                      <TableCell>
                        ${booking.total_price}
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={booking.status}
                          color={getStatusColor(booking.status)}
                          size="small"
                          sx={{ textTransform: 'capitalize' }}
                        />
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </CardContent>
      </Card>

      {/* Properties List */}
      <Card>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            My Properties
          </Typography>
          {properties.length === 0 ? (
            <Box sx={{ textAlign: 'center', py: 4 }}>
              <Typography color="text.secondary" gutterBottom>
                No properties listed yet
              </Typography>
              <Button
                variant="contained"
                startIcon={<AddIcon />}
                onClick={() => {/* TODO: Navigate to add property */}}
              >
                Add Your First Property
              </Button>
            </Box>
          ) : (
            <TableContainer>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>Property</TableCell>
                    <TableCell>Type</TableCell>
                    <TableCell>Location</TableCell>
                    <TableCell>Price/Night</TableCell>
                    <TableCell>Rating</TableCell>
                    <TableCell>Status</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {properties.map((property) => (
                    <TableRow key={property.id}>
                      <TableCell>
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                          <Avatar
                            variant="rounded"
                            src={property.images?.[0]}
                            sx={{ width: 40, height: 40, mr: 2 }}
                          />
                          {property.title}
                        </Box>
                      </TableCell>
                      <TableCell sx={{ textTransform: 'capitalize' }}>
                        {property.property_type}
                      </TableCell>
                      <TableCell>
                        {property.location?.city}
                      </TableCell>
                      <TableCell>
                        ${property.price_per_night}
                      </TableCell>
                      <TableCell>
                        {property.rating?.toFixed(1) || 'N/A'} ⭐
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={property.is_active ? 'Active' : 'Inactive'}
                          color={property.is_active ? 'success' : 'default'}
                          size="small"
                        />
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </CardContent>
      </Card>
    </Container>
  );
};

export default HostDashboard;