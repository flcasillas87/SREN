$esquemaMaestro = Read-Host 'Esquema maestro'
$esquemaStaging = Read-Host 'Esquema staging'
$tabla = Read-Host 'Nombre de la tabla'

$baseMaestro = Join-Path (Join-Path $PWD $esquemaMaestro) $tabla
$baseStaging = Join-Path (Join-Path $PWD $esquemaStaging) $tabla
$basePipeline = Join-Path (Join-Path $PWD 'pipelines') $tabla

New-Item -ItemType Directory -Path $baseMaestro -Force | Out-Null
New-Item -ItemType Directory -Path $baseStaging -Force | Out-Null
New-Item -ItemType Directory -Path $basePipeline -Force | Out-Null

$archivosMaestro = @(
  '01_table.sql',
  '02_constraints.sql',
  '03_indexes.sql',
  '04_triggers.sql',
  '05_comments.sql',
  '06_seeds.sql',
  '07_view.sql'
)

$archivosStaging = @(
  '01_table.sql',
  '02_load_csv.sql',
  '03_view.sql'
)

$archivosPipeline = @(
  '01_validate.sql',
  '02_normalize.sql',
  '03_prepare_merge.sql',
  "04_merge_to_$esquemaMaestro.sql"
)

foreach ($archivo in $archivosMaestro) {
  $ruta = Join-Path $baseMaestro $archivo
  if (-not (Test-Path $ruta)) {
    $contenido = @"
-- =========================================================
-- Esquema: $esquemaMaestro
-- Tabla: $tabla
-- Archivo: $archivo
-- =========================================================
"@
    Set-Content -Path $ruta -Value $contenido -Encoding UTF8
  }
}

foreach ($archivo in $archivosStaging) {
  $ruta = Join-Path $baseStaging $archivo
  if (-not (Test-Path $ruta)) {
    $contenido = @"
-- =========================================================
-- Esquema: $esquemaStaging
-- Tabla: $tabla
-- Archivo: $archivo
-- =========================================================
"@
    Set-Content -Path $ruta -Value $contenido -Encoding UTF8
  }
}

foreach ($archivo in $archivosPipeline) {
  $ruta = Join-Path $basePipeline $archivo
  if (-not (Test-Path $ruta)) {
    $contenido = @"
-- =========================================================
-- Pipeline: $tabla
-- Archivo: $archivo
-- Origen: $esquemaStaging.$tabla
-- Destino: $esquemaMaestro.$tabla
-- =========================================================
"@
    Set-Content -Path $ruta -Value $contenido -Encoding UTF8
  }
}

Write-Host ''
Write-Host 'Estructura creada correctamente.' -ForegroundColor Green
Write-Host "Maestro : $baseMaestro"
Write-Host "Staging : $baseStaging"
Write-Host "Pipeline: $basePipeline"
