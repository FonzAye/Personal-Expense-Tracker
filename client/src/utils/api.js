import axios from 'axios';

export const checkHealth = async () => {
  const response = await axios.get('/api/health');
  return response.data;
};