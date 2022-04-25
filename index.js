const express = require('express');
const morgan = require('morgan');
require('dotenv').config();
const cors = require('cors');
const actores = require('./routes/actores')
const institucionesEducativas = require('./routes/instituciones_educativas')
const swaggerUi = require('swagger-ui-express');
const swaggerJsDoc = require('swagger-jsdoc')

// Inicializar servidor
const app = express(); 

//Middlewares
app.use(morgan('dev'));
app.use(express.json());
app.use(cors());

// Routes

app.get('/', (req, res) => {
    res.send('Hello world')
})
app.use('/api', actores); 
app.use('/api', institucionesEducativas)



//Documentation
const swaggerOptions = {
    swaggerDefinition: {
        info: {
            title: 'API REST Academia', 
            description: 'Esta es la documentación de la API Academia, creada en la sesión de clases de backend para demostrar el uso de Swagger', 
            contact: {
                name: 'Leisy Valentina Vasquez', 
                email: 'leisy.vasquez@agileinnova.org'
            }, 
            servers: ['http://localhost:3800'], 
            version: '1.0'
        }
    }, 
    apis: ['./routes/*.js']
}

const swaggerDocs = swaggerJsDoc(swaggerOptions)
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs))


// Establecer puerto
app.set('port', process.env.PORT || 5000);

// Iniciar el servidor
app.listen(app.get('port'), () => {
    console.log('Server on port', app.get('port'));
});

