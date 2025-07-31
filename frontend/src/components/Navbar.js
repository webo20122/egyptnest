import React, { useState } from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  IconButton,
  Menu,
  MenuItem,
  Avatar,
  Box,
  Badge,
} from '@mui/material';
import {
  Message as MessageIcon,
  Dashboard as DashboardIcon,
  Person as PersonIcon,
  Logout as LogoutIcon,
} from '@mui/icons-material';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const Navbar = () => {
  const { user, logout, isHost } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [anchorEl, setAnchorEl] = useState(null);

  const handleMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = () => {
    logout();
    handleMenuClose();
    navigate('/login');
  };

  const handleNavigation = (path) => {
    navigate(path);
    handleMenuClose();
  };

  // Don't show navbar on login/register pages
  if (location.pathname === '/login' || location.pathname === '/register') {
    return null;
  }

  // Don't show navbar if user is not authenticated
  if (!user) {
    return null;
  }

  return (
    <AppBar position="static" color="primary" elevation={1}>
      <Toolbar>
        <Typography
          variant="h6"
          component="div"
          sx={{ flexGrow: 1, cursor: 'pointer' }}
          onClick={() => navigate('/')}
        >
          🏺 EgyptNest
        </Typography>

        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          {/* Messages Icon */}
          <IconButton
            color="inherit"
            onClick={() => navigate('/messages')}
          >
            <Badge badgeContent={0} color="error">
              <MessageIcon />
            </Badge>
          </IconButton>

          {/* Host Dashboard Button (only for hosts) */}
          {isHost && (
            <Button
              color="inherit"
              startIcon={<DashboardIcon />}
              onClick={() => navigate('/host-dashboard')}
            >
              Host Dashboard
            </Button>
          )}

          {/* User Menu */}
          <IconButton
            color="inherit"
            onClick={handleMenuOpen}
          >
            <Avatar
              sx={{ width: 32, height: 32 }}
              src={user?.profile_image}
            >
              {user?.first_name?.charAt(0)}
            </Avatar>
          </IconButton>

          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
            anchorOrigin={{
              vertical: 'bottom',
              horizontal: 'right',
            }}
            transformOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
          >
            <MenuItem onClick={() => handleNavigation('/profile')}>
              <PersonIcon sx={{ mr: 1 }} />
              Profile & Settings
            </MenuItem>
            
            <MenuItem onClick={() => handleNavigation('/bookings')}>
              <DashboardIcon sx={{ mr: 1 }} />
              My Bookings
            </MenuItem>
            
            <MenuItem onClick={handleLogout}>
              <LogoutIcon sx={{ mr: 1 }} />
              Logout
            </MenuItem>
          </Menu>
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;