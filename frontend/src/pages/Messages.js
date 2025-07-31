import React, { useState, useEffect, useRef } from 'react';
import {
  Container,
  Typography,
  Box,
  Grid,
  Card,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Avatar,
  TextField,
  IconButton,
  Paper,
  Divider,
  Badge,
  Chip,
} from '@mui/material';
import {
  Send as SendIcon,
  Search as SearchIcon,
} from '@mui/icons-material';
import { useParams, useNavigate } from 'react-router-dom';
import { messageAPI } from '../utils/api';
import { useAuth } from '../contexts/AuthContext';
import LoadingSpinner from '../components/LoadingSpinner';

const Messages = () => {
  const { conversationId } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const [conversations, setConversations] = useState([]);
  const [messages, setMessages] = useState([]);
  const [currentConversation, setCurrentConversation] = useState(null);
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const messagesEndRef = useRef(null);

  useEffect(() => {
    fetchConversations();
  }, []);

  useEffect(() => {
    if (conversationId && conversations.length > 0) {
      const conversation = conversations.find(c => c.id === conversationId);
      if (conversation) {
        setCurrentConversation(conversation);
        fetchMessages(conversationId);
      }
    }
  }, [conversationId, conversations]);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const fetchConversations = async () => {
    try {
      const response = await messageAPI.getConversations();
      setConversations(response.data.conversations);
    } catch (error) {
      console.error('Error fetching conversations:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchMessages = async (convId) => {
    try {
      const response = await messageAPI.getMessages(convId);
      setMessages(response.data.messages);
    } catch (error) {
      console.error('Error fetching messages:', error);
    }
  };

  const handleSendMessage = async () => {
    if (!newMessage.trim() || !currentConversation) return;

    try {
      const messageData = {
        conversation_id: currentConversation.id,
        content: newMessage.trim(),
        message_type: 'text',
      };

      await messageAPI.sendMessage(messageData);
      setNewMessage('');
      fetchMessages(currentConversation.id);
      fetchConversations(); // Update last message in conversation list
    } catch (error) {
      console.error('Error sending message:', error);
    }
  };

  const handleConversationSelect = (conversation) => {
    navigate(`/messages/${conversation.id}`);
  };

  const filteredConversations = conversations.filter(conversation =>
    conversation.other_participant?.first_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    conversation.other_participant?.last_name?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatTime = (timestamp) => {
    return new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  const formatDate = (timestamp) => {
    const date = new Date(timestamp);
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    if (date.toDateString() === today.toDateString()) {
      return 'Today';
    } else if (date.toDateString() === yesterday.toDateString()) {
      return 'Yesterday';
    } else {
      return date.toLocaleDateString();
    }
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <Container maxWidth="lg" sx={{ py: 4, height: 'calc(100vh - 200px)' }}>
      <Grid container spacing={2} sx={{ height: '100%' }}>
        {/* Conversations List */}
        <Grid item xs={12} md={4}>
          <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
            <Box sx={{ p: 2, borderBottom: 1, borderColor: 'divider' }}>
              <Typography variant="h6" gutterBottom>
                Messages
              </Typography>
              <TextField
                fullWidth
                size="small"
                placeholder="Search conversations..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                InputProps={{
                  startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />,
                }}
              />
            </Box>

            <List sx={{ flexGrow: 1, overflow: 'auto', p: 0 }}>
              {filteredConversations.length === 0 ? (
                <ListItem>
                  <ListItemText
                    primary="No conversations yet"
                    secondary="Start chatting with hosts or guests!"
                  />
                </ListItem>
              ) : (
                filteredConversations.map((conversation) => (
                  <ListItem
                    key={conversation.id}
                    button
                    selected={currentConversation?.id === conversation.id}
                    onClick={() => handleConversationSelect(conversation)}
                    sx={{
                      borderBottom: 1,
                      borderColor: 'divider',
                      '&:hover': {
                        backgroundColor: 'action.hover',
                      },
                    }}
                  >
                    <ListItemAvatar>
                      <Badge
                        color="primary"
                        variant="dot"
                        invisible={!conversation.last_message || conversation.last_message.is_read}
                      >
                        <Avatar src={conversation.other_participant?.profile_image}>
                          {conversation.other_participant?.first_name?.charAt(0)}
                        </Avatar>
                      </Badge>
                    </ListItemAvatar>
                    <ListItemText
                      primary={
                        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                          <Typography variant="subtitle1" noWrap>
                            {conversation.other_participant?.first_name} {conversation.other_participant?.last_name}
                          </Typography>
                          {conversation.last_message && (
                            <Typography variant="caption" color="text.secondary">
                              {formatTime(conversation.last_message.created_at)}
                            </Typography>
                          )}
                        </Box>
                      }
                      secondary={
                        <Typography variant="body2" color="text.secondary" noWrap>
                          {conversation.last_message?.content || 'No messages yet'}
                        </Typography>
                      }
                    />
                  </ListItem>
                ))
              )}
            </List>
          </Card>
        </Grid>

        {/* Messages Area */}
        <Grid item xs={12} md={8}>
          <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
            {currentConversation ? (
              <>
                {/* Chat Header */}
                <Box sx={{ p: 2, borderBottom: 1, borderColor: 'divider' }}>
                  <Box sx={{ display: 'flex', alignItems: 'center' }}>
                    <Avatar
                      src={currentConversation.other_participant?.profile_image}
                      sx={{ mr: 2 }}
                    >
                      {currentConversation.other_participant?.first_name?.charAt(0)}
                    </Avatar>
                    <Box>
                      <Typography variant="h6">
                        {currentConversation.other_participant?.first_name} {currentConversation.other_participant?.last_name}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        {currentConversation.property_id && 'Property conversation'}
                      </Typography>
                    </Box>
                  </Box>
                </Box>

                {/* Messages */}
                <Box sx={{ flexGrow: 1, overflow: 'auto', p: 1 }}>
                  {messages.length === 0 ? (
                    <Box sx={{ textAlign: 'center', mt: 4 }}>
                      <Typography color="text.secondary">
                        No messages yet. Start the conversation!
                      </Typography>
                    </Box>
                  ) : (
                    messages.map((message, index) => {
                      const isOwn = message.sender_id === user.id;
                      const showDate = index === 0 || 
                        formatDate(message.created_at) !== formatDate(messages[index - 1].created_at);

                      return (
                        <Box key={message.id}>
                          {showDate && (
                            <Box sx={{ textAlign: 'center', my: 2 }}>
                              <Chip label={formatDate(message.created_at)} size="small" />
                            </Box>
                          )}
                          <Box
                            sx={{
                              display: 'flex',
                              justifyContent: isOwn ? 'flex-end' : 'flex-start',
                              mb: 1,
                            }}
                          >
                            <Paper
                              elevation={1}
                              sx={{
                                p: 1.5,
                                maxWidth: '70%',
                                backgroundColor: isOwn ? 'primary.main' : 'grey.100',
                                color: isOwn ? 'primary.contrastText' : 'text.primary',
                              }}
                            >
                              <Typography variant="body1">
                                {message.content}
                              </Typography>
                              <Typography
                                variant="caption"
                                sx={{
                                  display: 'block',
                                  mt: 0.5,
                                  opacity: 0.7,
                                }}
                              >
                                {formatTime(message.created_at)}
                              </Typography>
                            </Paper>
                          </Box>
                        </Box>
                      );
                    })
                  )}
                  <div ref={messagesEndRef} />
                </Box>

                {/* Message Input */}
                <Box sx={{ p: 2, borderTop: 1, borderColor: 'divider' }}>
                  <Box sx={{ display: 'flex', gap: 1 }}>
                    <TextField
                      fullWidth
                      placeholder="Type a message..."
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      onKeyPress={(e) => {
                        if (e.key === 'Enter' && !e.shiftKey) {
                          e.preventDefault();
                          handleSendMessage();
                        }
                      }}
                      multiline
                      maxRows={3}
                    />
                    <IconButton
                      color="primary"
                      onClick={handleSendMessage}
                      disabled={!newMessage.trim()}
                    >
                      <SendIcon />
                    </IconButton>
                  </Box>
                </Box>
              </>
            ) : (
              <Box
                sx={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '100%',
                }}
              >
                <Typography variant="h6" color="text.secondary">
                  Select a conversation to start messaging
                </Typography>
              </Box>
            )}
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Messages;