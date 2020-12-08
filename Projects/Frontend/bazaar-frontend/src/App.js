import React, { Fragment } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import './App.css';

//screens
import ProfilePage from "./screens/Profile-page";
import SignIn from "./screens/Sign-In"
import SignUp from "./screens/Sign-Up"
import Home from "./screens/Home"
import ForgotPassword from "./screens/Sign-In/forgot-password"
import MyList from "./screens/MyList/MyList"

//components
import Header from "./components/Header"
import Footer from "./components/Footer"


function App() {
  return (
    <Router>

      <Switch>
        <Route exact path="/">
          <Header />
          <Home />
        </Route>
        <Route path="/signUp">
          <Header />
          <SignUp />
        </Route>
        <Route path="/signIn">
          <Header />
          <SignIn />
        </Route>
        <Route path="/forgot-password">
          <Header />
          <ForgotPassword />
        </Route>
        <Route path="/profile-page">
          <Header />
          <ProfilePage />
        </Route>
        <Route path="/my-list">
          <Header />
          <MyList />
        </Route>
      </Switch>

      <Footer />

    </Router>
  );
}

export default App;
