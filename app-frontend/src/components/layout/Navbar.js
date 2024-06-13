import React from 'react';
import { Navbar, Nav, NavDropdown, Container } from 'react-bootstrap';

const NavigationBar = ({ userId, userInfo, status }) => {
  return (
    <Navbar bg="light" expand="lg">
      <Container fluid>
        <Navbar.Brand href="./">
          <img
            src="logo192.png"
            alt="Logo"
            className="d-inline-block align-text-top"
            style={{ width: '30px', height: '30px', marginRight: '6px' }}
          />
          Aquabiostable
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="navbarNav" />
        <Navbar.Collapse id="navbarNav">
          <Nav className="me-auto">
            {userId && (
              <>
                <Nav.Link href="./index">Inicio</Nav.Link>
                <NavDropdown title="Subscribers" id="sales-dropdown">
                  <NavDropdown.Item href="./index">New Subscriber</NavDropdown.Item>
                  <NavDropdown.Item href="#">See Subscribers</NavDropdown.Item>
                  <NavDropdown.Divider />
                  <NavDropdown.Item href="#">Options</NavDropdown.Item>
                </NavDropdown>
                <Nav.Link disabled>{status}</Nav.Link>
              </>
            )}
          </Nav>
          <Nav>
            {userId ? (
              <>
                <Nav.Link href="./logout">Cerrar sesión</Nav.Link>
                <NavDropdown title={userInfo.nombres} id="user-dropdown" align="end">
                  <NavDropdown.Item href="#">Datos de Usuario</NavDropdown.Item>
                  <NavDropdown.Divider />
                  <NavDropdown.Item href="#">Cambiar Contraseña</NavDropdown.Item>
                </NavDropdown>
              </>
            ) : (
              <Nav.Link href="./login">Iniciar sesión</Nav.Link>
            )}
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
};

export default NavigationBar;
