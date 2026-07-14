-- Pendiente #13 (docs/PENDIENTES.md) — canal(es) por el que un Asistente certificado está
-- disponible: directo (asignado por la prestadora), marketplace (elegido por la Familia),
-- o ambos. Ver docs/DATA_MODEL.md sección "Tabla: asistentes" para el detalle documentado.

ALTER TABLE asistentes ADD COLUMN canales TEXT[] NOT NULL DEFAULT ARRAY['directo','marketplace'];

-- Motivo de exclusión de cada canal — NULL mientras el canal esté activo en `canales`,
-- se completa solo cuando ese canal no está habilitado para este Asistente (ej. "no acepta
-- asignación directa de la prestadora", "todavía no habilitado para marketplace por falta
-- de referencias").
ALTER TABLE asistentes ADD COLUMN motivo_exclusion_directo TEXT;
ALTER TABLE asistentes ADD COLUMN motivo_exclusion_marketplace TEXT;

ALTER TABLE asistentes ADD CONSTRAINT asistentes_canales_valido
  CHECK (canales <@ ARRAY['directo','marketplace']::TEXT[] AND array_length(canales, 1) > 0);

NOTIFY pgrst, 'reload schema';
