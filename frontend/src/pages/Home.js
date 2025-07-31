import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Box,
  Grid,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Chip,
  Paper,
} from '@mui/material';
import {
  Search as SearchIcon,
  FilterList as FilterIcon,
} from '@mui/icons-material';
import PropertyCard from '../components/PropertyCard';
import LoadingSpinner from '../components/LoadingSpinner';
import { propertyAPI } from '../utils/api';

const Home = () => {
  const [properties, setProperties] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchParams, setSearchParams] = useState({
    city: '',
    property_type: '',
    min_price: '',
    max_price: '',
  });
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    fetchProperties();
  }, []);

  const fetchProperties = async (params = {}) => {
    try {
      setLoading(true);
      const response = await propertyAPI.getProperties(params);
      setProperties(response.data.properties);
    } catch (error) {
      console.error('Error fetching properties:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    const filteredParams = Object.fromEntries(
      Object.entries(searchParams).filter(([_, value]) => value !== '')
    );
    fetchProperties(filteredParams);
  };

  const handleFilterChange = (field, value) => {
    setSearchParams(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const clearFilters = () => {
    setSearchParams({
      city: '',
      property_type: '',
      min_price: '',
      max_price: '',
    });
    fetchProperties();
  };

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      {/* Hero Section */}
      <Box sx={{ textAlign: 'center', mb: 6 }}>
        <Typography variant="h2" component="h1" gutterBottom>
          Find Your Perfect Stay in Egypt
        </Typography>
        <Typography variant="h6" color="text.secondary" sx={{ mb: 4 }}>
          Discover unique accommodations from the pyramids to the Red Sea
        </Typography>

        {/* Search Bar */}
        <Paper elevation={2} sx={{ p: 3, mb: 3 }}>
          <Box sx={{ display: 'flex', gap: 2, alignItems: 'center', flexWrap: 'wrap' }}>
            <TextField
              label="Search by city"
              variant="outlined"
              value={searchParams.city}
              onChange={(e) => handleFilterChange('city', e.target.value)}
              sx={{ flexGrow: 1, minWidth: 200 }}
            />
            <Button
              variant="contained"
              startIcon={<SearchIcon />}
              onClick={handleSearch}
              sx={{ minWidth: 120 }}
            >
              Search
            </Button>
            <Button
              variant="outlined"
              startIcon={<FilterIcon />}
              onClick={() => setShowFilters(!showFilters)}
            >
              Filters
            </Button>
          </Box>

          {/* Filters */}
          {showFilters && (
            <Box sx={{ mt: 3, pt: 3, borderTop: 1, borderColor: 'divider' }}>
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6} md={3}>
                  <FormControl fullWidth>
                    <InputLabel>Property Type</InputLabel>
                    <Select
                      value={searchParams.property_type}
                      label="Property Type"
                      onChange={(e) => handleFilterChange('property_type', e.target.value)}
                    >
                      <MenuItem value="">All Types</MenuItem>
                      <MenuItem value="apartment">Apartment</MenuItem>
                      <MenuItem value="house">House</MenuItem>
                      <MenuItem value="villa">Villa</MenuItem>
                      <MenuItem value="room">Room</MenuItem>
                    </Select>
                  </FormControl>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <TextField
                    label="Min Price"
                    type="number"
                    fullWidth
                    value={searchParams.min_price}
                    onChange={(e) => handleFilterChange('min_price', e.target.value)}
                  />
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <TextField
                    label="Max Price"
                    type="number"
                    fullWidth
                    value={searchParams.max_price}
                    onChange={(e) => handleFilterChange('max_price', e.target.value)}
                  />
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <Button
                    variant="outlined"
                    fullWidth
                    onClick={clearFilters}
                    sx={{ height: 56 }}
                  >
                    Clear Filters
                  </Button>
                </Grid>
              </Grid>
            </Box>
          )}
        </Paper>
      </Box>

      {/* Properties Grid */}
      {loading ? (
        <LoadingSpinner />
      ) : (
        <>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
            <Typography variant="h5">
              {properties.length} properties found
            </Typography>
          </Box>

          {properties.length === 0 ? (
            <Box sx={{ textAlign: 'center', py: 8 }}>
              <Typography variant="h6" color="text.secondary">
                No properties found matching your criteria
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                Try adjusting your search filters
              </Typography>
            </Box>
          ) : (
            <Grid container spacing={3}>
              {properties.map((property) => (
                <Grid item xs={12} sm={6} md={4} key={property.id}>
                  <PropertyCard property={property} />
                </Grid>
              ))}
            </Grid>
          )}
        </>
      )}
    </Container>
  );
};

export default Home;