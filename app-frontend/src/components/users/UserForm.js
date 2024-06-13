import React, { useState } from 'react';
import axios from 'axios';

const UserForm = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [message, setMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3000/users', {
        username,
        email,
      });
      setMessage('User created successfully!');
      setUsername('');
      setEmail('');
    } catch (error) {
      setMessage('Error creating user');
    }
  };

  return (
    <div className="container mt-5">
      <h2>Create Subscriber</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label className="form-label">Name</label>
          <input
            type="text"
            className="form-control"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label className="form-label">Email</label>
          <input
            type="email"
            className="form-control"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <button type="submit" className="btn btn-primary">Create Subscriber</button>
      </form>
      {message && <p className="mt-3">{message}</p>}
    </div>
  );
};

export default UserForm;
