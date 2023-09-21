import { handler } from '../src/index';
const event = {
    "url": "https://ehost.host",
    "WEBSOCKET_USERNAME": "kam",
    "WEBSOCKET_PASSWORD": "KamKamKam@1234",
    "WEBSOCKET_PAIR": "BTC/USD"
  }
handler(event);