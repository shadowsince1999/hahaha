const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('KYA HAL HAI'));

app.listen(3000, () => console.log('Example app listening on port http://localhost:3000'));
