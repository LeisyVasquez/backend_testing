const { Router } = require('express')
const router = Router()
const { pool } = require('../database/config')
const validator = require('express-joi-validation').createValidator({})

router.get('/instituciones-educativas', async (req, res) => {
  let cliente = await pool.connect()
  try {
    let result = await cliente.query(`SELECT * FROM instituciones_educativas`)
    res.json(result.rows)
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.post('/instituciones-educativas', async (req, res) => {
  const cliente = await pool.connect()
  try {
    const {
      nombre_ie,
      docente_encargado_mt,
      pagina_web,
      direccion,
      foto_ie,
      descripcion_ie,
      telefono_institucional,
      correo_institucional
    } = req.body
    const response = await cliente.query(
      `INSERT INTO instituciones_educativas(nombre_ie, docente_encargado_mt, pagina_web, direccion, foto_ie, descripcion_ie, telefono_institucional, correo_institucional) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id`,
      [
        nombre_ie,
        docente_encargado_mt,
        pagina_web,
        direccion,
        foto_ie,
        descripcion_ie,
        telefono_institucional,
        correo_institucional
      ]
    )
    res.json(response.rows)
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.put('/instituciones-educativas/:id', async (req, res) => {
  const cliente = await pool.connect()
  try {
    const {
      nombre_ie,
      docente_encargado_mt,
      pagina_web,
      direccion,
      foto_ie,
      descripcion_ie,
      telefono_institucional,
      correo_institucional
    } = req.body
    const response = await cliente.query(
      `UPDATE instituciones_educativas SET nombre_ie = $1, docente_encargado_mt = $2, pagina_web = $3, direccion = $4, foto_ie = $5, descripcion_ie = $6, telefono_institucional = $7, correo_institucional = $8 WHERE id = $9`,
      [
        nombre_ie,
        docente_encargado_mt,
        pagina_web,
        direccion,
        foto_ie,
        descripcion_ie,
        telefono_institucional,
        correo_institucional,
        req.params.id
      ]
    )
    if (response.rowCount) {
      res.json({
        message: 'Institucion educativa actualizada'
      })
    } else {
      res.status(404).json({
        message: 'Institucion educativa no encontrada'
      })
    }
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.delete('/instituciones-educativas/:id', async (req, res) => {
  const cliente = await pool.connect()
  try {
    const response = await cliente.query(
      `DELETE FROM instituciones_educativas WHERE id = $1`,
      [req.params.id]
    )
    if (response.rowCount) {
      res.json({
        message: 'Institucion educativa eliminada'
      })
    } else {
      res.status(404).json({
        message: 'Institucion educativa no encontrada'
      })
    }
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

router.patch('/instituciones-educativas/:id', async (req, res) => {
  const cliente = await pool.connect()
  try {
    const fields = Object.keys(req.body)
    const fieldsQuery = fields
      .map(field => `${field} = ${req.body[field]}`)
      .join(', ')
    const response = await cliente.query(
      `UPDATE instituciones_educativas SET ${fieldsQuery} WHERE id = $1`,
      [...fields.map(field => req.body[field]), req.params.id]
    )
    if (response.rowCount) {
      res.json({
        message: 'Institucion educativa actualizada'
      })
    } else {
      res.status(404).json({
        message: 'Institucion educativa no encontrada'
      })
    }
  } catch (err) {
    console.log({ err })
    res.status(500).json({ error: 'Internal error server' })
  } finally {
    cliente.release(true)
  }
})

module.exports = router
