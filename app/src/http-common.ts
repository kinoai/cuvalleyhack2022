import axios from "axios";

export default axios.create({
  baseURL: `http://${process.env.REACT_APP_API_URL}`,
  headers: {
    "accept": "application/json"
  }
});