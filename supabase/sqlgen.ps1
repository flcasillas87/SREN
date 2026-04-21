param(
  [Parameter(Position = 0)]
  [string]$Command,

  [Parameter(Position = 1)]
  [string]$ObjectType,

  [Parameter(Position = 2)]
  [string]$Table,

  [Alias('s')]
  [string]$Schema = 'datos_maestros',

  [Alias('g')]
  [string]$Staging = 'staging'
)

function Show-Usage {
  Write-Host ''
  Write-Host 'Uso:' -ForegroundColor Yellow
  Write-Host '  .\sqlgen.ps1 generate table <nombre_tabla> -s <esquema> -g <esquema_staging>'
  Write-Host '  .\sqlgen.ps1 g table <nombre_tabla> -s <esquema> -g <esquema_staging>'
  Write-Host ''
  Write-Host 'Ejemplo:' -ForegroundColor Yellow
  Write-Host '  .\sqlgen.ps1 generate table cat_centros_gestores -s datos_maestros -g staging'
  Write-Host ''
}

function New-SqlFile {
  param(
    [string]$Path,
    [string]$Content
  )

  if (-not (Test-Path $Path)) {
    Set-Content -Path $Path -Value $Content -Encoding UTF8
  }
}

if ($Command -notin @('generate', 'g')) {
  Show-Usage
  exit 1
}

if ($ObjectType -notin @('table', 'tabla')) {
  Write-Host 'Por ahora solo se soporta: table' -ForegroundColor Red
  Show-Usage
  exit 1
}

if ([string]::IsNullOrWhiteSpace($Table)) {
  Write-Host 'Debes indicar el nombre de la tabla.' -ForegroundColor Red
  Show-Usage
  exit 1
}

$baseMaster = Join-Path (Join-Path $PWD $Schema) $Table
$baseStaging = Join-Path (Join-Path $PWD $Staging) $Table

$baseStage = Join-Path $baseStaging '01. staging'
$baseTransform = Join-Path $baseStaging '02. transform'
$baseLoad = Join-Path $baseStaging '03. load'

New-Item -ItemType Directory -Path $baseMaster -Force | Out-Null
New-Item -ItemType Directory -Path $baseStaging -Force | Out-Null
New-Item -ItemType Directory -Path $baseStage -Force | Out-Null
New-Item -ItemType Directory -Path $baseTransform -Force | Out-Null
New-Item -ItemType Directory -Path $baseLoad -Force | Out-Null

$masterFiles = @(
  '01_table.sql',
  '02_constraints.sql',
  '03_indexes.sql',
  '04_triggers.sql',
  '05_comments.sql',
  '06_seeds.sql',
  '07_view.sql'
)

$stageFiles = @(
  '01_create_stg.sql',
  '02_load_csv.sql'
)

$transformFiles = @(
  '01_validate.sql',
  '01_1_review.sql',
  '02_normalize.sql',
  '03_prepare_merge.sql',
  '03_1_report.sql'
)

$loadFiles = @(
  '01_merge.sql'
)

foreach ($file in $masterFiles) {
  $path = Join-Path $baseMaster $file
  $content = @"
-- =========================================================
-- Esquema: $Schema
-- Tabla: $Table
-- Archivo: $file
-- =========================================================
"@
  New-SqlFile -Path $path -Content $content
}

foreach ($file in $stageFiles) {
  $path = Join-Path $baseStage $file
  $content = @"
-- =========================================================
-- Esquema: $Staging
-- Tabla: $Table
-- Archivo: $file
-- Fase: staging
-- =========================================================
"@
  New-SqlFile -Path $path -Content $content
}

foreach ($file in $transformFiles) {
  $path = Join-Path $baseTransform $file
  $content = @"
-- =========================================================
-- Esquema: $Staging
-- Tabla: $Table
-- Archivo: $file
-- Fase: transform
-- =========================================================
"@
  New-SqlFile -Path $path -Content $content
}

foreach ($file in $loadFiles) {
  $path = Join-Path $baseLoad $file
  $content = @"
-- =========================================================
-- Esquema origen: $Staging
-- Esquema destino: $Schema
-- Tabla: $Table
-- Archivo: $file
-- Fase: load
-- =========================================================
"@
  New-SqlFile -Path $path -Content $content
}

$csvPath = Join-Path $baseStaging "$Table`_rows.csv"
New-SqlFile -Path $csvPath -Content ''

Write-Host ''
Write-Host 'Estructura creada correctamente.' -ForegroundColor Green
Write-Host "Maestro : $baseMaster"
Write-Host "Staging : $baseStaging"
