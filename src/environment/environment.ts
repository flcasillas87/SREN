export const environment = {
  production: false,

  // URL de la API
  apiUrl: 'http://localhost:4200',

  // Clave de la API
  apiKey: 'YOUR_API_KEY',

  socketUrl: 'ws://localhost:4200',

  // Configuración de Firebase
  firebaseConfig: {
    apiKey: 'AIzaSyBUHttGYbkgyNky2RhSjlhrIoe2Srf0PVA',
    authDomain: 'sren-26321.firebaseapp.com',
    databaseURL: 'https://sren-26321-default-rtdb.firebaseio.com',
    projectId: 'sren-26321',
    storageBucket: 'sren-26321.appspot.com',
    messagingSenderId: '934110277189',
    appId: '1:934110277189:web:12ba6b99a608953885bd2c',
    measurementId: 'G-H6ESY9PTS6',
  },

  googleAnalyticsId: 'UA-123456789-1',
  featureFlags: {
    enableNewFeature: true,
    enableExperimentalFeature: false,
  },

  customApiKey: 'YOUR_CUSTOM_API_KEY',
};
