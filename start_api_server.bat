@echo off
title F1 2026 REST API Server
cd /d "%~dp0"
dart run bin\server.dart 8080
pause
