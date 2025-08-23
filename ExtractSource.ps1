$RootDir = "C:\gcp-management\mobile_admin_app"
$OutputDir = "$RootDir"
$ZipPath = Join-Path $OutputDir "filtered_source.zip"

# Excludes
$excludePatterns = @(
  "\\.git\\", "\\.dart_tool\\", "build\\", "\\.gradle\\", "\\.idea\\", "\\.vscode\\",
  "node_modules\\", "Pods\\", "DerivedData\\", "\\.android\\Flutter\\ephemeral"
)

# Includes
$includeExt = ".dart", ".yaml", ".yml", ".json", ".gradle", ".kts", ".properties",
              ".xml", ".plist", ".entitlements", ".xcconfig",
              ".kt", ".java", ".swift", ".mm", ".m", ".h", ".hpp", ".c", ".cc", ".cpp",
              ".html", ".css", ".js", ".ts", ".svg", ".png", ".jpg", ".jpeg", ".webp",
              ".ttf", ".otf", ".ico",
              ".md", ".txt", ".sh", ".bat", ".cmd", ".ps1", ".psm1",
              ".gitignore", ".gitattributes", ".cmake", ".cfg"

$alwaysInclude = "pubspec.yaml","pubspec.lock","analysis_options.yaml","melos.yaml",
                 "CMakeLists.txt","settings.gradle","build.gradle","Podfile","Package.swift",
                 "firebase.json","LICENSE","README.md"

# Collect files
$files = Get-ChildItem -Path $RootDir -Recurse -File
$includeFiles = @()
$skippedFiles = @()

foreach ($f in $files) {
  $rel = $f.FullName.Substring($RootDir.Length).TrimStart('\','/')
  $ext = $f.Extension.ToLowerInvariant()
  $name = $f.Name.ToLowerInvariant()

  if ($excludePatterns | Where-Object { $rel -match $_ }) {
    $skippedFiles += $rel
    continue
  }

  if ($alwaysInclude -contains $f.Name -or $includeExt -contains $ext -or
      $rel -match "res\\" -or $rel -match "assets\\" -or $rel -match "apps\\" -or $rel -match "packages\\") {
    $includeFiles += $f.FullName
  } else {
    $skippedFiles += $rel
  }
}

# Create zip
if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
Compress-Archive -Path $includeFiles -DestinationPath $ZipPath -CompressionLevel Optimal

"Included: $($includeFiles.Count) files"
"Skipped:  $($skippedFiles.Count) files"
"ZIP: $ZipPath"
