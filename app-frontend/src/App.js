import React from 'react';
import NavigationBar from './components/layout/Navbar';
import UserForm from './components/users/UserForm';

const App = () => {
  const userId = 1;
  const userInfo = { nombres: 'David C.' };
  const status = 'Activo';

  return (
    <div>
      <NavigationBar userId={userId} userInfo={userInfo} status={status} />
      <div className="container mt-5">
        <h1>Demo App</h1>
        <UserForm />
      </div>
    </div>
  );
};

export default App;
