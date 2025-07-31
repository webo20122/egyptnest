import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Box,
  Grid,
  Card,
  CardContent,
  Button,
  Chip,
  Avatar,
  Divider,
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Rating,
  ImageList,
  ImageListItem,
} from '@mui/material';
import {
  LocationOn as LocationIcon,
  People as PeopleIcon,
  Bed as BedIcon,
  Bathtub as BathIcon,
  Star as StarIcon,
  Message as MessageIcon,
} from '@mui/icons-material';
import { useParams, useNavigate } from 'react-router-dom';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { propertyAPI, bookingAPI, messageAPI, userAPI } from '../utils/api';
import { useAuth } from '../contexts/AuthContext';
import LoadingSpinner from '../components/LoadingSpinner';

const PropertyDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const [property, setProperty] = useState(null);
  const [host, setHost] = useState(null);
  const [loading, setLoading] = useState(true);
  const [bookingDialog, setBookingDialog] = useState(false);
  const [bookingData, setBookingData] = useState({
    check_in: null,
    check_out: null,
    guests: 1,
  });
  const [totalPrice, setTotalPrice] = useState(0);

  useEffect(() => {
    fetchProperty();
  }, [id]);

  useEffect(() => {
    calculateTotalPrice();
  }, [bookingData.check_in, bookingData.check_out, property]);

  const fetchProperty = async () => {
    try {
      const response = await propertyAPI.getProperty(id);
      setProperty(response.data);
      
      // Fetch host details
      const hostResponse = await userAPI.getUserById(response.data.host_id);
      setHost(hostResponse.data);
    } catch (error) {
      console.error('Error fetching property:', error);
    } finally {
      setLoading(false);
    }
  };

  const calculateTotalPrice = () => {
    if (bookingData.check_in && bookingData.check_out && property) {
      const nights = Math.ceil(
        (new Date(bookingData.check_out) - new Date(bookingData.check_in)) / (1000 * 60 * 60 * 24)
      );
      setTotalPrice(nights * property.price_per_night);
    }
  };

  const handleBooking = async () => {
    try {
      const bookingPayload = {
        property_id: property.id,
        check_in: bookingData.check_in.toISOString(),
        check_out: bookingData.check_out.toISOString(),
        guests: bookingData.guests,
        total_price: totalPrice,
      };

      await bookingAPI.createBooking(bookingPayload);
      setBookingDialog(false);
      navigate('/bookings');
    } catch (error) {
      console.error('Error creating booking:', error);
      alert('Failed to create booking. Please try again.');
    }
  };

  const handleContactHost = async () => {
    try {
      const response = await messageAPI.createConversation(host.id, property.id);
      navigate(`/messages/${response.data.conversation_id}`);
    } catch (error) {
      console.error('Error creating conversation:', error);
    }
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  if (!property) {
    return (
      <Container maxWidth="md" sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="h5">Property not found</Typography>
      </Container>
    );
  }

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Container maxWidth="lg" sx={{ py: 4 }}>
        <Grid container spacing={4}>
          {/* Property Images */}
          <Grid item xs={12}>
            {property.images && property.images.length > 0 ? (
              <ImageList variant="quilted" cols={4} rowHeight={200}>
                {property.images.slice(0, 6).map((image, index) => (
                  <ImageListItem key={index} cols={index === 0 ? 2 : 1} rows={index === 0 ? 2 : 1}>
                    <img
                      src={image}
                      alt={`${property.title} ${index + 1}`}
                      loading="lazy"
                      style={{ borderRadius: 8 }}
                    />
                  </ImageListItem>
                ))}
              </ImageList>
            ) : (
              <Box
                sx={{
                  width: '100%',
                  height: 300,
                  backgroundColor: 'grey.200',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  borderRadius: 2,
                }}
              >
                <Typography color="text.secondary">No images available</Typography>
              </Box>
            )}
          </Grid>

          {/* Property Info */}
          <Grid item xs={12} md={8}>
            <Box sx={{ mb: 3 }}>
              <Typography variant="h4" gutterBottom>
                {property.title}
              </Typography>
              
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                <LocationIcon sx={{ mr: 1, color: 'text.secondary' }} />
                <Typography variant="body1" color="text.secondary">
                  {property.location?.address}, {property.location?.city}, {property.location?.country}
                </Typography>
              </Box>

              <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                <Chip
                  label={property.property_type}
                  color="primary"
                  sx={{ textTransform: 'capitalize' }}
                />
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <PeopleIcon sx={{ mr: 0.5 }} />
                  <Typography>{property.max_guests} guests</Typography>
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <BedIcon sx={{ mr: 0.5 }} />
                  <Typography>{property.bedrooms} bedrooms</Typography>
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <BathIcon sx={{ mr: 0.5 }} />
                  <Typography>{property.bathrooms} bathrooms</Typography>
                </Box>
              </Box>

              <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Rating value={property.rating || 0} readOnly precision={0.1} />
                <Typography variant="body2" sx={{ ml: 1 }}>
                  ({property.review_count || 0} reviews)
                </Typography>
              </Box>
            </Box>

            <Divider sx={{ mb: 3 }} />

            {/* Description */}
            <Box sx={{ mb: 3 }}>
              <Typography variant="h6" gutterBottom>
                About this place
              </Typography>
              <Typography variant="body1" paragraph>
                {property.description}
              </Typography>
            </Box>

            {/* Amenities */}
            <Box sx={{ mb: 3 }}>
              <Typography variant="h6" gutterBottom>
                Amenities
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                {property.amenities?.map((amenity, index) => (
                  <Chip key={index} label={amenity} variant="outlined" />
                ))}
              </Box>
            </Box>

            {/* Host Info */}
            {host && (
              <Box sx={{ mb: 3 }}>
                <Typography variant="h6" gutterBottom>
                  Hosted by {host.first_name}
                </Typography>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                  <Avatar src={host.profile_image} sx={{ mr: 2 }}>
                    {host.first_name?.charAt(0)}
                  </Avatar>
                  <Box>
                    <Typography variant="subtitle1">
                      {host.first_name} {host.last_name}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {host.is_verified ? '✅ Verified Host' : 'Host'}
                    </Typography>
                  </Box>
                </Box>
                <Button
                  variant="outlined"
                  startIcon={<MessageIcon />}
                  onClick={handleContactHost}
                >
                  Contact Host
                </Button>
              </Box>
            )}
          </Grid>

          {/* Booking Card */}
          <Grid item xs={12} md={4}>
            <Card sx={{ position: 'sticky', top: 20 }}>
              <CardContent>
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 3 }}>
                  <Typography variant="h5">
                    ${property.price_per_night}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    per night
                  </Typography>
                </Box>

                <Button
                  variant="contained"
                  fullWidth
                  size="large"
                  onClick={() => setBookingDialog(true)}
                  sx={{ mb: 2 }}
                >
                  Reserve
                </Button>

                <Typography variant="body2" color="text.secondary" align="center">
                  You won't be charged yet
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>

        {/* Booking Dialog */}
        <Dialog open={bookingDialog} onClose={() => setBookingDialog(false)} maxWidth="sm" fullWidth>
          <DialogTitle>Reserve {property.title}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Check-in"
                  value={bookingData.check_in}
                  onChange={(date) => setBookingData(prev => ({ ...prev, check_in: date }))}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                  minDate={new Date()}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Check-out"
                  value={bookingData.check_out}
                  onChange={(date) => setBookingData(prev => ({ ...prev, check_out: date }))}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                  minDate={bookingData.check_in || new Date()}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  label="Number of guests"
                  type="number"
                  fullWidth
                  value={bookingData.guests}
                  onChange={(e) => setBookingData(prev => ({ ...prev, guests: parseInt(e.target.value) }))}
                  inputProps={{ min: 1, max: property.max_guests }}
                />
              </Grid>
              {totalPrice > 0 && (
                <Grid item xs={12}>
                  <Box sx={{ mt: 2, p: 2, backgroundColor: 'grey.50', borderRadius: 1 }}>
                    <Typography variant="h6">
                      Total: ${totalPrice}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      For {Math.ceil((new Date(bookingData.check_out) - new Date(bookingData.check_in)) / (1000 * 60 * 60 * 24))} nights
                    </Typography>
                  </Box>
                </Grid>
              )}
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setBookingDialog(false)}>Cancel</Button>
            <Button
              onClick={handleBooking}
              variant="contained"
              disabled={!bookingData.check_in || !bookingData.check_out || totalPrice === 0}
            >
              Confirm Booking
            </Button>
          </DialogActions>
        </Dialog>
      </Container>
    </LocalizationProvider>
  );
};

export default PropertyDetails;