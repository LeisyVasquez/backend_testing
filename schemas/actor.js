const Joi = require('joi')

const bodySchema = Joi.object({
    documento: Joi.string()
      .max(20)
      .required(),
    tipo_documento: Joi.string().max(3),
    nombres: Joi.string()
      .max(255)
      .required(),
    apellidos: Joi.string()
      .max(255)
      .required(),
    contrasena: Joi.string().max(80),
    correo: Joi.string().max(100),
    telefono_celular: Joi.string().max(30),
    numero_expediente: Joi.string().max(255),
    genero: Joi.string().max(6),
    fecha_nacimiento: Joi.date().less('now'),
    estado_actor_id: Joi.number()
      .integer()
      .required(),
    institucion_id: Joi.number()
      .integer()
      .required(),
    tipo_actor_id: Joi.number().integer(),
    fecha_creacion: Joi.date().less('now'),
    fecha_actualizacion: Joi.date().less('now')
  })


  module.exports = {bodySchema}