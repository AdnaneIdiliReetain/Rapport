@echo off
echo LaTeX Hot Reload Watcher
echo ========================
echo Press Ctrl+C to stop watching

cd latex

:watch_loop
echo Compiling LaTeX document...
pdflatex -interaction=nonstopmode main.tex

echo Opening PDF viewer (if not already open)...
start "" "main.pdf"

echo Waiting for changes (10 seconds)...
timeout /t 10 /nobreak > nul

goto watch_loop
