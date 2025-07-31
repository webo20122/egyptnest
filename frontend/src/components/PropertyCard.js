import React from 'react';
import {
  Card,
  CardMedia,
  CardContent,
  Typography,
  Box,
  Chip,
  IconButton,
  Rating,
} from '@mui/material';
import {
  Favorite as FavoriteIcon,
  LocationOn as LocationIcon,
  People as PeopleIcon,
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';

const PropertyCard = ({ property }) => {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate(`/property/${property.id}`);
  };

  return (
    <Card 
      sx={{ 
        maxWidth: 345, 
        cursor: 'pointer',
        '&:hover': {
          transform: 'translateY(-4px)',
          boxShadow: 4,
        },
        transition: 'all 0.3s ease-in-out'
      }}
      onClick={handleClick}
    >
      <Box sx={{ position: 'relative' }}>
        <CardMedia
          component="img"
          height="200"
          image={property.images?.[0] || '/placeholder.jpg'}
          alt={property.title}
        />
        <IconButton
          sx={{
            position: 'absolute',
            top: 8,
            right: 8,
            backgroundColor: 'rgba(255, 255, 255, 0.8)',
            '&:hover': {
              backgroundColor: 'rgba(255, 255, 255, 0.9)',
            }
          }}
          onClick={(e) => {
            e.stopPropagation();
            // Handle favorite toggle
          }}
        >
          <FavoriteIcon />
        </IconButton>
        
        <Chip
          label={property.property_type}
          size="small"
          color="primary"
          sx={{
            position: 'absolute',
            top: 8,
            left: 8,
            textTransform: 'capitalize'
          }}
        />
      </Box>
      
      <CardContent>
        <Typography variant="h6" component="div" noWrap>
          {property.title}
        </Typography>
        
        <Box sx={{ display: 'flex', alignItems: 'center', mt: 1, mb: 1 }}>
          <LocationIcon sx={{ fontSize: 16, color: 'text.secondary', mr: 0.5 }} />
          <Typography variant="body2" color="text.secondary" noWrap>
            {property.location?.city}, {property.location?.country}
          </Typography>
        </Box>
        
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
          <PeopleIcon sx={{ fontSize: 16, color: 'text.secondary', mr: 0.5 }} />
          <Typography variant="body2" color="text.secondary">
            Up to {property.max_guests} guests • {property.bedrooms} bedrooms
          </Typography>
        </Box>
        
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mt: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <Rating
              value={property.rating || 0}
              readOnly
              size="small"
              precision={0.1}
            />
            <Typography variant="body2" color="text.secondary" sx={{ ml: 0.5 }}>
              ({property.review_count || 0})
            </Typography>
          </Box>
          
          <Typography variant="h6" color="primary">
            ${property.price_per_night}/night
          </Typography>
        </Box>
      </CardContent>
    </Card>
  );
};

export default PropertyCard;