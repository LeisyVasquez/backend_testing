const { Router } = require('express')
const router = Router()
const { pool } = require('../database/config')
const validator = require('express-joi-validation').createValidator({})
const { bodySchema } = require('../schemas/actor')

router.get('/actor', async (req, res) => {
  let cliente = await pool.connect()
  const { user, password } = req.query

  try {
    let result = await cliente.query(
      `SELECT * FROM actores WHERE contrasena = $1 AND correo = $2`,
      [password, user]
    )
    res.json(result.rows)
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.post('/actor', validator.body(bodySchema), async (req, res) => {
  try {
    const {
      documento,
      tipo_documento,
      nombres,
      apellidos,
      contrasena,
      correo,
      telefono_celular,
      numero_expediente,
      genero,
      fecha_nacimiento,
      estado_actor_id,
      institucion_id,
      tipo_actor_id,
      fecha_creacion,
      fecha_actualizacion
    } = req.body
    const cliente = await pool.connect()
    const response = await cliente.query(
      `INSERT INTO actores(documento, tipo_documento, nombres, apellidos, contrasena, correo, telefono_celular, numero_expediente, genero, fecha_nacimiento, estado_actor_id, institucion_id, tipo_actor_id, fecha_creacion,fecha_actualizacion) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) RETURNING id`,
      [
        documento,
        tipo_documento,
        nombres,
        apellidos,
        contrasena,
        correo,
        telefono_celular,
        numero_expediente,
        genero,
        fecha_nacimiento,
        estado_actor_id,
        institucion_id,
        tipo_actor_id,
        fecha_creacion,
        fecha_actualizacion
      ]
    )
    if (response.rowCount > 0) {
      res.json({
        id: response.rows[0].id,
        documento: documento,
        tipo_documento: tipo_documento,
        nombres: nombres,
        apellidos: apellidos,
        contrasena: contrasena,
        correo: correo,
        telefono_celular: telefono_celular,
        numero_expediente: numero_expediente,
        genero: genero,
        fecha_nacimiento: fecha_nacimiento,
        estado_actor_id: estado_actor_id,
        institucion_id: institucion_id,
        tipo_actor_id: tipo_actor_id,
        fecha_creacion: fecha_creacion,
        fecha_actualizacion: fecha_actualizacion
      })
    } else {
      res.json({ message: 'No se pudo crear el actor' })
    }
  } catch (e) {
    console.log(e)
    res
      .status(500)
      .json({ errorCode: e.errno, message: 'Error en el servidor' })
  } finally {
    cliente.release(true)
  }
})

/**
 * @swagger
 * /actor/:id:
 *  put:
 *   description: Se actualiza a un actor según su id de actor
 *   tags: [Actor]
 *   responses: 
 *     '200': 
 *      description: Se actualizó todo correctamente
 *     '503':
 *      description: Ocurrió un evento inesperado en el backend
 *     '500':
 *       description: Error del servidor
 */
router.put('/actor/:id', async (req, res) => {
  let cliente = await pool.connect()
  const { id } = req.params
  const {
    documento,
    tipo_documento,
    nombres,
    apellidos,
    contrasena,
    correo,
    telefono_celular,
    numero_expediente,
    genero,
    fecha_nacimiento,
    estado_actor_id,
    institucion_id,
    tipo_actor_id,
    fecha_creacion,
    fecha_actualizacion
  } = req.body
  try {
    const result = await cliente.query(
      `UPDATE actores SET documento = $1, tipo_documento = $2, nombres = $3, apellidos = $4, contrasena = $5, correo = $6, telefono_celular = $7, numero_expediente = $8, genero = $9, fecha_nacimiento = $10, estado_actor_id = $11, institucion_id = $12, tipo_actor_id = $13, fecha_creacion = $14, fecha_actualizacion = $15 WHERE id = $16`,
      [
        documento,
        tipo_documento,
        nombres,
        apellidos,
        contrasena,
        correo,
        telefono_celular,
        numero_expediente,
        genero,
        fecha_nacimiento,
        estado_actor_id,
        institucion_id,
        tipo_actor_id,
        fecha_creacion,
        fecha_actualizacion,
        id
      ]
    )
    if (result.rowCount > 0) {
      res.json({ message: 'Actualización realizada correctamente' })
    } else {
      res
        .status(503)
        .json({ message: 'Ocurrio un envento inesperado, intente de nuevo' })
    }
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.delete('/actor/:id', async (req, res) => {
  let cliente = await pool.connect()
  const { id } = req.params
  try {
    const resultUser = await cliente.query(
      `SELECT * FROM actores WHERE id = $1`,
      [id]
    )
    if (resultUser.rows.length > 0) {
      const result = await cliente.query(`DELETE FROM actores WHERE id = $1`, [
        id
      ])
      if (result.rowCount > 0) res.send('Actor eliminado exitosamente')
      else res.send('No se eliminó, ocurrió un evento inesperado')
    } else {
      res.status(409).json({ message: 'Error en dato en dato enviado' })
    }
  } catch (err) {
    if (err.code == 23503) {
      res
        .status(417)
        .json({ error: 'No se puede eliminar desde aquí este dato' })
    }
    res.status(500).json({ error: 'Error server' })
  } finally {
    cliente.release(true)
  }
})


module.exports = router
