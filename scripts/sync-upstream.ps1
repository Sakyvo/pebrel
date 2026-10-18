#requires -version 7
<#
sync-upstream.ps1 — 把 upstream/ 快照三方合并进 src/。
用法：先删除 upstream/ 并放入新版上游源码，然后在仓库根运行本脚本。
前提：git 工作树完全干净（含 untracked 文件）。
#>
set-strictmode -version latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path 'upstream/Cargo.toml')) {
    throw 'upstream/ 缺少 Cargo.toml——请先删除旧快照并放入新版上游源码。'
}
$branch = git rev-parse --abbrev-ref HEAD
if ($branch -ne 'main') { throw "当前分支是 $branch，请先切回 main。" }
$dirty = @(git status --porcelain)
if ($dirty) {
    throw ("工作树不干净（含 untracked），请先 git add -A 并 commit：`n" + ($dirty -join "`n"))
}

$version = (Select-String -Path 'upstream/nebula_app/Cargo.toml' -Pattern '^version = "([^"]+)"' |
    Select-Object -First 1).Matches[0].Groups[1].Value
Write-Host "上游版本：v$version"

git checkout snapshot
robocopy upstream src /MIR /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy 失败，退出码 $LASTEXITCODE" }
git add -A src
if (@(git status --porcelain -- src).Count -eq 0) {
    Write-Host '快照与当前基线相同，无需同步。'
    git checkout main
    exit 0
}
git commit -m "sync upstream v$version"
git tag "upstream-v$version"

git checkout main
git merge snapshot
if ($LASTEXITCODE -ne 0) {
    $conflicts = git diff --name-only --diff-filter=U
    Write-Host "存在冲突（我们改过且上游也改过的文件），请手工解决后 git add + git commit：`n$conflicts"
    exit 1
}
Write-Host "同步完成 v$version。建议在 src/ 下跑 cargo check 验证。"
