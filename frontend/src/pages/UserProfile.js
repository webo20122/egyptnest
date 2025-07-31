import React, { useState, useEffect } from 'react';
import {
  Container,
  Paper,
  Typography,
  Box,
  TextField,
  Button,
  Avatar,
  Grid,
  Divider,
  Alert,
  Switch,
  FormControlLabel,
} from '@mui/material';
import {
  Edit as EditIcon,
  Save as SaveIcon,
  Cancel as CancelIcon,
} from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import { userAPI } from '../utils/api';

const UserProfile = () => {
  const { user, updateUser } = useAuth();
  const [profile, setProfile] = useState(null);
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({});
  const [success, setSuccess] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchProfile();
  }, []);

  const fetchProfile = async () => {
    try {
      const response = await userAPI.getProfile();
      setProfile(response.data);
      setFormData(response.data);
    } catch (error) {
      setError('Failed to load profile');
    }
  };

  const handleEdit = () => {
    setEditing(true);
    setError('');
    setSuccess('');
  };

  const handleCancel = () => {
    setEditing(false);
    setFormData(profile);
  };

  const handleSave = async () => {
    try {
      setLoading(true);
      const updateData = {
        first_name: formData.first_name,
        last_name: formData.last_name,
        phone: formData.phone,
      };
      
      const response = await userAPI.updateProfile(updateData);
      setProfile(response.data.user);
      updateUser(response.data.user);
      setEditing(false);
      setSuccess('Profile updated successfully!');
    } catch (error) {
      setError('Failed to update profile');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  if (!profile) {
    return <Container><Typography>Loading...</Typography></Container>;
  }

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={2} sx={{ p: 4 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
          <Typography variant="h4">Profile & Settings</Typography>
          {!editing ? (
            <Button
              variant="outlined"
              startIcon={<EditIcon />}
              onClick={handleEdit}
            >
              Edit Profile
            </Button>
          ) : (
            <Box sx={{ display: 'flex', gap: 1 }}>
              <Button
                variant="contained"
                startIcon={<SaveIcon />}
                onClick={handleSave}
                disabled={loading}
              >
                Save
              </Button>
              <Button
                variant="outlined"
                startIcon={<CancelIcon />}
                onClick={handleCancel}
              >
                Cancel
              </Button>
            </Box>
          )}
        </Box>

        {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}

        {/* Profile Header */}
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 4 }}>
          <Avatar
            sx={{ width: 80, height: 80, mr: 3 }}
            src={profile.profile_image}
          >
            {profile.first_name?.charAt(0)}
          </Avatar>
          <Box>
            <Typography variant="h5">
              {profile.first_name} {profile.last_name}
            </Typography>
            <Typography variant="body1" color="text.secondary">
              {profile.user_type === 'host' ? '🏠 Host' : '🧳 Guest'}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Member since {new Date(profile.created_at).toLocaleDateString()}
            </Typography>
          </Box>
        </Box>

        <Divider sx={{ mb: 4 }} />

        {/* Profile Information */}
        <Typography variant="h6" gutterBottom>
          Personal Information
        </Typography>
        
        <Grid container spacing={3} sx={{ mb: 4 }}>
          <Grid item xs={12} sm={6}>
            <TextField
              label="First Name"
              fullWidth
              value={formData.first_name || ''}
              onChange={(e) => handleChange('first_name', e.target.value)}
              disabled={!editing}
            />
          </Grid>
          <Grid item xs={12} sm={6}>
            <TextField
              label="Last Name"
              fullWidth
              value={formData.last_name || ''}
              onChange={(e) => handleChange('last_name', e.target.value)}
              disabled={!editing}
            />
          </Grid>
          <Grid item xs={12} sm={6}>
            <TextField
              label="Email"
              fullWidth
              value={profile.email}
              disabled
              helperText="Email cannot be changed"
            />
          </Grid>
          <Grid item xs={12} sm={6}>
            <TextField
              label="Phone"
              fullWidth
              value={formData.phone || ''}
              onChange={(e) => handleChange('phone', e.target.value)}
              disabled={!editing}
            />
          </Grid>
        </Grid>

        <Divider sx={{ mb: 4 }} />

        {/* Account Settings */}
        <Typography variant="h6" gutterBottom>
          Account Settings
        </Typography>
        
        <Box sx={{ mb: 3 }}>
          <FormControlLabel
            control={<Switch defaultChecked />}
            label="Email notifications for bookings"
          />
        </Box>
        
        <Box sx={{ mb: 3 }}>
          <FormControlLabel
            control={<Switch defaultChecked />}
            label="SMS notifications for urgent updates"
          />
        </Box>
        
        <Box sx={{ mb: 3 }}>
          <FormControlLabel
            control={<Switch />}
            label="Marketing emails"
          />
        </Box>

        <Divider sx={{ mb: 4 }} />

        {/* Account Status */}
        <Typography variant="h6" gutterBottom>
          Account Status
        </Typography>
        
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <Typography variant="body1" sx={{ mr: 2 }}>
            Email Verification:
          </Typography>
          <Typography
            variant="body2"
            color={profile.is_verified ? 'success.main' : 'warning.main'}
          >
            {profile.is_verified ? '✅ Verified' : '⚠️ Not Verified'}
          </Typography>
        </Box>

        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <Typography variant="body1" sx={{ mr: 2 }}>
            Account Type:
          </Typography>
          <Typography variant="body2" sx={{ textTransform: 'capitalize' }}>
            {profile.user_type}
          </Typography>
        </Box>
      </Paper>
    </Container>
  );
};

export default UserProfile;